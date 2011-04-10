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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;

	[XmlClass(alias="Field")]
	[ConstructorArg(reference="name")]
	[ConstructorArg(reference="type")]
	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class FxField {
		/**
		 *
		 */
		private var _name : String;
		/**
		 *
		 */
		private var _type : Class;
		/**
		 *
		 */
		private var _accessType : AccessorType;

		/**
		 *
		 * @param name
		 * @param type
		 * @param accessType
		 *
		 */
		public function FxField(name : String, type : Class, accessType : AccessorType = null) {
			this.name = name;
			this.type = type;
			if (accessType) {
				this.accessType = accessType;
			} else {
				this.accessType = AccessorType.READ_WRITE;
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get name() : String {
			return _name;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set name(value : String) : void {
			if (value == null || StringUtil.trim(value) == "") {
				throw new Error("Field name is null or empty!");
			}
			_name = value;
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get type() : Class {
			return _type;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set type(value : Class) : void {
			if (value == null) {
				throw new Error("Field type is null!");
			}
			_type = value;
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get accessType() : AccessorType {
			return _accessType;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set accessType(value : AccessorType) : void {
			if (value == null) {
				_accessType = AccessorType.READ_WRITE;
				return;
			}
			_accessType = value;
		}
		
		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public function toString() : String {
			return "Field[name: " + name + ", type:" + type + ", access: " + accessType + "]";
		}
	}
}