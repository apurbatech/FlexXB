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
package com.googlecode.flexxb.core
{
	/**
	 * @private
	 * @author Alexutz
	 * 
	 */	
	internal final class ElementStack
	{
		private var stack : Array;
		/**
		 * Constructor 
		 * @param stackReference
		 * 
		 */			
		public function ElementStack(stackReference : Array = null){
			if(stackReference){
				stack = stackReference;
			}else{
				stack = [];
			}
		}
		
		public function beginDocument() : void{
			
		}
		/**
		 * 
		 * @param item
		 * @return 
		 * 
		 */		
		public function push(item : Object) : Boolean{
			if(stack.indexOf(item) == -1){
				stack.push(item);
				return true;
			}
			return false;
		}
		/**
		 * 
		 * @param item
		 * 
		 */		
		public function pushNoCheck(item : Object) : void{
			stack.push(item);
		} 
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function pop() : Object{
			return stack.pop();
		}
		/**
		 * Returns a reference to the current object being processed
		 * @return 
		 * 
		 */	
		public function getCurrent() : Object{
			if(stack.length > 0){
				return stack[stack.length - 1];
			}
			return null;
		}
		/**
		 * Returns a reference to the current object's parent. 
		 * @return 
		 * 
		 */		
		public function getParent() : Object{
			if(stack.length > 1){
				return stack[stack.length - 2];
			}
			return null;
		}
		
		public function endDocument() : void{
			clear();
		}
		
		private function clear() : void{
			while(stack.length > 0){
				stack.pop();
			}
		}
	}
}