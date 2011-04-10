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
	import com.googlecode.flexxb.core.Configuration;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	import com.googlecode.flexxb.xml.XmlConfiguration;
	import com.googlecode.flexxb.xml.XmlDescriptionContext;
	import com.googlecode.flexxb.xml.annotation.XmlElement;
	import com.googlecode.flexxb.xml.annotation.XmlMember;
	import com.googlecode.flexxb.xml.util.cdata;
	
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlElement annotation
	 * @author Alexutz
	 *
	 */
	public class XmlElementSerializer extends XmlMemberSerializer {
		
		private static const LOG : ILogger = LogFactory.getLog(XmlElementSerializer);
		/**
		 * Constructor
		 *
		 */
		public function XmlElementSerializer(context : DescriptionContext) {
			super(context);
		}
		
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializationCore) : void {
			var child : XML = <xml />;
			if (isComplexType(object) && !(object is Class)) {
				if(annotation.isIDRef){
					child.appendChild(serializer.getObjectId(object));
				}else{
					child = serializer.serialize(object, XmlElement(annotation).serializePartialElement) as XML;
				}
			}else if(annotation.type == XML){
				child.appendChild(new XML(object));
			}else{
				var stringValue : String = serializer.converterStore.objectToString(object, annotation.type);
				try {
					child.appendChild(stringValue);
				} catch (error : Error) {
					child.appendChild(escapeValue(stringValue, serializer.configuration as XmlConfiguration));
				}
			}

			if (annotation.useOwnerAlias()) {
				var name : QName = XmlDescriptionContext(context).getXmlName(object);
				if (name) {
					child.setName(name);
				}
			} else if (annotation.xmlName) {
				child.setName(annotation.xmlName);
			}
			parentXml.appendChild(child);
		}
		
		protected final function escapeValue(value : *, configuration : XmlConfiguration) : XML{
			if(configuration.escapeSpecialChars){
				return XML(new XMLNode(XMLNodeType.TEXT_NODE, value));
			}else{
				return cdata(value);
			}
		}
		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : SerializationCore) : Object {
			if(serializer.configuration.enableLogging){
				LOG.info("Deserializing element <<{0}>> to field {1}", xmlName, element.name);
			}
			var list : XMLList = xmlData.child(xmlName);
			var xml : XML;
			if (list.length() > 0){
				xml = list[0];
			}else{
				if(element.defaultSetValue){
					xml = XML(element.defaultSetValue);
				}else{
					return null;
				}
			}
			if(element.isIDRef){
				serializer.idResolver.addResolutionTask(serializer.currentObject, element.name, xml.toString());
				return null;
			}
			
			var type : Class = element.type;
			if (XmlElement(element).getRuntimeType) {
				type = XmlDescriptionContext(context).getIncomingType(list[0]);
				if (!type) {
					type = element.type;
				}
			}
			return getValue(xml, type, XmlElement(element).getFromCache, serializer);
		}
		
		protected final function getValue(xml : XML, type : Class, getFromCache : Boolean, serializer : SerializationCore) : Object{
			if (isComplexType(type)) {
				return serializer.deserialize(xml, type, getFromCache);
			}
			var stringValue : String = xml.toString();
			//FIX: if the type is XML then we have a bit of processing to do
			//xml data is stored as child of an xml element whch can be namespaced
			//we remove the wrapper, along with its namespace(s) and keep the
			//content.
			if(type == XML){
				stringValue = xml.toXMLString();
				if(xml.length() > 0){
					stringValue = stringValue.substring(stringValue.indexOf(">") + 1, stringValue.lastIndexOf("<") - 1);
				}else{
					stringValue = "";
				}
			}
			return serializer.converterStore.stringToObject(stringValue, type);
		}
	}
}