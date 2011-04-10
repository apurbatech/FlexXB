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
package com.googlecode.flexxb.annotation.contract
{
	/**
	 * This contract specifies the basic requirements for a FlexXB
	 * recognized annotation. The basic annotation must provide a name 
	 * and a version. Annotations of specific versions will be grouped
	 * together. 
	 * @author Alexutz
	 * 
	 */	
	public interface IAnnotation
	{
		/**
		 * Get the version of the current annotation
		 * @return 
		 * 
		 */		
		function get version() : String;
		/**
		 * Get the annotation's name used in descriptor
		 * @return annotation name
		 *
		 */	
		function get annotationName() : String;
	}
}