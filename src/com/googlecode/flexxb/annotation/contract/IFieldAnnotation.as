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
	 * This interface defines a metadata decorating a class field or class. 
	 * It exposes a name and a type as any class field has a name and a type. 
	 * @author Alexutz
	 * 
	 */	
	public interface IFieldAnnotation extends IAnnotation
	{
		/**
		 * Get the qualified name of the field that is annotated by the current metadata
		 * @return class field qualified name
		 * 
		 */		
		function get name() : QName;
		/**
		 * Get the type of the field that is annotated by the current metadata
		 * @return class field type 
		 * 
		 */		
		function get type() : Class;		
	}
}