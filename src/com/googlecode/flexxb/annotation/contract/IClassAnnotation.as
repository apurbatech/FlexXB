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
	import mx.collections.ArrayCollection;

	/**
	 * This is the contract interface for a class annotation. A class annotation
	 * holds all the annotation structure relevant for that type, being the 
	 * FlexXB's representation of the type. This representation is used in the
	 * (de)serialization process so the engine will know how to generate and 
	 * parse xml. 
	 * @author Alexutz
	 * 
	 */	
	public interface IClassAnnotation extends IFieldAnnotation
	{
		[ArrayElementType("com.googlecode.flexxb.annotation.contract.IMemberAnnotation")]
		/**
		 * Get the list of members associated with this class
		 * @return 
		 * 
		 */		
		function get members() : ArrayCollection;
		
		/**
		 * Get a member by field name
		 * @param fieldName name of target field
		 * @return Member annotation instance if the field has member metadata defined, null otherwise 
		 * 
		 */		
		function getMember(fieldName : String) : IMemberAnnotation; 
		
		/**
		 * Get a reference to a field which is considered the identifier for instances of the specified 
		 * type. The ID field is used if one wishes to render objects of the current type in a short form,
		 * consisting only in the type representation wrapper and the representation of this idField. By
		 * this id field, upon deserialization, the engine can identify and extract the correct instance
		 * from a model object cache.
		 * @return Member annotation instance if idField has been defined, null otherwise
		 * 
		 */		
		function get idField() : IMemberAnnotation;
		
		/**
		 * Get a reference to the constructor object which defines the parameters the type constructor takes
		 * (default or non-default constructor)
		 * @return 
		 * 
		 */		
		function get constructor() : Constructor;
	}
}