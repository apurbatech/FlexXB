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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	use namespace flexxb_persistence_internal;
	
	/**
	 * Main implementation of IPersistable. A persistable object is capable of
	 * tracking changes done to it and reverting to initial values if required.
	 * It should be base for all model objects that need initial state memory
	 * capabilities such as IPersistable allows. It uses the methods <code>commit()</code> and <code>rollback()</code> to save the
	 * current state or to revert to the previously saved state.
	 * <p>Basically, this object listens for changes to all its public properties and
	 * variables and saves the initial value set for that field. Upon commit, the list of
	 * initial values is discarded, the new values thus becoming initial values. On rollback,
	 * the initial values are reinstated the object returning to the state before eny change
	 * had been made.</p>
	 * <p><b>Note</b>: Subclasses should be decorated with the <code>[Bindable]</code> annotation so all
	 * changes to the public fields would be registered.</p>
	 * @author Alexutz
	 *
	 */
	public class PersistableObject extends EventDispatcher implements IPersistable {
		private var _modified : Boolean;

		private var changeList : Dictionary;

		private var watchedFields : Array;

		private var excludedFields : Array;

		private var listen : Boolean = true;

		private var _editMode : Boolean;
		
		private var opIndex : Number;

		/**
		 * Constructor
		 *
		 */
		public function PersistableObject(listenMode : Boolean = true) {
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.onValueChanged, false, Number.MAX_VALUE, false);
			listen = listenMode;
		}
		
		public final function get editMode() : Boolean {
			return _editMode;
		}

		public final function setEditMode(mode : Boolean) : void {
			_editMode = mode;
			//try and set the edit mode for the connected objects also
			if (hasWatchedFields()) {
				var value : Object;
				for each (var field : String in watchedFields) {
					value = this[field];
					if (value is IPersistable) {
						IPersistable(value).setEditMode(mode);
					}
				}
			}
		}
		
		public final function get modified() : Boolean {
			return _modified || areWatchedFieldsModified();
		}

		/**
		 * Stop listening for changes occuring to the object. Configuring listen
		 * mode also propagates to watched fields of tye <code>IPersistable</code>.
		 * <br />It is usually called before deserialization occurs.
		 *
		 */
		public final function stopListening() : void {
			setListenMode(false);
		}

		/**
		 * Start listening for changes occuring to the object. Configuring listen
		 * mode also propagates to watched fields of tye <code>IPersistable</code>.
		 * <br />It is usually called after deserialization completes.
		 *
		 */
		public final function startListening() : void {
			setListenMode(true);
		}

		/**
		 * @see IPersistable#commit()
		 *
		 */
		public final function commit() : void {
			if (modified) {

				beforeCommit();
				//if the object is in editMode, changes do not propagate to bound components,
				//thus property change events must be dispatched for changed fields
				if (editMode) {
					setEditMode(false);
					for each (var tracker : ChangeTracker in changeList) {
						dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, PropertyChangeEventKind.UPDATE, tracker.fieldName));
					}
				}
				//propagate the command to watched fields
				var value : Object;
				for each (var field : String in watchedFields) {
					value = this[field];
					if (value is IPersistable) {
						IPersistable(value).commit();
					}
				}
				opIndex = 0;
				setModified(false);
			}
			setEditMode(false);
		}
		
		public final function rollback() : void {
			if (modified) {
				listen = false;

				beforeRollback();
				//revert changes to the
				for each (var tracker : ChangeTracker in changeList) {
					this[tracker.fieldName] = tracker.persistedValue;
				}
				//propagate the command to watched fields
				var value : Object;
				for each (var field : String in watchedFields) {
					value = this[field];
					if (value is IPersistable) {
						IPersistable(value).rollback();
					}
				}
				opIndex = 0;

				setModified(false);
			}
		}

		/**
		 * Dispacth the specified event
		 * @param event
		 * @return dispatch succeeded
		 *
		 */
		public override final function dispatchEvent(event : Event) : Boolean {
			if (editMode && event is PropertyChangeEvent && event.type == PropertyChangeEvent.PROPERTY_CHANGE) {
				onValueChanged(PropertyChangeEvent(event));
				return true;
			}
			return super.dispatchEvent(event);
		}

		/**
		 * This method allows an object to keep track of changes occuring in its sub-object. In fact
		 * it will only monitor the modified status of those sub objects. On rollback or commit it
		 * will propagate the commands to those sub-objec it was instructed to watch.
		 * <p/><b>NOTE: Make sure watched objects are also persistable objects</b>
		 * @param fieldName field's name
		 *
		 */
		public final function watch(fieldName : String) : void {
			if (fieldName && hasOwnProperty(fieldName)) {
				if (!watchedFields) {
					watchedFields = [fieldName];
				} else if (watchedFields.indexOf(fieldName) == -1) {
					watchedFields.push(fieldName);
				}
			}
		}


		/**
		 * Exclude a field from being listened for changes. The object will no longer track changes
		 * that occur to the value of that field.
		 * @param fieldName field's name
		 *
		 */
		public final function exclude(fieldName : String) : void {
			if (fieldName && hasOwnProperty(fieldName)) {
				if (!excludedFields) {
					excludedFields = [fieldName];
				} else if (excludedFields.indexOf(fieldName) == -1) {
					excludedFields.push(fieldName);
				}
			}
		}

		/**
		 * Check if an object's field is marked as watched.
		 * @param fieldName
		 * @return
		 *
		 */
		public final function isWatched(fieldName : String) : Boolean {
			return watchedFields && fieldName && watchedFields.indexOf(fieldName) > -1;
		}

		/**
		 * Check if watched fields have been defined for the current object
		 * @return
		 *
		 */
		public function hasWatchedFields() : Boolean {
			return watchedFields && watchedFields.length > 0;
		}

		/**
		 * This is an entry point allowing you to do some computations prior
		 * to commit being executed, that is, before the change list is
		 * discarded.
		 *
		 */
		protected function beforeCommit() : void {
		}

		/**
		 * This is an entry point allowing you to do some computations prior
		 * to rollback being executed, that is, before the change list is
		 * iterated and changed fields having their values reverted to the
		 * original ones.
		 *
		 */
		protected function beforeRollback() : void {
		}

		/**
		 * Check if the value of a specific field has been changed since the last commit
		 * @param fieldName the name of the object's field to check
		 * @return true if the field exists and its value has been changed, false otherwise
		 *
		 */
		public final function isChanged(fieldName : String) : Boolean {
			var changed : Boolean = _modified && fieldName && changeList[fieldName] is ChangeTracker;
			//if the field is marked as watched, then check is the field value is modified internally
			if (!changed && isWatched(fieldName)) {
				var value : Object = this[fieldName];
				if (value is IPersistable) {
					changed = IPersistable(value).modified;
				}
			}
			return changed;
		}

		private function setListenMode(doListen : Boolean) : void {
			listen = doListen;
			if (hasWatchedFields()) {
				var data : Object;
				for each (var fieldName : String in watchedFields) {
					data = this[fieldName];
					if (data is IPersistable) {
						listen ? IPersistable(data).startListening() : IPersistable(data).stopListening();
					}
				}
			}
		}

		private function isExcluded(fieldName : Object) : Boolean {
			return excludedFields && excludedFields.indexOf(fieldName) > -1;
		}

		private function setModified(value : Boolean) : void {
			_modified = value;
			if (!value && changeList) {
				for (var tracker : * in changeList) {
					delete changeList[tracker];
				}
			}
			listen = true;
		}

		private function onValueChanged(event : PropertyChangeEvent) : void {
			if (listen) {
				var name : String = event.property as String;
				if(isExcluded(name)){
					return;
				}
				if (changeList && changeList[name]) {
					if (ChangeTracker(changeList[name]).persistedValue == event.newValue) {
						delete changeList[name];
					}
					return;
				}
				var tracker : ChangeTracker = ChangeTracker.flexxb_persistence_internal::fromPropertyChangeEvent(event, opIndex++);
				if (!changeList) {
					changeList = new Dictionary();
				}
				changeList[name] = tracker;
				setModified(true);
			}
		}

		private function areWatchedFieldsModified() : Boolean {
			var data : Object;
			for each (var fieldName : String in watchedFields) {
				data = this[fieldName];
				if (data is IPersistable && IPersistable(data).modified) {
					return true;
				}
			}
			return false;
		}
	}
}