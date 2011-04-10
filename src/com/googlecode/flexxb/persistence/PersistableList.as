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
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	use namespace flexxb_persistence_internal;

	/**
	 * Adds to ArrayCollection the functionalities specified by IPersistable.
	 * Should be used in model objects the require having lists of referenced objects.
	 * @see PersistableObject
	 * @author aciobanu
	 *
	 */
	public class PersistableList extends ArrayCollection implements IPersistable {
		private var _modified : Boolean;

		private var listen : Boolean;

		private var changeList : Dictionary;

		private var backup : Array;

		private var _editMode : Boolean;
		
		private var _watchItems : Boolean;
		
		private var opIndex : Number = 0;

		/**
		 * Constructor
		 * @param source
		 * @param listenMode
		 * @param watchChildChanges
		 *
		 */
		public function PersistableList(source : Array = null, listenMode : Boolean = true, watchChildChanges : Boolean = false) {
			super(source);
			addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, Number.MAX_VALUE, false);
			listen = listenMode;
			_watchItems = watchChildChanges;
		}

		/**
		 *
		 * @see IPersistable#editMode()
		 *
		 */
		public final function get editMode() : Boolean {
			return _editMode;
		}

		/**
		 *
		 * @see IPersistable#setEditMode()
		 *
		 */
		public final function setEditMode(mode : Boolean) : void {
			_editMode = mode;
		}

		/**
		 * Stop listening for changes occuring to the object.
		 * It is usually called before deserialization occurs.
		 *
		 */
		public final function stopListening() : void {
			listen = false;
		}

		/**
		 * Start listening for changes occuring to the object.
		 * Usually called after deserialization completes.
		 *
		 */
		public final function startListening() : void {
			listen = true;
		}
		
		/**
		 * 
		 * @param watch
		 * 
		 */		
		public final function watchItemChanges(watch : Boolean = true) : void{
			_watchItems = watch;
		}

		/**
		 *
		 * @param item
		 * @return
		 *
		 */
		public final function removeItem(item : Object) : Boolean {
			if (item) {
				var index : int = getItemIndex(item);
				if (index > -1) {
					removeItemAt(index);
					return true;
				}
			}
			return false;
		}

		/**
		 *
		 * @param index
		 * @return
		 *
		 */
		public override function removeItemAt(index : int) : Object {
			if (index >= 0 && index < length) {
				doBackup();
			}
			return super.removeItemAt(index);
		}

		/**
		 *
		 * @param item
		 * @param index
		 *
		 */
		public override function addItemAt(item : Object, index : int) : void {
			if (list && index >= 0 && index <= length) {
				doBackup();
			}
			super.addItemAt(item, index);
		}

		/**
		 *
		 * @param item
		 * @param index
		 * @return
		 *
		 */
		public override function setItemAt(item : Object, index : int) : Object {
			if (list && index >= 0 && index < length) {
				doBackup();
			}
			return super.setItemAt(item, index);
		}

		/**
		 *
		 * @param s
		 *
		 */
		public override function set source(s : Array) : void {
			if (source && s != source) {
				doBackup();
				onCollectionChange(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			}
			super.source = s;
		}

		/**
		 * @see IPersistable#modified()
		 *
		 */
		public final function get modified() : Boolean {
			return _modified || (_watchItems && areItemsModified());
		}

		/**
		 * @see IPersistable#commit()
		 *
		 */
		public final function commit() : void {
			if (modified) {

				beforeCommit();
				
				for (var key : * in changeList) {
					delete changeList[key];
				}
				backup = null;
				opIndex = 0;
				
				setModified(false);
			}
		}

		/**
		 * Get the list of changed items (added removed, moved) in the current instance.
		 * Each item is a <code>ChangeTracker</code> instance, a wrapper around the the 
		 * real list member, containing information on the action took on that object as 
		 * well as relevant additional data (such as the objects's position). The array 
		 * is ordered according to the temporal sequence in which the actions were performed.
		 * @return array of <code>ChangeTracker</code> instances
		 *
		 */
		public function get changedItemWrappers() : Array {
			var items : Array = [];
			for (var key : * in changeList) {
				items.push(changeList[key]);
			}
			items.sortOn("index", Array.NUMERIC);
			return items;
		}

		/**
		 * Get the list of changed members (added removed, moved) in the current instance.
		 * @return
		 *
		 */
		public function get changedItems() : Array {
			var items : Array = [];
			for (var key : * in changeList) {
				items.push(key);
			}
			return items;
		}

		/**
		 *
		 * @param member
		 * @return
		 *
		 */
		public function isAdded(member : Object) : Boolean {
			if (member && changeList) {
				var tracker : ChangeTracker = changeList[member];
				if (tracker) {
					return tracker.isAdded();
				}
			}
			return false;
		}

		/**
		 *
		 * @param member
		 * @return
		 *
		 */
		public function isRemoved(member : Object) : Boolean {
			if (member && changeList) {
				var tracker : ChangeTracker = changeList[member];
				if (tracker) {
					return tracker.isRemoved();
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @param member
		 * @return 
		 * 
		 */		
		public function isMoved(member : Object) : Boolean{
			if(member && changeList){
				var tracker : ChangeTracker = changeList[member];
				if (tracker) {
					return tracker.isMoved();
				}
			}
			return false;
		}

		/**
		 * @see IPersistable#rollback()
		 *
		 */
		public final function rollback() : void {
			if (_modified) {
				listen = false;


				beforeRollback();

				source = backup;
				refresh();

				for (var key : * in changeList) {
					delete changeList[key];
				}

				backup = null;
				opIndex = 0;

				setModified(false);
			}
			if(_watchItems){
				for each(var item : Object in source){
					if(item is IPersistable){
						IPersistable(item).rollback();
					}
				}
			}
		}

		/**
		 *
		 * @see flash.events.EventDispatcher#dispatchEvent()
		 *
		 */
		public override final function dispatchEvent(event : Event) : Boolean {
			if (editMode && event is CollectionEvent && ChangeTrackerKind.isCollectionActionTracked(CollectionEvent(event).kind)) {
				onCollectionChange(event as CollectionEvent);
				return true;
			}
			return super.dispatchEvent(event);
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
		 *
		 * @param value
		 *
		 */
		private function setModified(value : Boolean) : void {
			_modified = value;
			if (!value && changeList) {
				for (var key : * in changeList) {
					delete changeList[key];
				}
			}
			listen = true;
		}

		/**
		 * Occurs whenever the collection changes by adding/ removing an object etc.
		 * @param event
		 *
		 */
		private function onCollectionChange(event : CollectionEvent) : void {
			if (listen && ChangeTrackerKind.isCollectionActionTracked(event.kind)) {
				var tracker : ChangeTracker = ChangeTracker.flexxb_persistence_internal::fromCollectionChangeEvent(event, opIndex++);
				if (!changeList) {
					changeList = new Dictionary();
				}
				doBackup();
				if (tracker.persistedValue is Array) {
					for each (var object : Object in tracker.persistedValue) {
						trackChange(object, tracker);
					}
				} else {
					trackChange(tracker.persistedValue, tracker);
				}
				setModified(true);
			}
		}

		private function doBackup() : void {
			if (listen && !backup) {
				backup = [];
				for each (var item : Object in this) {
					backup.push(item);
				}
			}
		}

		/**
		 *
		 * @param object
		 * @param tracker
		 *
		 */
		private function trackChange(object : Object, tracker : ChangeTracker) : void {
			var originalTracker : ChangeTracker = changeList[object];
			if (originalTracker) {
				if (originalTracker.isAdded() && tracker.isRemoved()) {
					delete changeList[object];
					return;
				} else if (originalTracker.isRemoved() && tracker.isAdded()) {
					var key : ChangeTracker = new ChangeTracker(tracker.fieldName, tracker.persistedValue, ChangeTrackerKind.MOVE, tracker.index, tracker.additional);
					changeList[object] = key;
					return;
				}
			}
			changeList[object] = tracker;
		}
		
		private function areItemsModified() : Boolean{
			for each(var item : Object in source){
				if(item is IPersistable && IPersistable(item).modified){
					return true;
				}
			}
			return false;
		}
	}
}