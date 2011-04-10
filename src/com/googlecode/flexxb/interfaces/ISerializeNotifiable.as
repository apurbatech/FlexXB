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
package com.googlecode.flexxb.interfaces
{
	/**
	 * Optional interface to be implemented by objects which need specific
	 * notification on the serialization process.<br> 
	 * If the current object to be serialized implements this interface, the
	 * engine will call the methods implemented on each process step (pre and 
	 * post serialize) instead of firing a SerializationEvent on the engine 
	 * instance for each step. <br>
	 * Implementing this interface overrides the normal event dispatching in the 
	 * engine.   
	 * @author Alexutz
	 * 
	 */	
	public interface ISerializeNotifiable
	{
		/**
		 * Called before the serialization process of the current object begins.
		 * @param parent
		 * @param serializedData
		 * 
		 */				
		function onPreSerialize(parent : Object, serializedData : Object) : void;
		/**
		 * Called after the serialization process of the current object ends.
		 * @param parent
		 * @param serializedData
		 *  
		 */		
		function onPostSerialize(parent : Object, serializedData : Object) : void;
	}
}