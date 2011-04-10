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
	 *
	 * @author aCiobanu
	 *
	 */
	public interface ITranslator {
		/**
		 * Create the XML request to be sent to the server
		 * @return XML request
		 *
		 */
		function createRequest() : XML;
		/**
		 * Get the response xml from the server and convert it to the response object.
		 * @param data xml response
		 * @return actual response object
		 *
		 */
		function parseResponse(data : XML) : Object;

		/**
		 *
		 * @param response the response received from the server.
		 * @return the object the represents the response.
		 */
		function extractResponseData(response : Object) : Object;
	}
}
