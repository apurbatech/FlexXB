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
package com.googlecode.flexxb.core
{
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;

	/**
	 * Triggers prior to the serialization of an object into a serialization format
	 */
	[Event(name="preserialize", type="com.googlecode.flexxb.core.SerializationEvent")]
	/**
	 * Triggers after the serialization of an AS3 object into a serialization format
	 */
	[Event(name="postserialize", type="com.googlecode.flexxb.core.SerializationEvent")]
	/**
	 * Triggers prior to the deserialization of a serialization format into an AS3 object
	 */
	[Event(name="predeserialize", type="com.googlecode.flexxb.core.SerializationEvent")]
	/**
	 * Triggers after the deserialization of a serialization format into an AS3 object
	 */
	[Event(name="postdeserialize", type="com.googlecode.flexxb.core.SerializationEvent")]	
	/**
	 * @private
	 * @author Alexutz
	 * 
	 */	
	internal final class FlexXBCore implements IFlexXB
	{
		private static const LOG : ILogger = LogFactory.getLog(IFlexXB);
				
		private var mappingModel : MappingModel;
		
		private var core : SerializationCore;
		
		private var _context : DescriptionContext;
		
		public function FlexXBCore(context : DescriptionContext, store : DescriptorStore){
			this._context = context;
			mappingModel = new MappingModel();
			mappingModel.context = context;
			mappingModel.descriptorStore = store;
			mappingModel.configuration = context.configuration;
			mappingModel.converterStore = context.converterStore;
			core = new SerializationCore(mappingModel);
		}
		
		public function get context() : DescriptionContext{
			return _context;
		}
		
		public function get configuration() : Configuration {
			return mappingModel.configuration;
		}
		
		public function processTypes(...args) : void {
			if (args && args.length > 0) {
				for each (var item : Object in args) {
					if (item is Class) {
						if(configuration.enableLogging){
							LOG.info("Processing class {0}", item);
						}
						mappingModel.descriptorStore.getDescriptor(item);
					}else if(configuration.enableLogging){
						LOG.info("Excluded from processing because it is not a class: {0}", item);
					}
				}
			}
		}
		
		public function addEventListener(type : String, listener : Function, priority : int = 0, useWeakReference : Boolean = false) : void{
			core.addEventListener(type, listener, false, priority, useWeakReference);
		}
		
		public function removeEventListener(type : String, listener : Function) : void {
			core.removeEventListener(type, listener, false);
		}
		
		public function serialize(object : Object, partial : Boolean = false, version : String = "") : Object {
			mappingModel.collisionDetector.beginDocument();
			var data : Object = core.serialize(object, partial, version);
			mappingModel.collisionDetector.endDocument();
			return data;
		}
		
		public function deserialize(source : Object, objectClass : Class = null, getFromCache : Boolean = false, version : String = "") : * {
			mappingModel.idResolver.beginDocument();
			mappingModel.collisionDetector.beginDocument();
			//determine the source document version
			if(!version && configuration.autoDetectVersion){
				version = configuration.versionExtractor.getVersion(source);
			}
			var object : Object = core.deserialize(source, objectClass, getFromCache, version);
			mappingModel.idResolver.endDocument();
			mappingModel.collisionDetector.endDocument();
			return object;
		}
	}
}