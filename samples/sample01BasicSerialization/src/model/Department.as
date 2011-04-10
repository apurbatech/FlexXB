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
	import com.googlecode.flexxb.IIdentifiable;
	
	[XmlClass(alias="CompanyDepartment", prefix="dept", uri="http://myCompanyUrl.com")]
	[ConstructorArg(reference="id")]
	[ConstructorArg(reference="name")]
	[Bindable]
	public class Department implements IIdentifiable
	{
		[XmlAttribute(alias="ID")]
		public var id : String;
		
		[XmlElement(alias="DepartmentName")]
		public var name : String;
		
		[XmlElement(alias="Leader")]
		public var departmentHead : Person;
		
		public function Department(id : String, name : String)
		{
			super();
			this.id = id;
			this.name = name;
		}
		
		public function get thisType():Class
		{
			return Department;
		}
		
	}
}