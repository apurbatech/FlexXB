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
	import flash.events.Event;
	/**
	 * Event being raised by the serialization mechanism in order
	 * to signal various stages teh process is in. The event is
	 * raised for each complex object/subobject being processed.<br/>
	 * There are four types of events one should listen for to hook 
	 * into the mechanism:<br/>
	 * <ul>
	 * <li>preserialize - raised before the serialization of an object begins</li>
	 * <li>postserialize - raised after the objet's serialization ends</li>
	 * <li>predeserialize - raised before the deserialization of data to an object begins</li>
	 * <li>postdeserialize - raised after the deserialization ends</li>
	 * </ul>
	 * @author Alexutz
	 * 
	 */	
	public class SerializationEvent extends Event {
		public static const PRE_SERIALIZE : String = "preserialize";
		public static const POST_SERIALIZE : String = "postserialize";
		public static const PRE_DESERIALIZE : String = "predeserialize";
		public static const POST_DESERIALIZE : String = "postdeserialize";
		/**
		 * Create a preserialize event instance to be raised
		 * @param item current object being serialized
		 * @param parent current object's parent
		 * @param source serialized document being generated up to this point
		 * @return <code>SerializationEvent</code> instance
		 * 
		 */		
		public static function createPreSerializeEvent(item : Object, parent : Object, source : Object) : SerializationEvent {
			return new SerializationEvent(PRE_SERIALIZE, item, parent, source);
		}
		/**
		 * Create a postserialize event instance to be raised
		 * @param item current object being serialized
		 * @param parent current object's parent
		 * @param source serialized document being generated up to this point
		 * @return <code>SerializationEvent</code> instance
		 * 
		 */		
		public static function createPostSerializeEvent(item : Object, parent : Object, source : Object) : SerializationEvent {
			return new SerializationEvent(POST_SERIALIZE, item, parent, source);
		}
		/**
		 * Create a predeserialize event instance to be raised
		 * @param item current object being populated with deserialized data from the data source
		 * @param parent current object's parent
		 * @param source data source document being deserialized
		 * @return <code>SerializationEvent</code> instance
		 * 
		 */			
		public static function createPreDeserializeEvent(item : Object, parent : Object, source : Object) : SerializationEvent {
			return new SerializationEvent(PRE_DESERIALIZE, item, parent, source);
		}
		/**
		 * Create a postdeserialize event instance to be raised
		 * @param item current object being populated with deserialized data from the data source
		 * @param parent current object's parent
		 * @param source data source document being deserialized
		 * @return <code>SerializationEvent</code> instance
		 * 
		 */			
		public static function createPostDeserializeEvent(item : Object, parent : Object, source : Object) : SerializationEvent {
			return new SerializationEvent(POST_DESERIALIZE, item, parent, source);
		}

		private var _object : Object;
		private var _parent : Object;
		private var _source : Object;
		/**
		 * Constructor
		 * @param type event type
		 * @param item current item undergoing the serialization process
		 * @param parent parent of current item
		 * @param source serialized form of the object tree
		 * 
		 */		
		public function SerializationEvent(type : String, item : Object, parent : Object, source : Object) {
			super(type);
			_object = item;
			_parent = parent;
			_source = source;
		}
		/**
		 * Get current object
		 * @return 
		 * 
		 */		
		public function get object() : Object {
			return _object;
		}
		/**
		 * Get current object's parent
		 * @return 
		 * 
		 */		
		public function get parent() : Object{
			return _parent;
		}
		/**
		 * Get serialized document
		 * @return 
		 * 
		 */		
		public function get source() : Object {
			return _source;
		}
				
		public override function clone() : Event{
			return new SerializationEvent(type, _object, parent, _source);
		}
	}
}