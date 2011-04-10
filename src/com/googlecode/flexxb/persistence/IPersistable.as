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
package com.googlecode.flexxb.persistence {

	/**
	 * Interface defining an object that can be persisted. A persistable object
	 * is capable of tracking changes done to it and reverting to initial values
	 * if required.
	 * <code>IPersistable</code> exposes three methods:
	 * <ul>
	 * 	<li><code>modified</code> - check if object has been changed since its last save</li>
	 * 	<li><code>commit</code> - make changes done from the last save persistent</li>
	 * 	<li><code>rollback</code> - revert to the initial state of the object</li>
	 * </ul>
	 * @author aCiobanu
	 *
	 */
	public interface IPersistable {
		/**
		 * Get the object's status: has it been modified since the previous commit?
		 * @return  true/false
		 *
		 */
		function get modified() : Boolean;
		/**
		 * The editMode flag will cause the object not to issue PropertyChangeEvents whenever 
		 * one of its fields is changed. This means that components bound to that object will 
		 * not update to reflect changes in the object because thare are no change events being 
		 * dispatched from the object. In cases where you would edit the object in a view for 
		 * example, it would be akward to change the name and see it changed in the background 
		 * component displaying basic object details. In conclusion, it is not really an edit flag 
		 * preventing the object from being edited but rather a notifier for the object to turn into 
		 * a sort of a black box while that flag is active.
		 * @return
		 *
		 */
		function get editMode() : Boolean;
		/**
		 * Set edit mode.<br/>
		 * The editMode flag will cause the object not to issue PropertyChangeEvents whenever 
		 * one of its fields is changed. This means that components bound to that object will 
		 * not update to reflect changes in the object because thare are no change events being 
		 * dispatched from the object. In cases where you would edit the object in a view for 
		 * example, it would be akward to change the name and see it changed in the background 
		 * component displaying basic object details. In conclusion, it is not really an edit flag 
		 * preventing the object from being edited but rather a notifier for the object to turn into 
		 * a sort of a black box while that flag is active.
		 * @param mode boolean value specifing id the flag must be active or not
		 *
		 */
		function setEditMode(mode : Boolean) : void;
		/**
		 * Commit the changes made to the object since the previous commit
		 *
		 */
		function commit() : void;
		/**
		 * Revert all the changes made to the object since the previous commit
		 *
		 */
		function rollback() : void;
		/**
		 * Stop listening for changes occuring to the object.
		 * It is usually called before deserialization occurs.
		 *
		 */
		function stopListening() : void;
		/**
		 * Start listening for changes occuring to the object.
		 * Usually called after deserialization completes.
		 *
		 */
		function startListening() : void;
	}
}