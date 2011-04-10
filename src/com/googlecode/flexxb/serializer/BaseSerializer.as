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
package com.googlecode.flexxb.serializer
{
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.annotation.contract.IAnnotation;
	import com.googlecode.flexxb.core.DescriptionContext;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class BaseSerializer
	{
		private var _context : DescriptionContext;
		
		public function BaseSerializer(context : DescriptionContext){
			_context = context;
		}
		/**
		 * Serialize an object into a serialization format
		 * @param object Object to be serialized
		 * @param annotation Annotation containing the conversion parameters
		 * @param serializedData Serialized data written so far
		 * @serializer
		 * @return Generated serialized data
		 *
		 */
		public function serialize(object : Object, annotation : IAnnotation, serializedData : Object, serializer : SerializationCore) : Object {
			return null;
		}
		/**
		 * Deserialize an xml into the appropiate AS3 object
		 * @param xmlData Xml to be deserialized
		 * @param annotation Annotation containing the conversion parameters
		 * @serializer
		 * @return Generated object
		 *
		 */
		public function deserialize(serializedData : Object, annotation : IAnnotation, serializer : SerializationCore) : Object{
			return null;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected final function get context() : DescriptionContext{
			return _context;
		}
	}
}