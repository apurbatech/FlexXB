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
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.annotation.contract.IAnnotation;
	import com.googlecode.flexxb.annotation.contract.IMemberAnnotation;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.xml.annotation.XmlClass;
	import com.googlecode.flexxb.xml.XmlDescriptionContext;
	import com.googlecode.flexxb.serializer.BaseSerializer;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public final class XmlClassSerializer extends BaseSerializer {
		
		private static const LOG : ILogger = LogFactory.getLog(XmlClassSerializer);
		
		public function XmlClassSerializer(context : DescriptionContext){
			super(context);
		}
		
		public override function serialize(object : Object, annotation : IAnnotation, serializedData : Object, serializer : SerializationCore) : Object {
			var xmlClass : XmlClass = annotation as XmlClass;
			if(serializer.configuration.enableLogging){
				LOG.info("Serializing object of type {0}", xmlClass.name);
			}
			var xml : XML = <xml />;
			xml.setNamespace(xmlClass.nameSpace);
			xml.setName(new QName(xmlClass.nameSpace, xmlClass.alias));
			if (xmlClass.useOwnNamespace()) {
				xml.addNamespace(xmlClass.nameSpace);
			} else {
				var member : IMemberAnnotation = xmlClass.getMember(xmlClass.childNameSpaceFieldName);
				if (member) {
					var ns : Namespace = XmlDescriptionContext(context).getNamespace(object[member.name]);
					if (ns) {
						xml.addNamespace(ns);
					}
				}
			}
			return xml;
		}
		
		public override function deserialize(serializedData : Object, annotation : IAnnotation, serializer : SerializationCore) : Object {
			return null;
		}
	}
}