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
package com.googlecode.flexxb.xml.serializer {
	import com.googlecode.flexxb.annotation.contract.IAnnotation;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.serializer.BaseSerializer;
	import com.googlecode.flexxb.xml.XmlDescriptionContext;
	import com.googlecode.flexxb.xml.annotation.XmlMember;
	
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	internal class XmlMemberSerializer extends BaseSerializer {
		
		public function XmlMemberSerializer(context : DescriptionContext) {
			super(context);
		}
		
		public override function serialize(object : Object, annotation : IAnnotation, serializedData : Object, serializer : SerializationCore) : Object {
			var element : XmlMember = annotation as XmlMember;
			var parentXml : XML = serializedData as XML;
			
			if (element.isDefaultValue()) {
				parentXml.appendChild(serializer.converterStore.objectToString(object, element.type));
				return null;
			}
			var location : XML = parentXml;

			if (element.isPath()) {
				location = setPathElement(element, parentXml);
			}
			
			if(element.hasNamespaceRef() && element.nameSpace != element.ownerClass.nameSpace && mustAddNamespace(element.nameSpace, parentXml)){
				parentXml.addNamespace(element.nameSpace);
			}

			serializeObject(object, element, location, serializer);

			return location;
		}

		/**
		 *
		 * @param object
		 * @param annotation
		 * @param serializer
		 * @return
		 *
		 */
		protected function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializationCore) : void {
		}
		
		public override function deserialize(serializedData : Object, annotation : IAnnotation, serializer : SerializationCore) : Object {
			var element : XmlMember = annotation as XmlMember;
			var xmlData : XML = serializedData as XML;
			if (element.isDefaultValue()) {
				for each (var child : XML in xmlData.children()) {
					if (child.nodeKind() == "text") {
						return serializer.converterStore.stringToObject(child.toXMLString(), element.type);
					}
				}
			}

			var xmlElement : XML;

			if (element.isPath()) {
				xmlElement = getPathElement(element, xmlData);
			} else {
				xmlElement = xmlData;
			}

			if (xmlElement == null) {
				return null;
			}

			var xmlName : QName;
			if (element.useOwnerAlias()) {
				xmlName = XmlDescriptionContext(context).getXmlName(element.type);
			} else {
				xmlName = element.xmlName;
			}

			var value : Object = deserializeObject(xmlElement, xmlName, element, serializer);
			return value;
		}

		/**
		 *
		 * @param xmlData
		 * @param annotation
		 * @param serializer
		 * @return
		 *
		 */
		protected function deserializeObject(xmlData : XML, xmlName : QName, annotation : XmlMember, serializer : SerializationCore) : Object {
			return null;
		}

		/**
		 *
		 * @param element
		 * @param xmlData
		 * @return
		 *
		 */
		private function getPathElement(element : XmlMember, xmlData : XML) : XML {
			var xmlElement : XML;
			var list : XMLList;
			var pathElement : QName;
			for (var i : int = 0; i < element.qualifiedPathElements.length; i++) {
				pathElement = element.qualifiedPathElements[i];
				if (!xmlElement) {
					list = xmlData.child(pathElement);
				} else {
					list = xmlElement.child(pathElement);
				}
				if (list.length() > 0) {
					xmlElement = list[0];
				} else {
					xmlElement = null;
					break;
				}
			}
			return xmlElement;
		}

		/**
		 *
		 * @param element
		 * @param xmlParent
		 * @param serializedChild
		 * @return
		 *
		 */
		private function setPathElement(element : XmlMember, xmlParent : XML) : XML {
			var cursor : XML = xmlParent;
			var count : int = 0;
			for each (var pathElement : QName in element.qualifiedPathElements) {
				var path : XMLList = cursor.child(pathElement);
				if (path.length() > 0) {
					cursor = path[0];
				} else {
					var pathItem : XML = <xml />;
					pathItem.setName(pathElement);
					cursor.appendChild(pathItem);
					cursor = pathItem;
				}
				count++;
			}
			return cursor;
		}
		
		private function mustAddNamespace(ns : Namespace, xml : XML) : Boolean{
			var inScopeNs : Array = xml.inScopeNamespaces();
			for each(var inNs : Namespace in inScopeNs){
				if(inNs.uri == ns.uri){
					return false;
				}
			}
			return true;
		}

		/**
		 *
		 * @param value
		 * @return
		 *
		 */
		protected function isComplexType(value : Object) : Boolean {
			var type : String = getQualifiedClassName(value);
			switch (type) {
				case "Number":
				case "int":
				case "uint":
				case "String":
				case "Boolean":
				case "Date":
				case "XML":
				case "Class":
					return false;break;
				default:
					return !context.hasSimpleTypeConverter(value);
			}
		}
	}
}