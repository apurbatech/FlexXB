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
	import com.googlecode.flexxb.xml.annotation.XmlConstants;
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.api.FxField;
	
	[XmlClass(alias="XmlArray")]
	[ConstructorArg(reference="field")]
	[ConstructorArg(reference="alias")]
	/**
	 * 
	 * @author Alexutzutz
	 * 
	 */	
	public class XmlApiArray extends XmlApiElement {
		public static const INCOMING_XML_NAME : String = "XmlArray";

		/**
		 *
		 * @param name
		 * @param type
		 * @param accessType
		 * @param alias
		 * @return
		 *
		 */
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : XmlApiArray {
			var field : FxField = new FxField(name, type, accessType);
			var array : XmlApiArray = new XmlApiArray(field, alias);
			return array;
		}
		/**
		 *
		 */
		[XmlAttribute]
		public var memberName : String;
		/**
		 *
		 */
		[XmlAttribute]
		public var memberType : Class;

		/**
		 *
		 * @param field
		 * @param alias
		 *
		 */
		public function XmlApiArray(field : FxField, alias : String = null) {
			super(field, alias);
		}

		public override function getMetadataName() : String {
			return XmlArray.ANNOTATION_NAME;
		}

		public override function getMappingValues() : Dictionary{
			var values : Dictionary = super.getMappingValues();
			if(memberName){
				values[XmlConstants.MEMBER_NAME] = memberName;
			}
			if(memberType is Class){
				values[XmlConstants.TYPE] =  getQualifiedClassName(memberType);
			}
			return values;
		}
		
		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public override function toString() : String {
			return "Array[field: " + fieldName + ", type:" + fieldType + "]";
		}
	}
}