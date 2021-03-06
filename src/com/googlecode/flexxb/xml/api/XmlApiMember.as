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
	import com.googlecode.flexxb.api.FxField;
	import com.googlecode.flexxb.api.FxMember;
	import com.googlecode.flexxb.api.flexxb_api_internal;
	import com.googlecode.flexxb.xml.annotation.XmlConstants;
	
	import flash.utils.Dictionary;

	use namespace flexxb_api_internal;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	internal class XmlApiMember extends FxMember {
				
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var alias : String;
		
		[XmlAttribute]
		/**
		 * 
		 *  @default
		 */		
		public var idref : Boolean;
		
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var order : Number;
		
		/**
		 * @private
		 */		
		protected var _nameSpace : XmlApiNamespace;
		
		/**
		 *
		 * @param field
		 * @param alias
		 *
		 */
		public function XmlApiMember(field : FxField, alias : String = null) {
			super(field);
			this.alias = alias;
		}
		
		[XmlElement(alias="*")]
		/**
		 * 
		 * @return 
		 */
		public final function get nameSpace() : XmlApiNamespace{
			return _nameSpace;
		}
		
		/**
		 * 
		 * @param value
		 */
		public final function set nameSpace(value : XmlApiNamespace) : void{
			_nameSpace = value;
			if(getOwner()){
				if(value){
					_nameSpace = XmlApiClass(getOwner()).addNamespace(value);
				}else{
					XmlApiClass(getOwner()).removeNamespace(value);
				}
			}
		}
				
		/**
		 * 
		 * @param ns
		 */
		public function setNamespace(ns : Namespace) : void{
			nameSpace = XmlApiNamespace.create(ns);
		}
		
		public override function getMappingValues() : Dictionary{
			var values : Dictionary = super.getMappingValues();
			values[XmlConstants.ALIAS] = alias;
			if (!isNaN(order))
				values[XmlConstants.ORDER] = order;
			values[XmlConstants.IDREF] = idref;
			return values;
		}
	}
}