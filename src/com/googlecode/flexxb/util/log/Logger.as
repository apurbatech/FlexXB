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
package com.googlecode.flexxb.util.log
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;

	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal final class Logger implements ILogger
	{
		private static const INFO : String = "INFO";
		private static const ERROR : String = "ERROR";
		private static const WARN : String = "WARN";
		
		private var type : String = "";
		/**
		 * 
		 * 
		 */		
		public function Logger(type : Class){
			if(type){
				this.type = getQualifiedClassName(type);
				this.type = this.type.substring(this.type.indexOf("::") + 2);
			}
		}
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		public function info(content : String, ...args) : void{
			log(INFO, content, args);
		}
		
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		public function warn(content : String, ...args) : void{
			log(WARN, content, args);
		}
		
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		public function error(content : String, ...args) : void{
			log(ERROR, content, args);
		}
		
		private function log(logType : String, content : String, arguments : Array) : void{
			if(arguments && arguments.length > 0){
				content = StringUtil.substitute(content, arguments); 
			}
			trace(type + " " + logType + " - " + content);
		}		
	}
}