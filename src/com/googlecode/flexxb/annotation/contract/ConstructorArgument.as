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
package com.googlecode.flexxb.annotation.contract {
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;

	/**
	 * Defines a constructor argument. This annotaton is used when a class has a
	 * non default constructor. In order to maintain the business restrictions, FlexXB
	 * will determine the values of the arguments based on the received xml and call
	 * the constructor with those values.
	 * <p/>An argument has a reference; the reference is the name of the class field
	 * whose value it represents. A non default constructor will most often configure
	 * some of the object's fields when called. Since the only available data is the
	 * incoming xml, arguments must specify the field the the constructor will modify
	 * with the received value.
	 * <p/><b>The class field referenced in the argument must have an annotation defined
	 *  for it</b>
	 * @author Alexutz
	 *
	 */
	public class ConstructorArgument extends BaseAnnotation implements IGlobalAnnotation {
		/**
		 *
		 */
		private var _referenceField : String;
		/**
		 *
		 */
		private var _optional : Boolean;
		
		private var _owner : IClassAnnotation;

		/**
		 * Constructor
		 *
		 */
		public function ConstructorArgument(descriptor : MetaDescriptor, owner : IClassAnnotation) {
			super(descriptor);
			_owner = owner;
		}
		
		public function get classAnnotation() : IClassAnnotation{
			return _owner;
		}

		/**
		 * Get optional flag
		 * @return
		 *
		 */
		public function get optional() : Boolean {
			return _optional;
		}

		/**the reference field name
		 * @return
		 *
		 */
		public function get referenceField() : String {
			return _referenceField;
		}
		
		public override function get annotationName() : String {
			return Constants.ANNOTATION_CONSTRUCTOR_ARGUMENT;
		}
		
		protected override function parse(descriptor:MetaDescriptor):void{
			super.parse(descriptor);
			_referenceField = descriptor.attributes[Constants.REF];
			_optional = descriptor.getBooleanAttribute(Constants.OPTIONAL);
		} 
	}
}