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
package com.googlecode.flexxb.service {
	import flash.events.Event;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class SettingsChangedEvent extends Event {
		/**
		 *
		 */
		public static const SETTINGSCHANGE : String = "settingsChange";
		
		private var _fieldName : String;
		
		private var _oldValue : Object;
		
		private var _newValue : Object;

		/**
		 *
		 * @param bubbles
		 * @param cancelable
		 *
		 */
		public function SettingsChangedEvent(fieldName : String, oldValue : Object = null, newValue : Object = null) {
			super(SETTINGSCHANGE);
			_fieldName = fieldName;
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		
		public function get fieldName() : String{
			return _fieldName;
		}

		public function get oldValue() : Object{
			return _oldValue;
		}

		public function get newValue() : Object{
			return _newValue;
		}
		
		public override function clone():Event{
			return new SettingsChangedEvent(this.fieldName, this._oldValue, this._newValue);
		}
	}
}