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
package com.googlecode.flexxb.xml.api {
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.api.FxField;
	import com.googlecode.flexxb.xml.annotation.XmlConstants;
	import com.googlecode.flexxb.xml.annotation.XmlElement;
	
	import flash.utils.Dictionary;
	
	[XmlClass(alias="XmlElement")]
	[ConstructorArg(reference="field")]
	[ConstructorArg(reference="alias")]
	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class XmlApiElement extends XmlApiMember {
		public static const INCOMING_XML_NAME : String = "XmlElement";

		/**
		 *
		 * @param name
		 * @param type
		 * @param accessType
		 * @param alias
		 * @return
		 *
		 */
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : XmlApiElement {
			var field : FxField = new FxField(name, type, accessType);
			var element : XmlApiElement = new XmlApiElement(field, alias);
			return element;
		}
		/**
		 *
		 */
		[XmlAttribute]
		public var getFromCache : Boolean;
		/**
		 *
		 */
		[XmlAttribute]
		public var serializePartialElement : Boolean;
		/**
		 *
		 */
		[XmlAttribute]
		public var getRuntimeType : Boolean;

		/**
		 *
		 * @param field
		 * @param alias
		 *
		 */
		public function XmlApiElement(field : FxField, alias : String = null) {
			super(field, alias);
		}

		public override function getMetadataName() : String {
			return XmlElement.ANNOTATION_NAME;
		}

		public override function getMappingValues() : Dictionary{
			var values : Dictionary = super.getMappingValues();
			values[XmlConstants.GET_FROM_CACHE] = getFromCache;
			values[XmlConstants.SERIALIZE_PARTIAL_ELEMENT] = serializePartialElement;
			values[XmlConstants.GET_RUNTIME_TYPE] = getRuntimeType;
			return values;
		}
		
		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public function toString() : String {
			return "XmlElement[field: " + fieldName + ", type:" + fieldType + "]";
		}
	}
}