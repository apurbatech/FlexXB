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
package com.googlecode.flexxb.annotation.contract
{
	/**
	 * Commonly used constants.
	 * @author Alexutz
	 * 
	 */	
	public class Constants
	{
		/**
		 * 
		 */		
		public static const VERSION : String = "version";
		/**
		 * 
		 */		
		public static const DEFAULT : String = "default";
		/**
		 * 
		 */		
		public static const ANNOTATION_CONSTRUCTOR_ARGUMENT : String = "ConstructorArg";		
		/**
		 * Reference attribute name
		 */
		public static const REF : String = "reference";
		/**
		 * Optional attribute name
		 */
		public static const OPTIONAL : String = "optional";
		/**
		 * IgnoreOn attribute name
		 */
		public static const IGNORE_ON : String = "ignoreOn";
		/**
		 * @private 
		 * 
		 */		
		public function Constants(){
			throw new Error("Can't instanciate this class. Use static accessors instead");
		}
	}
}