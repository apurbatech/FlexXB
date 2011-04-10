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
package com.googlecode.flexxb.xml
{
	import com.googlecode.flexxb.core.Configuration;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class XmlConfiguration extends Configuration
	{
		/**
		 * Determine the type of the object the response will be deserialised into
		 * by the namespace defined in the received xml.
		 */
		public var getResponseTypeByNamespace : Boolean = true;
		/**
		 * Determine the type of the object the response will be deserialised into
		 * by the root element name of the received xml.
		 */
		public var getResponseTypeByTagName : Boolean = true;
		/**
		 * Set this flag to true if you want special chars to be escaped in the xml. 
		 * If set to false, text containing special characters will be enveloped in a CDATA tag.
		 * This option applies to xml elements. For xml attributes special chars are automatically 
		 * escaped.
		 */		
		public var escapeSpecialChars : Boolean = false;
		/**
		 * 
		 * @param parent
		 * 
		 */		
		public function XmlConfiguration(parent : Configuration = null){
			super();
			if(parent){
				super.copyFrom(parent, this);
			}
		}
		
		protected override function getInstance() : Configuration{
			return new XmlConfiguration();
		}
		
		protected override function copyFrom(source : Configuration, target : Configuration) : void{
			super.copyFrom(source, target);
			if(source is XmlConfiguration && target is XmlConfiguration){
				XmlConfiguration(target).getResponseTypeByNamespace = XmlConfiguration(source).getResponseTypeByNamespace;
				XmlConfiguration(target).getResponseTypeByTagName = XmlConfiguration(source).getResponseTypeByTagName;
				XmlConfiguration(target).escapeSpecialChars = XmlConfiguration(source).escapeSpecialChars;
			}
		}
	}
}