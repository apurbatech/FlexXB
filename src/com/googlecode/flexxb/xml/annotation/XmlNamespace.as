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
package com.googlecode.flexxb.xml.annotation
{
	import com.googlecode.flexxb.annotation.contract.BaseAnnotation;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.contract.IGlobalAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class XmlNamespace extends BaseAnnotation implements IGlobalAnnotation
	{
		private var _uri : String;
		
		private var _prefix : String;
		
		private var _owner : IClassAnnotation;
		
		public function XmlNamespace(descriptor : MetaDescriptor, owner : IClassAnnotation) {
			super(descriptor);
			_owner = owner;
		}
		
		public function get classAnnotation():IClassAnnotation{
			return _owner;
		}
		
		public function get uri() : String{
			return _uri;
		}
		
		public function get prefix() : String{
			return _prefix;
		}
		
		public override function get annotationName() : String{
			return XmlConstants.ANNOTATION_NAMESPACE;
		}
		
		protected override function parse(descriptor : MetaDescriptor):void{
			super.parse(descriptor);
			_uri = descriptor.attributes[XmlConstants.NAMESPACE_URI];
			_prefix = descriptor.attributes[XmlConstants.NAMESPACE_PREFIX];
		}
	}
}