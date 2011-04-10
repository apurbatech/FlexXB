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
	import com.googlecode.flexxb.api.AccessorTypeConverter;
	import com.googlecode.flexxb.api.FxApiWrapper;
	import com.googlecode.flexxb.api.FxClass;
	import com.googlecode.flexxb.api.FxConstructorArgument;
	import com.googlecode.flexxb.api.FxMember;
	import com.googlecode.flexxb.api.IFlexXBApi;
	import com.googlecode.flexxb.api.IFxMetaProvider;
	import com.googlecode.flexxb.api.StageXmlConverter;
	import com.googlecode.flexxb.api.flexxb_api_internal;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author Alexutz
	 * @private
	 */
	internal final class FlexXBApi implements IFlexXBApi {
		
		private static const LOG : ILogger = LogFactory.getLog(FlexXBApi);
		
		private var core : FlexXBCore;
		private var store : DescriptorStore;

		/**
		 * Constructor
		 * @param core the xml serialization core
		 * @param store
		 *
		 */
		public function FlexXBApi(core : FlexXBCore, store : DescriptorStore) {
			this.core = core;
			this.store = store;
			core.context.registerSimpleTypeConverter(new StageXmlConverter());
			core.context.registerSimpleTypeConverter(new AccessorTypeConverter());
			core.processTypes(FxConstructorArgument);
		}
		
		public function processTypeDescriptor(apiDescriptor : FxClass) : void {
			if (apiDescriptor) {
				var type : Class = apiDescriptor.type;
				store.registerDescriptor(buildTypeXmlDescriptor(apiDescriptor), type);
			}
		}
		
		public function processDescriptorsFromXml(xml : XML) : void {
			if (xml) {
				var apiWrapper : FxApiWrapper = core.deserialize(xml, FxApiWrapper);
				if (apiWrapper) {
					for each (var classDescriptor : FxClass in apiWrapper.descriptors) {
						if (classDescriptor) {
							if(core.configuration.enableLogging){
								LOG.info("Processing class {0}", classDescriptor.type);
							}
							processTypeDescriptor(classDescriptor);
						}
					}
				}
			}
		}
		
		public function buildTypeXmlDescriptor(apiClass : FxClass) : XML{
			var xml : XML = <type />;
			xml.@name = getQualifiedClassName(apiClass.type);
			if (apiClass.constructorArguments) {
				for (var i : int = apiClass.constructorArguments.length - 1; i >= 0; i--) {
					xml.appendChild(buildMetadataDescriptor(apiClass.constructorArguments[i] as FxConstructorArgument));
				}
			}
			var globals : Array = apiClass.getGlobalAnnotations();
			for each(var global : IFxMetaProvider in globals){
				xml.appendChild(buildMetadataDescriptor(global));
			}
			xml.appendChild(buildMetadataDescriptor(apiClass));
			for each (var member : FxMember in apiClass.members) {
				xml.appendChild(buildFieldXmlDescriptor(member));
			}
			return xml;
		}
		
		public function buildFieldXmlDescriptor(member : FxMember) : XML{
			var xml : XML = <accessor />;
			xml.@name = member.field.name;
			xml.@type = getQualifiedClassName(member.field.type);
			xml.@access = member.field.accessType.toString();
			xml.appendChild(buildMetadataDescriptor(member));
			return xml;
		}
		
		private function buildMetadataDescriptor(meta : IFxMetaProvider) : XML{
			var xml : XML = <metadata />;
			xml.@name = meta.getMetadataName();
			var values : Dictionary = meta.getMappingValues();
			for(var key : * in values){
				if(values[key] != null){
					xml.appendChild(<arg key={key} value={values[key]} />);
				}
			}
			return xml;
		}
	}
}