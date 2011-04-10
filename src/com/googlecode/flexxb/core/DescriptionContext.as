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
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.Constants;
	import com.googlecode.flexxb.annotation.contract.ConstructorArgument;
	import com.googlecode.flexxb.converter.IConverter;
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Description context is the main access point for instructing the engine how to handle a specific serialization format.
	 * The context registers annotations, serializers, converters and offers additional methods to assist the registered
	 * serializers with the handling of that serialization format. A context also has an instance of a configuration object; 
	 * as is the case with different formats, additional settings are needed for configuring the mechanism. One may extend the 
	 * default configuration object to add settings as needed and reference them in the serializers.
	 * <p>This class must be extended if one is to provide a new serialization format support. In subclasses the method 
	 * <code>performInitialization</code> must be overriden in order to register serializers, annotations and converters.</p>
	 *  
	 * @author Alexutz
	 * 
	 */	
	public class DescriptionContext
	{
		private var _store : IDescriptorStore;
		private var _converterStore : ConverterStore;
		protected var _configuration : Configuration;
		private var _engine : FxBEngine;
		/**
		 * Constructor
		 * 
		 */		
		public function DescriptionContext(){ }
		/**
		 * @private
		 * @param engine
		 * @param store
		 * @param configuration
		 * 
		 */		
		internal final function initializeContext(engine : FxBEngine, descriptorStore : IDescriptorStore) : void{
			_store = descriptorStore;
			_converterStore = new ConverterStore();
			_engine = engine;
			//register the annotations we know must always exist
			registerAnnotation(Constants.ANNOTATION_CONSTRUCTOR_ARGUMENT, ConstructorArgument, null);
			performInitialization();
		}
		/**
		 * @private
		 * @return 
		 * 
		 */
		internal final function get converterStore() : ConverterStore{
			return _converterStore;
		}
		/**
		 * Get a configuration instance attached to the current description context
		 * @return 
		 * 
		 */
		public function get configuration() : Configuration{
			if(!_configuration){
				_configuration = new Configuration();
			}
			return _configuration;
		}
		/**
		 * Set a configuration instance attached to the current description context
		 * @param value
		 * 
		 */		
		public function set configuration(value : Configuration) : void{
			if(value){
				_configuration = value;
			}
		}
		/**
		 * Get the object type associated with the incoming serialized form.</br>
		 * Override this method in subclasses because each serialization format has 
		 * different ways of determining the type of teh object to be used in 
		 * deserialization.  
		 * @param source serialized form
		 * @return object type
		 * 
		 */		
		public function getIncomingType(source : Object) : Class{
			return null;
		}
		/**
		 * Once a new type has been processed, the context has the chance to handle the descriptors in order to construct 
		 * internal structures it may need (for example, in handling XML, determine the type by the namespace used).
		 * @param descriptors
		 * 
		 */		
		public function handleDescriptors(descriptors : Array) : void {}
		/**
		 * Override in subclasses to initialize your context by 
		 * registering annotations and converters
		 * 
		 */		
		protected function performInitialization() : void { }
		/**
		 * Get a reference to the descriptor store
		 * @return 
		 * 
		 */		
		protected final function get descriptorStore() : IDescriptorStore{
			return _store;
		}
		/**
		 * Register a converter instance for a specific type
		 * @param converter converter instance
		 * @param overrideExisting override existing registrations under the same class type
		 * @return 
		 * 
		 */		
		public final function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean {
			return _converterStore.registerSimpleTypeConverter(converter, overrideExisting);
		}
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		public final function hasSimpleTypeConverter(object : Object) : Boolean {
			return object && _converterStore.hasConverter(getDefinitionByName(getQualifiedClassName(object)) as Class);
		}
		/**
		 * Register a new annotation and its serializer. If it finds a registration with the
		 * same name and <code>overrideExisting </code> is set to <code>false</code>, it will disregard the current attempt and keep the old value.
		 * @param name the name of the annotation to be registered
		 * @param annotationClazz annotation class type
		 * @param serializerInstance instance of the serializer that will handle this annotation
		 * @param overrideExisting override existing registrations under the same name
		 * 
		 */		
		public final function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void {
			AnnotationFactory.instance.registerAnnotation(name, annotationClazz, serializer, this, overrideExisting);
		}
		/**
		 * Specify api classes that reflect the defined annotations. 
		 * @param args 
		 * 
		 */		
		public final function setApiClasses(classType : Class, ...args) : void{
			_store.getDescriptor(classType);
			for each(var type : Class in args){
				if(type is Class){
					_store.getDescriptor(type);
				}
			}
		}
	}
}