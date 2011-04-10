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
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaParser;
	import com.googlecode.flexxb.interfaces.ISerializable;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.DescribeTypeCache;

	/**
	 *
	 * @author aCiobanu
	 *
	 */
	internal final class DescriptorStore implements IDescriptorStore {
		/**
		 * @private 
		 */		
		private var descriptorCache : Dictionary = new Dictionary();
		/**
		 * @private 
		 */		
		private var parser : MetaParser = new MetaParser();
		
		public function getDescriptor(item : Object, version : String = "") : IClassAnnotation {
			var className : String = getQualifiedClassName(item);
			return getDefinition(item, className).getDescriptor(version);
		}
			
		public function getClassReferenceByCriteria(field : String, value : String, version : String = "") : Class{
			var descriptor : Object;
			for each (var store : ResultStore in descriptorCache) {
				descriptor = store.getDescriptor(version);
				if (descriptor && descriptor.hasOwnProperty(field) && descriptor[field] == value) {
					return IClassAnnotation(descriptor).type;
				}
			}
			return null;
		}

		/**
		 * Determine whether the object is custom serializable or not
		 * @param object
		 * @return true if the object is custom serialisable, false otherwise
		 *
		 */
		public function isCustomSerializable(item : Object) : Boolean {
			var className : String = getQualifiedClassName(item);
			return getDefinition(item, className).reference != null;
		}

		/**
		 * Get the reference instance defined for a custom serializable type
		 * @param clasz
		 * @return object type instance
		 *
		 */
		public function getCustomSerializableReference(clasz : Class) : ISerializable {
			var className : String = getQualifiedClassName(clasz);
			return getDefinition(clasz, className).reference as ISerializable;
		}
		
		/**
		 *
		 * @param xmlDescriptor
		 * @param type
		 *
		 */
		public function registerDescriptor(xmlDescriptor : XML, type : Class) : void {
			var className : String = getQualifiedClassName(type);
			if (hasDescriptorDefined(className)) {
				return;
			}
			putDescriptorInCache(xmlDescriptor, className, false);
		}

		private function xmlDescribeType(xmlDescriptor : XML) : Array {
			//get class annotation				
			var descriptors : Array = parser.parseDescriptor(xmlDescriptor);
			return descriptors;
		}

		private function hasDescriptorDefined(className : String) : Boolean {
			return descriptorCache && descriptorCache[className] != null;
		}

		private function getDefinition(object : Object, className : String) : ResultStore {
			if (!hasDescriptorDefined(className)) {
				put(object, className);
			}
			return descriptorCache[className];
		}

		private function put(object : Object, className : String) : void {
			var descriptor : XML = DescribeTypeCache.describeType(object).typeDescription;
			var interfaces : XMLList;
			if (descriptor.factory.length() > 0) {
				interfaces = descriptor.factory.implementsInterface;
			} else {
				interfaces = descriptor.implementsInterface;
			}
			var customSerializable : Boolean;
			for each (var interf : XML in interfaces) {
				if (interf.@type.toString() == "com.googlecode.flexxb.interfaces::ISerializable") {
					customSerializable = true;
					break;
				}
			}
			putDescriptorInCache(descriptor, className, customSerializable);
		}

		private function putDescriptorInCache(descriptor : XML, className : String, customSerializable : Boolean) : void {
			var xmlClasses : Array;
			var referenceObject : Object;
			if (customSerializable) {
				var cls : Class = getDefinitionByName(className) as Class;
				referenceObject = new cls();
			} else {
				xmlClasses = xmlDescribeType(descriptor);
			}
			var result : Object = new ResultStore(xmlClasses, customSerializable, referenceObject);
			descriptorCache[className] = result;
		}
	}
}
import com.googlecode.flexxb.annotation.contract.Constants;
import com.googlecode.flexxb.annotation.contract.IClassAnnotation;

import flash.utils.Dictionary;

/**
 *
 * @author Alexutz
 * @private
 */
internal class ResultStore {
	/**
	 * @private
	 */
	private var descriptors : Dictionary;
	/**
	 * @private
	 */
	public var customSerializable : Boolean;
	/**
	 * @private
	 */
	public var reference : Object;

	/**
	 * @private
	 * @param descriptor
	 * @param customSerializable
	 * @param reference
	 *
	 */
	public function ResultStore(descriptors : Array, customSerializable : Boolean, reference : Object) {
		this.customSerializable = customSerializable;
		this.reference = reference;
		this.descriptors = new Dictionary();
		for each(var descriptor : IClassAnnotation in descriptors){
			this.descriptors[descriptor.version ? descriptor.version : Constants.DEFAULT] = descriptor;
		}
	}
	/**
	 * Get the descriptor associated to the version supplied. If none is found
	 * the default descriptor will be returned 
	 * @param version version value
	 * @return IClassAnnotation implementor instance
	 * 
	 */	
	public function getDescriptor(version : String) : IClassAnnotation{
		var annotationVersion : String = version;
		if(!descriptors[annotationVersion]){
			annotationVersion = Constants.DEFAULT;
		}
		return descriptors[annotationVersion] as IClassAnnotation;
	}
}