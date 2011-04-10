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
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * Communicates with the server by sending xml requests and receiving xml responses
	 * @author aciobanu
	 *
	 */
	public class Communicator implements ICommunicator {
		/**
		 *
		 */
		private var _settings : ServiceSettings;
		/**
		 *
		 */
		private var service : HTTPService;

		/**
		 * Constructor
		 * @param settings
		 *
		 */
		public function Communicator(settings : ServiceSettings = null, detectSettingsChange : Boolean = false) {
			service = new HTTPService();
			applySettings(settings, detectSettingsChange);
		}

		/**
		 *
		 * @see ICommunicator#applySettings()
		 *
		 */
		public function applySettings(settings : ServiceSettings, detectSettingsChange : Boolean = false) : void {
			if (_settings) {
				_settings.removeEventListener(SettingsChangedEvent.SETTINGSCHANGE, onSettingsChange);
			}
			_settings = settings;
			if (settings) {
				if (detectSettingsChange) {
					_settings.addEventListener(SettingsChangedEvent.SETTINGSCHANGE, onSettingsChange);
				}
				configureService(service, _settings);
			}
		}

		/**
		 *
		 * @see ICommunicator#sendRequest()
		 *
		 */
		public function sendRequest(translator : ITranslator, resultHandler : Function, faultHandler : Function = null) : AsyncToken {
			if (translator == null || !(resultHandler is Function)) {
				throw new Error("Error sending request: request body and result handler can't be null");
			}
			var xmlRequest : XML = translator.createRequest();
			service.request = xmlRequest;
			var onResult : Function = function(event : ResultEvent) : void {
					var xmlResponse : XML = event.result as XML;
					var response : Object = translator.parseResponse(xmlResponse);
					var responseData : Object = translator.extractResponseData(response);
					resultHandler(responseData);
				};

			var onError : Function = function(event : FaultEvent) : void {
					if (faultHandler is Function) {
						faultHandler(event.fault);
					}
				};
			var token : AsyncToken = service.send();
			token.addResponder(new Responder(onResult, onError));
			return token;
		}

		/**
		 * Cancel the last request made
		 *
		 */
		public function cancelRequest() : void {
			service.cancel();
		}

		/**
		 * @see ICommunicator#destroy()
		 *
		 */
		public function destroy() : void {
			if (service) {
				service.disconnect();
				service = null;
			}
			_settings = null;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onSettingsChange(event : SettingsChangedEvent) : void {
			configureService(service, _settings);
		}

		/**
		 *
		 * @param srv
		 * @param settings
		 *
		 */
		private function configureService(srv : HTTPService, settings : ServiceSettings) : void {
			srv.url = settings.url;
			srv.destination = settings.destination;
			srv.contentType = HTTPService.CONTENT_TYPE_XML;
			srv.requestTimeout = settings.timeout;
			srv.method = settings.method;
			srv.resultFormat = HTTPService.RESULT_FORMAT_E4X;
		}
	}
}