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
package com.googlecode.flexxb.annotation.parser
{
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * @private
	 * @author Alexutz
	 * 
	 */	
	public final class MetaParser
	{
		
		private var name : QName;
		private var type : Class;
		/**
		 * Constructor 
		 * 
		 */		
		public function MetaParser(){ }
		
		/**
		 * 
		 * @param xmlDescriptor
		 * @return array of IClassAnnotation implementor instances, one for each version dicovered in the descriptor
		 * @see com.googlecode.flexxb.annotation.IClassAnnotation
		 * @throws com.googlecode.flexxb.error.DescriptorParsingError
		 * 
		 */		
		public function parseDescriptor(xmlDescriptor : XML) : Array{
			var classes : Object = new Object();
			if(xmlDescriptor.factory.length() > 0){
				xmlDescriptor = xmlDescriptor.factory[0];
			}
			processClassDescriptors(xmlDescriptor, classes);
			var field : XML;
			for each (field in xmlDescriptor..variable) {
				processMemberDescriptors(field, classes, name, type);
			}
			for each (field in xmlDescriptor..accessor) {
				processMemberDescriptors(field, classes, name, type);
			}
			var result : Array = [];
			var descriptor : ClassMetaDescriptor;
			for(var key : * in classes){
				descriptor = classes[key];
				result.push(AnnotationFactory.instance.getAnnotation(descriptor, null));
			}
			name = null;
			type = null;
			return result;
		}
		
		private function processClassDescriptors(xml : XML, classMap : Object) : void{
			var classType : String = xml.@type;
			if (!classType) {
				classType = xml.@name;
			}
			name = new QName(null, classType.substring(classType.lastIndexOf(":") + 1));
			type = getDefinitionByName(classType) as Class;
			var metas : XMLList = xml.metadata;
			var descriptors : Array = [];
			var descriptor : MetaDescriptor;
			for each(var meta : XML in metas){
				descriptor = parseMetadata(meta);
				if(!descriptor){
					continue;
				}
				if(AnnotationFactory.instance.isMemberAnnotation(descriptor.metadataName)){
					throw new DescriptorParsingError(type, "", "Member type metadata found on class level. You should only define class and global metadatas at class level. Class metadata representant must implement IClassAnnotation; Global metadata representant must implement IGlobalAnnotation");
				}
				descriptor.fieldName = name;
				descriptor.fieldType = type;
				//we have global anotations 
				if(AnnotationFactory.instance.isGlobalAnnotation(descriptor.metadataName)){
					descriptors.push(descriptor);
					continue;
				}
				//we have class annotations
				if(classMap[descriptor.version]){
					throw new DescriptorParsingError(type, "", "Two class type metadatas found with the same version (" + descriptor.version + ")");
				}
				classMap[descriptor.version] = descriptor;
			}
			var owner : ClassMetaDescriptor;
			
			//we need to assign the global descriptors to their proper class annotations
			for each(descriptor in descriptors){
				owner = classMap[descriptor.version];
				if(owner){
					owner.config.push(descriptor);
				}else{
					throw new DescriptorParsingError(owner.fieldType, descriptor.fieldName.localName, "Could not find a class annotation with the version" + meta.version);
				}
			}			
		}
		
		private function processMemberDescriptors(field : XML, classMap : Object, className : QName, classType : Class) : void{
			var descriptors : Array = parseField(field);
			var owner : ClassMetaDescriptor;
			var ownerName : String;
			for each(var meta : MetaDescriptor in descriptors){
				owner = classMap[meta.version];
				if(owner == null && (ownerName = getOwnerName(meta))){
					owner = new ClassMetaDescriptor();
					owner.metadataName = ownerName;
					owner.fieldType = classType;
					owner.fieldName = className;
					classMap[meta.version] = owner;
				}
				if(owner){
					owner.members.push(meta);
				}else{
					throw new DescriptorParsingError(classType, meta.fieldName.localName, "Could not find a class annotation with the version" + meta.version);
				}
			}
		}
		
		public function parseMetadata(xml : XML) : MetaDescriptor{
			var metadataName : String = xml.@name;
			var descriptor : MetaDescriptor;
			//Need to make sure we're not parsing any bogus annotation
			if(AnnotationFactory.instance.isRegistered(metadataName)){
				descriptor = getDescriptorInstance(metadataName);
				descriptor.metadataName = xml.@name;
				for each(var argument : XML in xml.arg){
					descriptor.attributes[String(argument.@key)] = String(argument.@value);
				}
			}
			return descriptor;
		}
		
		private function getDescriptorInstance(metadataName : String) : MetaDescriptor{
			if(AnnotationFactory.instance.isClassAnnotation(metadataName)){
				return new ClassMetaDescriptor();
			}
			return new MetaDescriptor();
		}
		
		public function parseField(xml : XML) : Array{
			var descriptors : Array = [];
			var name : QName = new QName(xml.@uri, xml.@name);
			var accessType : AccessorType = AccessorType.fromString(xml.@access);
			var type : Class;
			try{
				type = getDefinitionByName(xml.@type) as Class;
			}catch(e : Error){
				throw e;
			}
			var metas : XMLList = xml.metadata;
			var descriptor : MetaDescriptor;
			for each(var meta : XML in metas){
				descriptor = parseMetadata(meta);
				if(descriptor){
					if(!AnnotationFactory.instance.isMemberAnnotation(descriptor.metadataName)){
						throw new DescriptorParsingError(type, "", "Non-Member type metadata found on field level. You should only define class and global metadatas at class level. The member metadata must implement IMemberAnnotation.");
					}
					descriptor.fieldName = name;
					descriptor.fieldType = type;
					descriptor.fieldAccess = accessType;
					descriptors.push(descriptor);
				}
			}
			return descriptors;
		}
		
		private function getOwnerName(meta : MetaDescriptor) : String{
			return AnnotationFactory.instance.getClassAnnotationName(meta.metadataName);
		}
	}
}