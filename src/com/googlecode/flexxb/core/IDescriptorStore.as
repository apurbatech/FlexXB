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
package com.googlecode.flexxb.core {
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;

	/**
	 * @private
	 * @author Alexutz
	 *
	 */
	public interface IDescriptorStore {
		
		/**
		 * Get the class descriptor associated with the object type. <b>If the required version is not found, 
		 * it will fallback to the default version.</b>
		 * @param object target object 
		 * @param version version to be used
		 * @return IClassAnnotation descriptor 
		 * 
		 */		
		function getDescriptor(object : Object, version : String = "") : IClassAnnotation;
		
		/**
		 * This method allows searching through the registered annotations for a class annotation bearing 
		 * specific criterion. Method will return null if no such item is found or if the field name is invalid. 
		 * @param field criterion field name
		 * @param value criterion field value
		 * @param version version to be used
		 * @return clas type reference
		 * 
		 */			
		function getClassReferenceByCriteria(field : String, value : String, version : String = "") : Class
	}
}