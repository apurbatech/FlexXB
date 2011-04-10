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
package com.googlecode.flexxb.cache
{
	import com.googlecode.flexxb.util.Instanciator;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * 
	 * @author Alexutzutz
	 * 
	 */	
	public class ObjectCache implements ICacheProvider
	{
		/**
		 *@private 
		 */		
		private static const _instance : ObjectCache = new ObjectCache();
		/**
		 * Easy access instance. 
		 * @return 
		 * 
		 */		
		public static function get instance() : ObjectCache{
			return _instance;
		}
		/**
		 * @private
		 */		
		private var cacheMap : Dictionary = new Dictionary();
		/**
		 * Constructor
		 * 
		 */		
		public function ObjectCache(){
			cacheMap = new Dictionary();
		}
		
		public function isInCache(id : String, clasz : Class) : Boolean {
			return cacheMap[clasz] && cacheMap[clasz][id] != null;
		}
		
		public function getFromCache(id : String, clasz : Class) : * {
			if (cacheMap[clasz]) {
				return cacheMap[clasz][id];
			} else {
				return null;
			}
		}
		
		public function getNewInstance(clasz : Class, id : String, parameters : Array = null) : * {
			var item : Object;
			if(clasz){
				item = Instanciator.getInstance(clasz, parameters);
				putObject(id, item);
			}
			return item;
		}
		
		/**
		 * Put an object in the cache
		 * @param id the id under which the object will be cached
		 * @param object the object itself
		 * @return if the object was succesfuly cached.
		 *
		 */
		public function putObject(id : String, object : Object) : void {
			if (id && object) {
				var qualifiedName : String = getQualifiedClassName(object);
				var clasz : Class = ApplicationDomain.currentDomain.getDefinition(qualifiedName) as Class;
				if (!cacheMap[clasz]) {
					cacheMap[clasz] = new Dictionary();
				}
				cacheMap[clasz][id] = object;
			}
		}
		
		public function clearCache(...typeList) : void {
			if(typeList && typeList.length > 0){
				for each(var type : Object in typeList){
					if(cacheMap[type]){
						delete cacheMap[type];
					}
				}
			} else {
				for (var key : * in cacheMap){
					delete cacheMap[key];
				}
				cacheMap = new Dictionary();
			}
		}
	}
}