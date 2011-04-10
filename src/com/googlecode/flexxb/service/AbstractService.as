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

	/**
	 * Base Service for communicating with the server. All data service classes should extend this class
	 * @author aciobanu
	 *
	 */
	public class AbstractService {
		private var _communicationHandler : ICommunicator = new Communicator();

		/**
		 * Constructor
		 *
		 */
		public function AbstractService() {
		}

		/**
		 * Configure the service settings
		 * @param settings
		 *
		 */
		protected function configure(settings : ServiceSettings) : void {
			_communicationHandler.applySettings(settings);
		}

		/**
		 * Get communicator used for talking with the server
		 * @return
		 *
		 */
		protected function get communicator() : ICommunicator {
			return _communicationHandler;
		}

		/**
		 * Set the communicator used for talking with the server
		 * @param value
		 *
		 */
		protected function set communicator(value : ICommunicator) : void {
			_communicationHandler = value;
		}
	}
}