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
package com.googlecode.flexxb.xml.annotation {
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.Constructor;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.contract.IMemberAnnotation;
	import com.googlecode.flexxb.annotation.parser.ClassMetaDescriptor;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	/**
	 *
	 * <p>Usage: <code>[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", 
	 * idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/", 
	 * defaultValueField="fieldName", ordered="true|false", version="versionName")]</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class XmlClass extends Annotation implements IClassAnnotation {
		/**
		 * Annotation's name
		 */
		public static const ANNOTATION_NAME : String = "XmlClass";
		
		[Bindable]
		/**
		 * Class members
		 */
		public var members : ArrayCollection = new ArrayCollection();
		/**
		 * @private
		 */
		private var id : String;
		/**
		 * @private
		 */
		private var _idField : XmlMember;
		/**
		 * @private
		 */
		private var defaultValue : String;
		/**
		 * @private
		 */
		private var _defaultValueField : Annotation;
		/**
		 * @private
		 */
		private var _useChildNamespace : String;
		/**
		 * @private
		 */
		private var _ordered : Boolean;
		/**
		 * @private
		 */
		private var _constructor : Constructor;
		/**
		 * @private
		 */		
		private var _namespaces : Dictionary;

		/**
		 *Constructor
		 *
		 */
		public function XmlClass(descriptor : ClassMetaDescriptor) {
			_constructor = new Constructor(this);
			super(descriptor);
		}

		/**
		 *
		 * @param memberFieldName
		 * @return
		 *
		 */
		public function getMember(memberFieldName : String) : IMemberAnnotation {
			if (memberFieldName && memberFieldName.length > 0) {
				for each (var member : IMemberAnnotation in members) {
					if (member.name.localName == memberFieldName) {
						return member;
					}
				}
			}
			return null;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get constructor() : Constructor {
			return _constructor;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get idField() : IMemberAnnotation {
			return _idField;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get valueField() : Annotation {
			return _defaultValueField;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get ordered() : Boolean {
			return _ordered;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function hasDefaultValueField() : Boolean {
			return _defaultValueField != null;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get childNameSpaceFieldName() : String {
			return _useChildNamespace;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function useOwnNamespace() : Boolean {
			return _useChildNamespace == null || _useChildNamespace.length == 0;
		}
		
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}
		
		protected override function parse(descriptor : MetaDescriptor) : void {
			nameSpace = getNamespace(descriptor);
			
			super.parse(descriptor);
			
			var desc : ClassMetaDescriptor = descriptor as ClassMetaDescriptor;
			id = desc.attributes[XmlConstants.ID];
			_useChildNamespace = desc.attributes[XmlConstants.USE_CHILD_NAMESPACE];
			_ordered = desc.getBooleanAttribute(XmlConstants.ORDERED);
			defaultValue = desc.attributes[XmlConstants.VALUE];
			
			processNamespaces(desc);
			
			for each(var meta : MetaDescriptor in desc.members){
				addMember(AnnotationFactory.instance.getAnnotation(meta, this) as XmlMember);
			}
			
			constructor.parse(desc);
			
			memberAddFinished();
		}
		
		/**
		 *
		 * @param annotation
		 *
		 */
		private function addMember(annotation : XmlMember) : void {
			if (annotation && !isFieldRegistered(annotation)) {
				if(annotation.hasNamespaceRef()){
					annotation.nameSpace = getRegisteredNamespace(annotation.namespaceRef);
				}else{
					annotation.nameSpace = nameSpace;
				}
				members.addItem(annotation);
				if (annotation.name.localName == id) {
					_idField = annotation;
				}
				if (annotation.alias == defaultValue) {
					_defaultValueField = annotation;
				}
			}
		}
		
		private function memberAddFinished() : void {
			//Flex SDK 4 hotfix: we need to put the default field first, if it exists,
			// otherwise the default text will be added as a child of a previous element 
			var member : XmlMember;
			for (var i : int = 0; i < members.length; i++){
				member = members[i] as XmlMember;
				if(member.isDefaultValue()){
					members.addItemAt(members.removeItemAt(i), 0);
					break;
				}
			}
			if (ordered) {
				var sort : Sort = new Sort();
				var fields : Array = [];
				fields.push(new SortField("order", false, false, true));
				fields.push(new SortField("alias", true, false, false));
				sort.fields = fields;
				members.sort = sort;
				members.refresh();
			}
		}
		
		private function processNamespaces(descriptor : ClassMetaDescriptor) : void{
			var nss : Array = descriptor.getConfigItemsByName(XmlConstants.ANNOTATION_NAMESPACE);
			if(nss.length > 0){
				_namespaces = new Dictionary();
				var ns : Namespace;
				for each(var nsDesc : MetaDescriptor in nss){
					ns = getNamespace(nsDesc);
					_namespaces[ns.prefix] = ns;
				}
			}
		}
		
		private function getRegisteredNamespace(ref : String) : Namespace{
			if(!_namespaces || !_namespaces[ref]){
				throw new DescriptorParsingError(type, "", "Namespace reference <<" + ref + ">> could not be found. Make sure you typed the prefix correctly and the namespace is registered as annotation of the containing class.");
			}
			return _namespaces[ref] as Namespace;
		}

		private function getNamespace(descriptor : MetaDescriptor) : Namespace {
			var prefix : String = descriptor.attributes[XmlConstants.NAMESPACE_PREFIX];
			var uri : String =  descriptor.attributes[XmlConstants.NAMESPACE_URI];
			if (uri == null || uri.length == 0) {
				return null;
			}
			if (prefix != null && prefix.length > 0) {
				return new Namespace(prefix, uri);
			}
			return new Namespace(uri);
		}

		private function isFieldRegistered(annotation : Annotation) : Boolean {
			for each (var member : Annotation in members) {
				if (member.name == annotation.name) {
					return true;
				}
			}
			return false;
		}
	}
}