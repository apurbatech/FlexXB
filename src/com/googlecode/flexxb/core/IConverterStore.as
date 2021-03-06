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

	/**
	 * @private
	 * Defines a converter store, used to convert objects to string 
	 * representations and viceversa.
	 * @author Alexutz
	 * 
	 */
	public interface IConverterStore {
		/**
		 * Convert string value to object
		 * @param value value to be converted to object
		 * @param clasz type of the object to which the value is converted
		 * @return instance of type passed as argument
		 *
		 */
		function stringToObject(value : String, clasz : Class) : Object;
		/**
		 * Convert object value to string
		 * @param item instance to be converted to string
		 * @return string value
		 *
		 */
		function objectToString(item : Object, clasz : Class) : String;
	}
}