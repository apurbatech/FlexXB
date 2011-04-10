/*******************************************************************************************************/
/**			 ${project.name} version ${project.version} (${currentDate})		      **/
/**								by Alex Ciobanu 		      **/
/*******************************************************************************************************/

Copyright 2008 - 2010 Alex Ciobanu (http://code.google.com/p/flexxb)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

CONTENTS

${project.name}-${release.version}-${today}-bin.zip - contains the ${project.name} library along with the test application
			/bin/ 			    - SWC file and test application directory
			/bin/test/ 		    - the test application
			/bin/flexunit               - flexunit automated test reports
			/bin/api-schema             - XSD schema defining the structure of the XML file that describes types that can't be annotated 
			/doc/ 			    - ASDOC
			/samples/	            - samples showing ${project.name} features 
			/README.txt		    - version release notes

${project.name}-${release.version}-${today}-src.zip - contains source files
			/${project.name}/	    - ${project.name} project sources
			/${project.name}Test        - ${project.name} test application sources

DESCRIPTION

FlexXB is an ActionScript library designed to automate the AS3 objects' serialization to XML to be sent to a backend server
and the xml deserialization into AS3 objects of a response received from that server.

In order for FlexXB to be able to automate the (de)serialization process, the model objects involved must be "decorated" with
AS3 metadata tags that will instruct it on how they should be processed: 
 * Which object fields translate into xml attributes, which into xml elements and which should be ignored? 
 * Should we use namespaces to build the request xml and parse the response one? If so, what are the namespaces? 
 * The object's fields need to have different names in the xml representation? 

All this information is linked to the object by adding metadata tags (annotations - in Java - or attributes - in .NET) to the
class definition of the object in question. 
When an object is passed to it for serialization, it inspects the object's definition and extracts a list of annotations 
describing the way an object of that type needs to be (de)serialized. It keeps the generated list in a cache in order to 
reuse it if need arises and then builds the corresponding XML using the information provided by the annotations. Any object 
field that does not have an annotation defined is ignored in the (de)serialization process of that object. 
There are five built-in annotations for describing object serialization, one being class-scoped, the other field-scoped: 
 * XmlClass: Defines class's namespace (by uri and prefix) and xml alias; 
 * ConstructorArg: Defines the arguments with which the constructor should be run. Applies to classes with non default constructors and is defined at the same level with XmlXClass; 
 * Namespace: defines alternate namespaces used by elements of the class. It is defined at class level and multiple definitions are allowed;
 * XmlAttribute: Marks the field to be rendered as an attribute of the xml representation of the parent object; 
 * XmlElement: Marks the field to be rendered as a child element of the xml representation of the parent object;
 * XmlArray: Is a particular type of element since it marks a field to be rendered as an Array of elements of a certain type.

FEATURES

	* FXB-001 Support for object namespacing
	* FXB-002 Xml alias
	* FXB-003 Ignore a field on serialization, deserialization or both 
	* FXB-010 Allow custom object (de)serialization
	* FXB-005 Integrate model object cache to insure object uniqueness 
	* FXB-004 Serialize partial object 
	* FXB-008 Custom to and from string conversion for simple types
	* FXB-012 Add getFromCache option for deserializing complex fields
	* FXB-014 Add events to signal processing start and finish 
	* FXB-015 Xml Service
	* FXB-009 Use paths in xml aliases
	* FXB-016 Annotation API
	* FXB-017 Constructor Annotation
	* FXB-018 Multiple namespace support
	* FXB-019 Annotation versioning
	* FXB-020 Circular reference handling
	
USAGE

The main access point from the 1.x version, com.googlecode.serializer.flexxb.FlexXBEngine, is deprecated in FlexXB 2.x. However, for compatibility reasons this class is still available; it will only work for xml serialization and provide the same methods as in previous versions. Do not use FlexXBEngine class if you need to support a new serialization format. 

* Using built-in XML serialization

To get the serializer to be used in xml handling:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer() : IFlexXB 

To serialize an object to xml:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().serialize(object) 

To deserialize a received xml to an object, given the object's class:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().deserialize(xml, class) 

To get the configuration for the xml serializer. One may need to convert the configuration instance to its true type, com.googlecode.flexxb.xml.XmlConfiguration in order to access all settings:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().configuration 

To do an early processing of class types required for deserialization so as not to have problems when classes are not known:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().processTypes(...args) : void
 
To register a custom annotation:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().context.registerAnnotation(name, annotationClass, serializerClass, overrideExisting)
 
To register a class type converter:
com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().context.registerSimpleTypeConverter(converterInstance, overrideExisting)
 
In order to register a class descriptor created via the FlexXB API for classes that cannot be accessed in order to add annotations: 
com.googlecode.flexxb.core.FxBEngine.instance.api.processTypeDescriptor(apiTypeDescriptor)
 
To provide an API descriptor file content in which the class descriptors are depicted in an XML format:
com.googlecode.flexxb.core.FxBEngine.instance.api.processDescriptorsFromXml(xml) 

* Customizing serialization format

To create a description context, the core of your custom serialization, extend com.googlecode.flexxb.core.DescriptionContext. Overridable methods: 
•protected function performInitialization() : void - Initialize your context registering annotations, serializers and converters you need. You should set the configuration object extending com.googlecode.flexxb.core.Configuration if you require special settings. 
•public function handleDescriptors(descriptors : Array) : void - Once a new type has been processed, the context has the chance to handle the descriptors in order to construct internal structures it may need (for example, in handling XML, determine the type by the namespace used). 
•public function getIncomingType(source : Object) : Class - Determine the object type associated with the incoming serialized form at runtime. It is recommended that you override this method in subclasses because each serialization format has different ways of determining the type of the object to be used in deserialization. 

To register the new serialization format context: 
com.googlecode.flexxb.core.FxBEngine.instance.registerDescriptionContext(name : String, context : DescriptionContext) : void 

To get the associated serializer: 
com.googlecode.flexxb.core.FxBEngine.instance.getSerializer(name : String) : IFlexXB
 
To serialize an object to the custom format:
com.googlecode.flexxb.core.FxBEngine.instance.getSerializer(name : String).serialize(object)
 
To deserialize a received data in a custom format to an object, given the object's class:
com.googlecode.flexxb.core.FxBEngine.instance.getSerializer(name : String).deserialize(xml, class) 

* Using the api

In order to register a class descriptor created via the FlexXB API for classes that cannot be accessed in order to add annotations:
com.googlecode.serializer.flexxb.core.FxBEngine.instance.api.processTypeDescriptor(apiTypeDescriptor) 

To provide an API descriptor file content in which the class descriptors are depicted in an XML format:
com.googlecode.serializer.flexxb.core.FxBEngine.instance.api.processDescriptorsFromXml(xml) 

!NOTE!: Make sure you add the following switches to your compiler settings:
	 -keep-as3-metadata XmlClass -keep-as3-metadata XmlAttribute -keep-as3-metadata XmlElement -keep-as3-metadata XmlArray -keep-as3-metadata ConstructorArg -keep-as3-metadata Namespace

Annotation syntax:

XmlClass
[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/", defaultValueField="fieldName", ordered="true|false", version="version_Name")] 

ConstructorArg
[ConstructorArg(reference="element", optional="true|false")]

Namespace
[Namespace(prefix="NS_Prefix", uri="NS_Uri")]

XmlAttribute
[XmlAttribute(alias="attribute", ignoreOn="serialize|deserialize", order="order_index", namespace="NameSpace_Prefix", idref="true|false", version="version_Name")]

XmlElement
[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", serializePartialElement="true|false", order="order_index", getRuntimeType="true|false", namespace="NameSpace_Prefix", idref="true|false", version="version_Name")]  

XmlArray
[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false", getRuntimeType="true|false", order="index", namespace="NameSpace_Prefix", version="version_Name", idref="true|false")] 


Note: Using as alias "*" on a field will force the serializer to serialize that field using an alias computed at runtime by the 
runtime type of the field's value, except for XmlArray. For XmlArray using the "*" alias will cause the members of the array value 
to be rendered as children of the owner object xml rather than children of an xml element specifying the array. For XmlArray, setting 
getRuntimeType flag to true will cause the engine to analyse each item in the xml representation of the array and determine the type
of it from the name tag or namespace. 

KNOWN LIMITATIONS

- If an object's field has values of subtypes of the field's type and the alias is set to "*" then the deserialization process will 
  return null for that field.

RELEASE NOTES

2.0.1 - 20-02-2011
	  - Fix: Issue 38 - XmlArray getFromCache idref deserialisation bug when a cacheProvider isn't set via configuration 
	  - Fix: Issue 39 - registerSimpleTypeConverter ignored during deserialisation in flexXB 2.0 

2.0 - 09-01-2011
	- Feature: FXB-21 - Serialization format support

1.7.1 - 01-11-2010
	  - Enhancement: Issue 32 - Allow xml version to be picked up automatically  
	  - Enhancement: Issue 33 - Support typed vectors in XmlArray metadata  
	  - Fix: Issue 31 - Provide a better and more reliable error handling mechanism  

1.7.0 - 23-10-2010
	  - Feature: Issue 25, FXB-020 - Circular reference handling
	  - Enhancement: Issue 5 - Allow the user to specify a name that will be used for sending a sub-object that will be rendered as an Element only as an ID
	  - Feature: FXB-019 - Annotation versioning 

1.6.3 - 15-09-2010
      - Fix: Issue 29 - Namespace prefix output on deserialize is incorrect

1.6.2 - 27-06-2010
	  - Fix: Issue 26 - Xml fields get serialized in escaped chars 
	  - Fix: Issue 27 - Xml fields are not correctly deserialized if the value only contains an inline element
	  -	Fix: Issue 28 - Array of simple typed items without wrapping elements is not deserialized correctly 

1.6.1-R2 - 24-05-2010
	 - Changed the licensing scheme to Apache License v2.0
	 - Upgraded the unit testing to Flex Unit 4

1.6.1 - 20-04-2010
	- Enhancement: Issue 22: Add the ability to specify a default value upon deserialization
	- Enhancement: Issue 23: Add logging support

1.6 - 26-03-2010
	- Support for Flex 4 SDK
	- Fix: Proper null check in PersistableList and XmlArraySerializer

1.5 - 15-03-2010
	- Fix: Issue 19: Problem appears when using a class as a type provider 
	- Fix: Issue 20: FlexXB API fails if using xml description file  
	- Fix: Issue 21: Remove singleton restrictions on FlexXBEngine 
	- Fix: Make escape by using CDATA wraper tags; make escaping configurable (escape special tags vs using CDAYA wrapper tags)
	- Fix: Fixed NPE issue when using the isAdded/isRemove/isMoved methods in PersistableList

1.4.1 - 28-12-2009
	- Enhancement: Issue 17, FXB-018: Multiple namespaces per class definition - Added Namespace annotation 
	- Fix: Issue 18: Fields of type xml are not deserialized correctly 
	- Fix: The API Array member would not properly set memberType when retrieving the xml descriptor
	- Fix: When using virtual paths along with namespaces (class or member namespace), the namespace was not embedded in the virtual elements.
	
1.4 - 01-10-2009
	- Fix: Issue 16 - Support Array of int or Number 
	- Enhancement: Persistence: Added watch referenced fields feature to PersistableObject
	- Enhancement: Persistence: Added exclude field from listening feature to PersistableObject
	- Fix: Persistence: Fixed issues with PersistableList handling changes within
	- Enhancement: Persistence: Updated PersistableList to allow easy access to changed items

1.3 - 20-07-2009
	- Fix: Issue 13 - IXmlSerializable not working... 
	- Fix: Issue 14 - Add support for namepaced class fields
	- Fix: Issue 15 - Not all XmlClass annotation attributes are covered in api 
	- Enhancement: Added getRuntimeType flag to XmlElement to get the deserialization field type on the fly
	- Enhancement: ReferenceList

1.2 - 20-06-2009
	- Fix 11: Issue 11 - Error in library 1.1 ,mx.managers:ISystemManager does not implements interface mx.managers:ISystemManager 
	- Feature: FXB-017 - Constructor Annotation
	- Enhancement: PersistableObject
	- Enhancement: API components business rules are enforced;
	- Fix: corrected parsing of API xml configuration file

1.1 - 01-05-2009
	- Fix: Issue 10 - Allow serialization of read-only properties
	- Enhancement/Feature: Issue 6 - Include support for serializing objects that can't be decorated with Flexxb annotations  
						   FXB-016 Annotation API
	- Fix: Issue 9 - Still possible to have escaping problems    

1.0.1 - 03-04-2009
	- Fix: Issue 7 - Order annotation on XmlMember and Ordered on XmlClass (http://code.google.com/p/flexxb/issues/detail?id=7)
	- Fix: Issue 8 - Escape characters (http://code.google.com/p/flexxb/issues/detail?id=8)
	- Other small fixes.

1.0 - 24-03-2009
	- Enhancement (Issue 4) - Add support for having text elements in a serialized object 
	- Feature: FXB-009 Use paths in xml aliases
	- Enhancement - Get object type to deserialize into by the xml namespace
	- Changed the name of the entry point class to FlexXBEngine

1.0 beta - 10-11-2008
	- Feature: FXB-005 Integrate model object cache to insure object uniqueness 
	- Feature: FXB-004 Serialize partial object 
	- Feature: FXB-008 Custom to and from string conversion for simple types
	- Feature: FXB-012 Add getFromCache option for deserializing complex fields
	- Feature: FXB-014 Add events to signal processing start and finish 
	- Feature: FXB-015 Xml Service (preview)
	- Fix: Fields of type XML are not correctly (de)serialized

1.0 alpha - 01-10-2008
	First alpha release.