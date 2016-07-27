#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sets the value of an existing XML element or attribute.
#!
#! @input xml_document: XML string in which to set an element or attribute value
#! @input xpath_element_query: XPATH query that results in an element or element
#!                             list to set the value of or an element or element
#!                             list containing the attribute to set the value of
#! @input attribute_name: name of attribute to set the value of if setting an
#!                        attribute value; leave empty if setting the value of
#!                        an element
#!                        optional
#! @input value: value to set for element or attribute
#! @input secure_processing: whether to use secure processing
#!                           optional
#!                           default: false
#! @output result_xml: given XML with value set
#! @output return_result: exception in case of failure, success message otherwise
#! @output result_text: 'success' or 'failure'
#! @result SUCCESS: value was set
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: set_value

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        required: false
        private: true
    - xpath_element_query
    - xPathElementQuery:
        default: ${get("xpath_element_query", "")}
        required: false
        private: true
    - attribute_name:
        required: false
    - attributeName:
        default: ${get("attribute_name", "")}
        required: false
        private: true
    - value
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "false")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.5'
    class_name: io.cloudslang.content.xml.actions.SetValue
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - result_text: ${result}

  results:
    - SUCCESS: ${result == 'success'}
    - FAILURE
