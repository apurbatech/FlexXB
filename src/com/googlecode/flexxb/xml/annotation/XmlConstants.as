/**
 *   FlexXB
 *   Copyright (C) 2008-2011 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 * 
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.googlecode.flexxb.xml.annotation
{
	import com.googlecode.flexxb.annotation.contract.Constants;

	/**
	 * @private 
	 * @author Alexutz
	 * 
	 */	
	public class XmlConstants extends Constants
	{
		
		public static const ANNOTATION_NAMESPACE : String = "Namespace";
		/**
		 * 
		 */		
		public static const ALIAS : String = "alias";
		/**
		 * 
		 */		
		public static const ALIAS_ANY : String = "*";
		/**
		 * Namespace prefix
		 */
		public static const NAMESPACE_PREFIX : String = "prefix";
		/**
		 * 
		 */		
		public static const NAMESPACE : String = "namespace";
		/**
		 * Namespace uri
		 */
		public static const NAMESPACE_URI : String = "uri";
		/**
		 *
		 */
		public static const USE_CHILD_NAMESPACE : String = "useNamespaceFrom";
		/**
		 *
		 */
		public static const ID : String = "idField";
		/**
		 *
		 */
		public static const VALUE : String = "defaultValueField";
		/**
		 *
		 */
		public static const ORDERED : String = "ordered";
		/**
		 * Order attribute name
		 */
		public static const ORDER : String = "order";
		/**
		 * Id reference 
		 */		
		public static const IDREF : String = "idref";
		/**
		 * Path separator used for defining virtual paths in the alias
		 */
		public static const ALIAS_PATH_SEPARATOR : String = "/";
		/**
		 * 
		 */		
		public static const NAMESPACE_REF : String = "namespace";
		/**
		 * SerializePartialElement attribute name
		 */
		public static const SERIALIZE_PARTIAL_ELEMENT : String = "serializePartialElement";
		/**
		 * GetFromCache attribute name
		 */
		public static const GET_FROM_CACHE : String = "getFromCache";
		/**
		 * 
		 */		
		public static const GET_RUNTIME_TYPE : String = "getRuntimeType";
		/**
		 *
		 */
		public static const TYPE : String = "type";
		/**
		 *
		 */
		public static const MEMBER_NAME : String = "memberName";
	}
}