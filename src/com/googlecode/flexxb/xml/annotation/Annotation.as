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
package com.googlecode.flexxb.xml.annotation {
	import com.googlecode.flexxb.annotation.contract.BaseAnnotation;
	import com.googlecode.flexxb.annotation.contract.Constants;
	import com.googlecode.flexxb.annotation.contract.IFieldAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import flash.utils.getDefinitionByName;

	/**
	 * This is the base class for a field xml annotation.
	 * <p> It obtains basic informations about the field:
	 * <ul><li>Field name</li>
	 *     <li>Field type</li>
	 *     <li>Alias (the name under which the field will be used in the xml reprezentation)</li>
	 * </ul>
	 * </p>
	 * @author aCiobanu
	 *
	 */
	public class Annotation extends BaseAnnotation implements IFieldAnnotation {
		
		private var _name : QName;
		
		protected var _type : Class;
		
		private var _alias : String = "";
		
		private var _xmlName : QName;
		
		private var _nameSpace : Namespace;

		/**
		 * Constructor
		 * @param descriptor
		 *
		 */
		public function Annotation(descriptor : MetaDescriptor) { 
			super(descriptor);
		}
		
		/**
		 * Get the annotation namespace
		 * @return namespace instance
		 *
		 */
		public function get nameSpace() : Namespace {
			return _nameSpace;
		}
		
		public function get name() : QName {
			return _name;
		}
		
		public function get type() : Class {
			return _type;
		}
		
		/**
		 * Set the annotation namepsace
		 *
		 */
		public function set nameSpace(value : Namespace) : void {
			_nameSpace = value;
		}

		/**
		 * Get the qualified xml name
		 * @return
		 *
		 */
		public function get xmlName() : QName {
			if (!_xmlName) {
				_xmlName = new QName(nameSpace, _alias == "" ? _name : _alias);
			}
			return _xmlName;
		}

		/**
		 * Get the alias
		 * @return annotation alias
		 *
		 */
		public function get alias() : String {
			return _alias;
		}

		/**
		 * @private
		 * @param value name to be set
		 *
		 */
		protected function setAlias(value : String) : void {
			_alias = value;
			if (!_alias || _alias.length == 0) {
				_alias = _name.localName;
			}
		}

		/**
		 * Get a flag to signal wether this annotation declares a namespace or not
		 * @return true if it has namespace declarations, false otherwise
		 *
		 */
		public function hasNamespaceDeclaration() : Boolean {
			return nameSpace && nameSpace.uri && nameSpace.uri.length > 0;
		}

		/**
		 * Get a flag to signal wether to use the owner's alias or not
		 * @return true if it must use the owner's alias, false otherwise
		 *
		 */
		public function useOwnerAlias() : Boolean {
			return _alias == XmlConstants.ALIAS_ANY;
		}
		
		protected override function parse(descriptor : MetaDescriptor) : void {
			super.parse(descriptor);
			_name = descriptor.fieldName;
			_type = descriptor.fieldType;
			setAlias(descriptor.attributes[XmlConstants.ALIAS]);			
		}
	}
}