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
package com.googlecode.flexxb.util
{
	import flash.utils.getQualifiedClassName;

	/**
	 * Function that determines wheather the object passed in is a vector.<br/>
	 * Since Flash 10 a new type was introduced, Vector. To keep compatibility 
	 * with other versions people may use we need to do a special check that would 
	 * not involve direct linking the Vector class incode.
	 * <p>It takes a single parameter, the object to be checked. If the object is a 
	 * String, it is considered to be the qualified name of the class and it will get 
	 * inspected for the vector's qualified name being present. If the object is a 
	 * class or a plain AS3 object, the <code>getQualifiedClassName</code> method will
	 * be used to extract the type name and compare it with the vector's name.</p> 
	 * @param item item to be checked. Can be anything: class, string, plain object. 
	 * @return true if vector, false otherwise
	 *  
	 */	
	public function isVector(item : Object) : Boolean{
		var vector : String = "__AS3__.vec::Vector";
		if(item is String){
			return (item as String).indexOf(vector) == 0;
		}
		if(item){
			return getQualifiedClassName(item).indexOf(vector) == 0;
		}
		return false;
	}
}