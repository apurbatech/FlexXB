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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.converter.IConverter;
	import com.googlecode.flexxb.annotation.contract.Stage;

	/**
	 * @private
	 * @author Alexutz
	 *
	 */
	public class StageXmlConverter implements IConverter {
		
		public function get type() : Class {
			return Stage;
		}

		public function toString(object : Object) : String {
			return (object as Stage).toString();
		}

		public function fromString(value : String) : Object {
			return Stage.fromString(value);
		}
	}
}