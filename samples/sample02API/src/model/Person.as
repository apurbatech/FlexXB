/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
package model
{
	[Bindable]
	public class Person
	{
		public var id : String = "1";
		
		public var firstName : String;
		
		public var lastName : String;
		
		public var age : int;
		
		public var position : String;
		
		public function Person(firstName : String, lastName : String)
		{
			super();
			this.firstName = firstName;
			this.lastName = lastName;
		}		
	}
}