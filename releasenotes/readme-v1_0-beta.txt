/****************************************************************************/
/**					FlexXB version 1.0 beta (10-11-2008)				   **/
/**							by Alex Ciobanu								   **/
/****************************************************************************/

Copyright 2008 Alex Ciobanu (http://code.google.com/p/flexxb)

CONTENTS

FlexXB-1_0-beta-bin.zip - contains the flexxb library along with the test 
							application
			/bin/ 				- SWC file and test application directory
			/bin/test/ 			- the test application
			/doc/ 				- ASDOC
			/samples/			- samples showing FlexXB's features 
			/README.txt	- version release notes

FlexXB-1_0-beta-src.zip - contains source files
			/FlexXB/	- FlexXB project sources
			/FlexXBTest - FlexXB test application sources

DESCRIPTION

FlexXB is an ActionScript library designed to automate the AS3 objects' 
serialization to XML to be sent to a backend server and the xml 
deserialization into AS3 objects of a response received from that server.

In order for FlexXB to be able to automate the (de)serialization process, 
the model objects involved must be "decorated" with AS3 metadata tags that 
will instruct it on how they should be processed: 
 * Which object fields translate into xml attributes, which into xml elements 
   and which should be ignored? 
 * Should we use namespaces to build the request
   xml and parse the response one? If so, what are the namespaces? 
 * The object's fields need to have different names in the xml representation? 

All this information is linked to the object by adding metadata tags 
(annotations - in Java - or attributes - in .NET) to the class definition 
of the object in question. 
When an object is passed to it for serialization, it inspects the object's 
definition and extracts a list of annotations describing the way an object of 
that type needs to be (de)serialized. It keeps the generated list in a cache 
in order to reuse it if need arises and then builds the corresponding XML 
using the information provided by the annotations. Any object field that does 
not have an annotation defined is ignored in the (de)serialization process of
that object. 
There are four built-in annotations for describing object serialization, 
one being class-scoped, the other field-scoped: 
 * XmlClass: Defines class's namespace (by uri and prefix) and xml alias; 
 * XmlAttribute: Marks the field to be rendered as an attribute of the xml 
			     representation of the parent object; 
 * XmlElement: Marks the field to be rendered as a child element of the xml 
               representation of the parent object;
 * XmlArray: Is a particular type of element since it marks a field to be 
		     rendered as an Array of elements of a certain type.

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
	* FXB-015 Xml Service (preview)
	

USAGE

To serialize an object to xml:
com.googlecode.serializer.flexxb.XMLSerializer.serialize(object)

To deserialize a received xml to an object, given the object's class:
com.googlecode.serializer.flexxb.XMLSerializer.deserialize(xml, class)

To register a custom annotation, subclass of com.googlecode.serializer.flexxb.Annotation:
com.googlecode.serializer.flexxb.XMLSerializer.registerAnnotation(name, annotationClass, serializerClass, overrideExisting)

To register a converter that will handle how an object of a specific type is converted to a String value that will be attached to the xml representation and viceversa:
com.googlecode.serializer.flexxb.XMLSerializer.registerSimpleTypeConverter(converterInstance, overrideExisting)

Note: Make sure you add the following switches to your compiler settings:
	 -keep-as3-metadata XmlClass -keep-as3-metadata XmlAttribute -keep-as3-metadata XmlElement -keep-as3-metadata XmlArray

Annotation syntax:

XmlClass
[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/")] 

XmlAttribute
[XmlAttribute(alias="attribute", ignoreOn="serialize|deserialize")] 

XmlElement
[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", serializePartialElement="true|false")] 

XmlArray
[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false")]

Note: Using as alias "*" on a field will force the serializer to serialize that 
field using an alias computed at runtime by the runtime type of the field's value.

KNOWN LIMITATIONS

- If an object's field has values of subtypes of the field's type and the alias is 
set to "*" then the deserialization process will return null for that field.

- Circular references in the object graph will cause StackOverflow exceptions.

RELEASE NOTES

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