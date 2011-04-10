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
package com.googlecode.flexxb.xml
{
	import com.googlecode.flexxb.converter.ClassTypeConverter;
	import com.googlecode.flexxb.converter.XmlConverter;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	import com.googlecode.flexxb.xml.annotation.XmlAttribute;
	import com.googlecode.flexxb.xml.annotation.XmlClass;
	import com.googlecode.flexxb.xml.annotation.XmlConstants;
	import com.googlecode.flexxb.xml.annotation.XmlElement;
	import com.googlecode.flexxb.xml.annotation.XmlNamespace;
	import com.googlecode.flexxb.xml.api.XmlApiArray;
	import com.googlecode.flexxb.xml.api.XmlApiAttribute;
	import com.googlecode.flexxb.xml.api.XmlApiClass;
	import com.googlecode.flexxb.xml.api.XmlApiElement;
	import com.googlecode.flexxb.xml.api.XmlApiNamespace;
	import com.googlecode.flexxb.xml.serializer.XmlArraySerializer;
	import com.googlecode.flexxb.xml.serializer.XmlAttributeSerializer;
	import com.googlecode.flexxb.xml.serializer.XmlClassSerializer;
	import com.googlecode.flexxb.xml.serializer.XmlElementSerializer;
	
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class XmlDescriptionContext extends DescriptionContext
	{
		
		private var classNamespaceMap : Dictionary;
		
		public function XmlDescriptionContext(){
			super();
			_configuration = new XmlConfiguration();
		}
		
		protected override function performInitialization() : void{
			registerSimpleTypeConverter(new ClassTypeConverter());
			registerSimpleTypeConverter(new XmlConverter());
			
			registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer);
			registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer);
			registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer);
			registerAnnotation(XmlConstants.ANNOTATION_NAMESPACE, XmlNamespace, null);
			
			setApiClasses(XmlApiClass, XmlApiArray, XmlApiAttribute, XmlApiElement, XmlApiNamespace);
		}
		
		public override function handleDescriptors(descriptors : Array) : void {
			for each(var classDescriptor : XmlClass in descriptors){
				//if the class descriptor defines a namespace, register it in the namespace map
				if (classDescriptor.nameSpace) {
					if (!classNamespaceMap) {
						classNamespaceMap = new Dictionary();
					}
					classNamespaceMap[classDescriptor.nameSpace.uri] = classDescriptor.type;
				}
			}
		}
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		public function getNamespace(object : Object, version : String = "") : Namespace {
			if (object) {
				var desc : XmlClass = descriptorStore.getDescriptor(object, version) as XmlClass;
				if (desc) {
					return desc.nameSpace;
				}
			}
			return null;
		}
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		public function getXmlName(object : Object, version : String = "") : QName {
			if (object != null) {
				var classDescriptor : XmlClass = descriptorStore.getDescriptor(object, version) as XmlClass;
				if (classDescriptor) {
					return classDescriptor.xmlName;
				}
			}
			return null;
		}
		/**
		 * 
		 * @param ns
		 * @return 
		 * 
		 */		
		public function getClassByNamespace(ns : String) : Class {
			if (classNamespaceMap) {
				return classNamespaceMap[ns] as Class;
			}
			return null;
		}		
		/**
		 *
		 * @param name
		 * @return
		 *
		 */
		public function getClassByAlias(name : String, version : String = "") : Class {
			return descriptorStore.getClassReferenceByCriteria("alias", name, version);
		}
		
		public override function getIncomingType(source : Object) : Class {
			var incomingXML : XML = source as XML;
			if (incomingXML) {
				if (XmlConfiguration(configuration).getResponseTypeByTagName) {
					var tagName : QName = incomingXML.name() as QName;
					if (tagName) {
						var clasz : Class = getClassByAlias(tagName.localName);
						if (clasz) {
							return clasz;
						}
					}
				}
				if (XmlConfiguration(configuration).getResponseTypeByNamespace) {
					if (incomingXML.namespaceDeclarations().length > 0) {
						var _namespace : String = (incomingXML.namespaceDeclarations()[0] as Namespace).uri;
						return getClassByNamespace(_namespace);
					}
				}
				
			}
			return null;
		}
	}
}