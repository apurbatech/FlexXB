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
package com.googlecode.flexxb.error {

	/**
	 * Error thrown when the FlexXB engine encounters problems processing the xml, 
	 * be it in the serialize or the deserialize stages.
	 * @author Alexutz
	 *
	 */
	public class ProcessingError extends Error {
		/**
		 *
		 */
		public static const STAGE_SERIALIZE : int = 0;
		/**
		 *
		 */
		public static const STAGE_DESERIALIZE : int = 1;

		private var _stage : int;

		private var _type : Class;

		private var _field : String;

		/**
		 *
		 * @param message
		 * @param id
		 *
		 */
		public function ProcessingError(type : Class, field : String, inSerializeStage : Boolean, message : String) {
			super("", 0);
			_stage = inSerializeStage ? STAGE_SERIALIZE : STAGE_DESERIALIZE;
			_type = type;
			_field = field;
			buildErrorMessage(message);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isInSerializeStage() : Boolean {
			return _stage == STAGE_SERIALIZE;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isInDeserializeStage() : Boolean {
			return _stage == STAGE_DESERIALIZE;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get type() : Class {
			return _type;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get field() : String {
			return _field;
		}

		private function buildErrorMessage(additional : String) : void {
			message = "Error occured on " + isInSerializeStage() ? "serialize" : "deserialize" + " stage for type " + type + ", field " + field + ":\n" + additional;
		}
	}
}