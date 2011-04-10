/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2011 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.core {
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.contract.IFieldAnnotation;
	import com.googlecode.flexxb.annotation.contract.IMemberAnnotation;
	import com.googlecode.flexxb.annotation.contract.Stage;
	import com.googlecode.flexxb.interfaces.ICycleRecoverable;
	import com.googlecode.flexxb.interfaces.ISerializable;
	import com.googlecode.flexxb.persistence.IPersistable;
	import com.googlecode.flexxb.persistence.PersistableObject;
	import com.googlecode.flexxb.serializer.BaseSerializer;
	import com.googlecode.flexxb.util.Instanciator;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
	import flash.events.EventDispatcher;
	
	/**
	 * @private
	 * @author Alexutz
	 *
	 */
	public final class SerializationCore extends EventDispatcher {
		
		private static const LOG : ILogger = LogFactory.getLog(SerializationCore);
		
		private var mappingModel : MappingModel;

		/**
		 * Constructor
		 *
		 */
		public function SerializationCore(mappingModel : MappingModel){
			if (!MappingModel) {
				throw new Error("Mapping model must not be null");
			}
			this.mappingModel = mappingModel;
			addEventListener(SerializationEvent.PRE_DESERIALIZE, onPreDeserialize, false, 150, true);
			addEventListener(SerializationEvent.POST_DESERIALIZE, onPostDeserialize, false, 150, true);
		}
		
		public function get configuration() : Configuration{
			return mappingModel.configuration;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get descriptorStore() : IDescriptorStore {
			return mappingModel.descriptorStore;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get converterStore() : IConverterStore {
			return mappingModel.converterStore;
		}
		
		public function get idResolver() : IdResolver{
			return mappingModel.idResolver;
		}
		
		public function get currentObject() : Object{
			return mappingModel.collisionDetector.getCurrent();
		}

		/**
		 * Convert an object to a serialized representation.
		 * @param object object to be converted.
		 * @param version
		 * @return serialized data representation of the given object
		 *
		 */
		public final function serialize(object : Object, partial : Boolean = false, version : String = "") : Object {
			if(configuration.enableLogging){
				LOG.info("Started object serialization. Partial flag is {0}", partial);
			}
			if (object == null) {
				if(configuration.enableLogging){
					LOG.info("Object is null. Ended serialization");
				}
				return null;
			}
			var serializedData : Object;
			
			object = pushObject(object, partial);
			
			mappingModel.processNotifier.notifyPreSerialize(this, serializedData);

			if (mappingModel.descriptorStore.isCustomSerializable(object)) {
				serializedData = ISerializable(object).serialize();
			} else {
				var classDescriptor : IClassAnnotation = mappingModel.descriptorStore.getDescriptor(object, version);
				serializedData = AnnotationFactory.instance.getSerializer(classDescriptor).serialize(object, classDescriptor, null, this);
				var serializer : BaseSerializer;
				var annotation : IMemberAnnotation;
				if (partial && classDescriptor.idField) {
					doSerialize(object, classDescriptor.idField, serializedData);
				} else if (configuration.onlySerializeChangedValueFields && object is PersistableObject) {
					for each (annotation in classDescriptor.members) {
						if (annotation.writeOnly  || annotation.ignoreOn == Stage.SERIALIZE || !PersistableObject(object).isChanged(annotation.name.localName)) {
							continue;
						}
						doSerialize(object, annotation, serializedData);
					}
				} else {
					for each (annotation in classDescriptor.members) {
						if (annotation.writeOnly || annotation.ignoreOn == Stage.SERIALIZE) {
							continue;
						}
						doSerialize(object, annotation, serializedData);
					}
				}
			}

			mappingModel.processNotifier.notifyPostSerialize(this, serializedData);
			
			mappingModel.collisionDetector.pop();
			
			if(configuration.enableLogging){
				LOG.info("Ended object serialization");
			}
			
			return serializedData;
		}
		
		public function getObjectId(object : Object) : String{
			var classDescriptor : IClassAnnotation = mappingModel.descriptorStore.getDescriptor(object);
			if(classDescriptor.idField){
				return object[classDescriptor.idField.name];
			}
			return "";
		} 
		
		private function pushObject(obj : Object, partial : Boolean) : Object{
			var collisionDetected : Boolean = !mappingModel.collisionDetector.push(obj);
			if(collisionDetected){
				if(partial){
					mappingModel.collisionDetector.pushNoCheck(obj);
				}else if(obj is ICycleRecoverable){
					obj = ICycleRecoverable(obj).onCycleDetected(mappingModel.collisionDetector.getCurrent());
					obj = pushObject(obj, partial);
				}else{
					throw new Error("Cycle detected!");
				}
			}
			return obj;
		}

		/**
		 *
		 * @param object
		 * @param annotation
		 * @param serializedData
		 *
		 */
		private function doSerialize(object : Object, annotation : IFieldAnnotation, serializedData : Object) : void {
			if(configuration.enableLogging){
				LOG.info("Serializing field {0} as {1}", annotation.name, annotation.annotationName);
			}
			var serializer : BaseSerializer = AnnotationFactory.instance.getSerializer(annotation);
			var target : Object = object[annotation.name];
			if (target != null) {
				serializer.serialize(target, annotation, serializedData, this);
			}
		}

		/**
		 * Convert a serialized data to an AS3 object counterpart
		 * @param serializedData data to be deserialized
		 * @param objectClass object class
		 * @param getFromCache
		 * @param version
		 * @return object of type objectClass
		 *
		 */
		public final function deserialize(serializedData : Object, objectClass : Class = null, getFromCache : Boolean = false, version : String = "") : Object {
			if(configuration.enableLogging){
				LOG.info("Started deserialization to type {0}. GetFromCache flag is {1}", objectClass, getFromCache);
			}
			if (serializedData) {
				if (!objectClass) {
					objectClass = mappingModel.context.getIncomingType(serializedData);
				}
				if (objectClass) {
					var result : Object;
					var itemId : String = getId(objectClass, serializedData);
					var foundInCache : Boolean;

					//get object from cache
					if (configuration.allowCaching && itemId && configuration.cacheProvider.isInCache(itemId, objectClass)) {
						if (getFromCache) {
							return configuration.cacheProvider.getFromCache(itemId, objectClass);
						}
						result = configuration.cacheProvider.getFromCache(itemId, objectClass);
						foundInCache = result != null;
					}

					var classDescriptor : IClassAnnotation;
					if (!mappingModel.descriptorStore.isCustomSerializable(objectClass)) {
						classDescriptor = mappingModel.descriptorStore.getDescriptor(objectClass, version);
					}

					if (!foundInCache) {
						//if object is auto processed, get constructor arguments declarations
						var _arguments : Array;
						if (!mappingModel.descriptorStore.isCustomSerializable(objectClass) && !classDescriptor.constructor.isDefault()) {
							_arguments = [];
							var stageCache : Stage;
							for each (var member : IMemberAnnotation in classDescriptor.constructor.parameterFields) {
								//On deserialization, when using constructor arguments, we need to process them even though the ignoreOn 
								//flag is set to deserialize stage.
								var data : Object = AnnotationFactory.instance.getSerializer(member).deserialize(serializedData, member, this);
								_arguments.push(data);
							}
						}
						//create object instance
						if(configuration.allowCaching){
							result = configuration.cacheProvider.getNewInstance(objectClass, itemId, _arguments);
						}else{
							result = Instanciator.getInstance(objectClass, _arguments);
						}
					}
					
					if(itemId){
						mappingModel.idResolver.bind(itemId, result);
					}
					
					mappingModel.collisionDetector.pushNoCheck(result);
					
					//dispatch preDeserializeEvent
					mappingModel.processNotifier.notifyPreDeserialize(this, result, serializedData);
					
					//update object fields
					if (mappingModel.descriptorStore.isCustomSerializable(objectClass)) {
						ISerializable(result).deserialize(serializedData);
					} else {
						//iterate through anotations
						for each (var annotation : IMemberAnnotation in classDescriptor.members) {
							if (annotation.readOnly || classDescriptor.constructor.hasParameterField(annotation)) {
								continue;
							}
							if(annotation.ignoreOn == Stage.DESERIALIZE){
								// Let's keep the old behavior for now. If the ignoreOn flag is set on deserialize, 
								// the field's value is set to null.
								// TODO: check if this can be removed
								result[annotation.name] = null;
							}else{
								var serializer : BaseSerializer = AnnotationFactory.instance.getSerializer(annotation);
								result[annotation.name] = serializer.deserialize(serializedData, annotation, this);
							}
						}
					}
					//dispatch postDeserializeEvent
					mappingModel.processNotifier.notifyPostDeserialize(this, result, serializedData);
					
					mappingModel.collisionDetector.pop();
					
					if(configuration.enableLogging){
						LOG.info("Ended deserialization");
					}
					
					return result;
				}
			}
			if(configuration.enableLogging){
				LOG.info("Ended deserialization");
			}
			return null;
		} 
		/**
		 *
		 * @param result
		 * @param serializedData
		 * @return
		 *
		 */
		private function getId(objectClass : Class, serializedData : Object) : String {
			var itemId : String;
			if (mappingModel.descriptorStore.isCustomSerializable(objectClass)) {
				itemId = mappingModel.descriptorStore.getCustomSerializableReference(objectClass).getIdValue(serializedData);
			} else {
				var classDescriptor : IClassAnnotation = mappingModel.descriptorStore.getDescriptor(objectClass);
				var idSerializer : BaseSerializer = AnnotationFactory.instance.getSerializer(classDescriptor.idField);
				if (idSerializer) {
					itemId = String(idSerializer.deserialize(serializedData, classDescriptor.idField, this));
				}
			}
			return itemId;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onPreDeserialize(event : SerializationEvent) : void {
			if (event.object is IPersistable) {
				IPersistable(event.object).stopListening();
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onPostDeserialize(event : SerializationEvent) : void {
			var result : Object = event.object;
			if (result is IPersistable) {
				IPersistable(result).commit();
				IPersistable(result).startListening();
			}
		}
	}
}