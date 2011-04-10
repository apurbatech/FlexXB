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
package com.googlecode.flexxb.core {
	import com.googlecode.flexxb.converter.IConverter;

	import flash.utils.Dictionary;

	/**
	 * @private
	 * @author Alexutz
	 *
	 */
	internal class ConverterStore implements IConverterStore {
		private var converterMap : Dictionary;

		/**
		 *
		 *
		 */
		public function ConverterStore() {

		}

		/**
		 *
		 * @param converter
		 * @param overrideExisting
		 * @return
		 *
		 */
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean {
			if (converter == null || converter.type == null) {
				return false;
			}
			if (!overrideExisting && converterMap && converterMap[converter.type]) {
				return false;
			}
			if (converterMap == null) {
				converterMap = new Dictionary();
			}
			converterMap[converter.type] = converter;
			return true;
		}

		/**
		 *
		 * @param type
		 * @return
		 *
		 */
		public function hasConverter(type : Class) : Boolean {
			return converterMap && type && converterMap[type] is IConverter;
		}

		/**
		 *
		 * @param clasz
		 * @return
		 *
		 */
		public function getConverter(clasz : Class) : IConverter {
			return converterMap[clasz] as IConverter;
		}
		
		public final function stringToObject(value : String, clasz : Class) : Object {
			if (hasConverter(clasz)) {
				return getConverter(clasz).fromString(value);
			}
			if (value == null)
			{
				return null;
			}
			if(value == "")
			{
				return "";
			}
				
			if (clasz == Boolean) {
				return (value && value.toLowerCase() == "true");
			}
			if (clasz == Date) {
				if (value == "") {
					return null;
				}
				var date : Date = new Date();
				date.setTime(Date.parse(value));
				return date;
			}
			return clasz(value);
		}
		
		public final function objectToString(object : Object, clasz : Class) : String {
			if (hasConverter(clasz)) {
				return getConverter(clasz).toString(object);
			}
			if (object is String) {
				return object as String;
			}
			try {
				return object.toString();
			} catch (e : Error) {
				//should we do something here? I guess not
			}
			return "";
		}

	}
}