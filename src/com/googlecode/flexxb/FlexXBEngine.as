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
package com.googlecode.flexxb {
	import com.googlecode.flexxb.api.IFlexXBApi;
	import com.googlecode.flexxb.converter.IConverter;
	import com.googlecode.flexxb.core.IFlexXB;
	import com.googlecode.flexxb.xml.XmlConfiguration;

	/**
	 * Entry point for AS3-XML (de)serialization. Allows new annotation registration.
	 * The main access point consist of two methods: <code>serialize()</code> and 
	 * <code>deserialize</code>, each corresponding to the specific stage in the 
	 * conversion process.
	 * @author aCiobanu
	 * @deprecated This class now only points to the xml serialization mechanism, for
	 * backwards compatibility reasons. You may keep using it if you only need the xml
	 * processing.
	 */
	public final class FlexXBEngine {
		private static var _instance : FlexXBEngine;
		
		private static var staticAccess : Boolean;

		/**
		 * Not a singleton, but an easy access instance.
		 * @return instance of FlexXBEngine
		 *
		 */
		public static function get instance() : FlexXBEngine {
			if (!_instance) {
				staticAccess = true;
				_instance = new FlexXBEngine();
				staticAccess = false;
				_instance.v2Engine = com.googlecode.flexxb.core.FxBEngine.instance;
			}
			return _instance;
		}
		
		private var v2Engine : com.googlecode.flexxb.core.FxBEngine;
		
		private var _xmlSerializer : IFlexXB;
		
		/**
		 * Constructor
		 *
		 */
		public function FlexXBEngine() {
			if(!staticAccess){
				v2Engine = new com.googlecode.flexxb.core.FxBEngine();
			}
		}

		/**
		 * Get a reference to the configuration object
		 * @return instance of type <code>com.googlecode.flexxb.Configuration</code>
		 *
		 */
		public function get configuration() : XmlConfiguration {
			return xmlSerializer.configuration as XmlConfiguration;
		}

		/**
		 * Get a reference to the api object
		 * @return instance of type <code>com.googlecode.flexxb.api.IFlexXBApi</code>
		 *
		 */
		public function get api() : IFlexXBApi {
			return v2Engine.api;
		}

		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @param partial serialize the object in partial mode (only the object tag with id field)
		 * @param version 
		 * @return xml representation of the given object
		 *
		 */
		public function serialize(object : Object, partial : Boolean = false, version : String = "") : XML {
			return xmlSerializer.serialize(object, partial, version) as XML;
		}

		/**
		 * Convert an xml to an AS3 object counterpart
		 * @param xmlData xml to be deserialized
		 * @param objectClass object class
		 * @param getFromCache get the object from the model object cache if it exists, without applying the xml
		 * @param version
		 * @return object of type objectClass
		 *
		 */
		public function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false, version : String = "") : * {
			return xmlSerializer.deserialize(xmlData, objectClass, getFromCache, version);
		}

		/**
		 * Do an early processing of types involved in the communication process if one
		 * wants to bypass the lazy processing method implemented by the serializer.
		 * @param args types to be processed
		 *
		 */
		public function processTypes(... args) : void {
			xmlSerializer.processTypes.apply(_xmlSerializer, args);
		}

		/**
		 * Register a converter that defines how string values
		 * are transformed to a simple type object and viceversa
		 * @param converter converter instance
		 * @param overrideExisting override an existing converter for the specified type
		 * @return
		 *
		 */
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean {
			return xmlSerializer.context.registerSimpleTypeConverter(converter, overrideExisting);
		}
		
		public function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false)
		{
			return xmlSerializer.context.registerAnnotation(name, annotationClazz, serializer, overrideExisting);
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			xmlSerializer.addEventListener(type, listener, priority, useWeakReference);
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			xmlSerializer.removeEventListener(type, listener);
		}
		
		private function get xmlSerializer() : IFlexXB{
			if(!_xmlSerializer){
				_xmlSerializer = v2Engine.getXmlSerializer();
			}
			return _xmlSerializer;
		}
	}
}