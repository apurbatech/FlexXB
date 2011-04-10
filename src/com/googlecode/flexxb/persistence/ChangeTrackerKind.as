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
	 *
	 * @author Alexutz
	 *
	 */
	internal class ChangeTrackerKind {
		/**
		 *
		 * @default
		 */
		public static const UPDATE : String = "update";
		/**
		 *
		 * @default
		 */
		public static const ADD : String = "add";
		/**
		 *
		 * @default
		 */
		public static const REMOVE : String = "remove";
		/**
		 *
		 * @default
		 */
		public static const DELETE : String = "delete";
		/**
		 *
		 * @default
		 */
		public static const MOVE : String = "move";
		/**
		 *
		 * @default
		 */
		public static const REPLACE : String = "replace";

		/**
		 *
		 * @param action
		 * @return
		 */
		public static function isActionTracked(action : String) : Boolean {
			return action == UPDATE || action == DELETE;
		}

		/**
		 *
		 * @param action
		 * @return
		 */
		public static function isCollectionActionTracked(action : String) : Boolean {
			return action == ADD || action == REMOVE || action == MOVE || action == REPLACE;
		}

		/**
		 * Constructor
		 * @private
		 */
		public function ChangeTrackerKind() {
			throw new Error("Don't instanciate this class.");
		}
	}
}