xquery version "3.0";

 (:
  : Copyright 2006-2009 The FLWOR Foundation.
  :
  : Licensed under the Apache License, Version 2.0 (the "License");
  : you may not use this file except in compliance with the License.
  : You may obtain a copy of the License at
  :
  : http://www.apache.org/licenses/LICENSE-2.0
  :
  : Unless required by applicable law or agreed to in writing, software
  : distributed under the License is distributed on an "AS IS" BASIS,
  : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  : See the License for the specific language governing permissions and
  : limitations under the License.
  :)

 (:~
  :
  : <p>In order to enable JSON processing with XQuery, Zorba implements a set
  : of functions that open XQuery developers the door to process JSON
  : data. Specifically, this module provides two types of functions. Functions
  : to:
  : <ul>
  :   <li>parse JSON and convert it to XDM and</li>
  :   <li>serialize XDM in order to output JSON.</li>
  : </ul>
  : </p>
  :
  : <p>Both types of functions are available to parse and serialize two
  : types of XDM-JSON mappings:<ul><li>the first mapping called in this document 
  : <strong>simple XDM-JSON</strong> has been
  : <a href="http://snelson.org.uk/archives/2008/02/parsing_json_in.php#more">
  : proposed by John Snelson</a></li><li>the second mapping is called 
  : <a href="http://jsonml.org/">JsonML</a></li></ul>In the following, we
  : briefly describe both mappings.</p>
  : 
  : <h2>Simple XDM-JSON Mapping</h2>
  : <ul><li>In order to process JSON with XQuery, Zorba implements a mapping between
  : JSON and XML that was initially proposed by John Snelson in his article
  : <a href="http://snelson.org.uk/archives/2008/02/parsing_json_in.php#more"
  : target="_blank">Parsing JSON into XQuery</a></li></ul>
  :
  : <h2>JsonML Mapping</h2>
  : <ul>
  : <li><a href="http://jsonml.org" target="_blank">JSonML</a> (JSON Markup Language)
  : is an application of the JSON format.</li>
  : <li>The purpose of JSonML is to provide a compact format for transporting
  : XML-based markup as JSon. In contrast to the <strong>simple XDM-JSON</strong> mapping described above
  : <strong>JsonML</strong> allows a lossless conversion back and forth.</li></ul>
  :
  : <h2>Important Notes:</h2>
  : <ul><li>Zorba uses <a xmlns:xqdoc="http://www.xqdoc.org/1.0" href="http://www.digip.org/jansson/">Jansson library</a>
  : for manipulating JSON data that implements the <a href="http://tools.ietf.org/html/rfc4627.html"><strong>RFC 4627</strong></a>.
  : <a xmlns:xqdoc="http://www.xqdoc.org/1.0" href="http://www.digip.org/jansson/">Jansson library</a> guarantees that the items are <strong>UNIQUE</strong>, it <strong>DOES NOT</strong> guarantee that they 
  : are returned in the same exact order. However, this is an approved behaviour because returning the items in the same exact order if not specified in the to the 
  : <a href="http://tools.ietf.org/html/rfc4627#section-4"><strong>RFC 4627 section 4.</strong></a></li>
  : <li>Also, please make sure that the JSON strings you want to pass to Zorba are valid. According to the 
  : <a href="http://tools.ietf.org/html/rfc4627.html"><strong>RFC 4627</strong></a> a valid JSON string begins with either an 
  : <a href="http://www.json.org/array.gif">array</a> or an <a href="http://www.json.org/object.gif">object</a>.
  : You can use for instance <a href="http://www.jsonlint.com/">JSONLint JSON Validator</a> to make sure the JSON is valid.</li>
  : <li>We have tested against the following Jansson library versions:
  : <ul><li><a href="http://www.digip.org/jansson/doc/1.2/">Jansson 1.2.1</a></li>
  :     <li><a href="http://www.digip.org/jansson/doc/1.3/">Jansson 1.3</a></li>
  :     <li><a href="http://www.digip.org/jansson/doc/2.0/">Jansson 2.0</a></li></ul> available from 
  : <a href="http://www.digip.org/jansson/releases/">Jansson releases</a>.</li></ul>
  :
  : @author Sorin Nasoi
  : @library <a href="http://www.digip.org/jansson/">Jansson library for encoding, decoding and manipulating JSON data</a>
  :
  : @see <a href="http://snelson.org.uk/archives/2008/02/parsing_json_in.php#more">Mapping proposed by John Snelson</a>
  : @see <a href="http://jsonml.org" target="_blank">JSonML</a>
  : @see <a href="http://www.digip.org/jansson/doc/2.0/">Jansson library for encoding, decoding and manipulating JSON data</a>
  : @project data processing/data converters
  :
  :)
module namespace json = "http://www.zorba-xquery.com/modules/converters/json";

(:~
 : Import module for checking if json options element is validated.
 :)
import module namespace zorba-schema = "http://www.zorba-xquery.com/modules/schema";

(:~
 : Contains the definitions of the json options element.
 :)
import schema namespace json-options = "http://www.zorba-xquery.com/modules/converters/json-options";

declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : Errors namespace URI.
:)
declare variable $json:jsonNS as xs:string := "http://www.zorba-xquery.com/modules/converters/json";

(:~
 : Error code for wrong parameter situations.<br/>
 : Possible error messages:<br/>
 : * "Options field must be of element options instead of ..."<br/>
:)
declare variable $json:errWrongParam as xs:QName := fn:QName($json:jsonNS, "json:errWrongParam");

(:~
 : This function parses a JSON string and returns an XDM instance according
 : to either one of the mappings described above.
 :
 : @param $arg a sequence of valid JSON strings.
 : @param $options a set of name and value pairs that provide options
 :        to configure the JSON mapping process that have to be validated against the 
 :        "http://www.zorba-xquery.com/modules/converters/json-options" schema.
 : @return  a sequence of nodes according to either one of the mappings described above.
 : @error $json:errWrongParam if any of the strings passed as parameter is not valid JSON.
 : @example test_json/Queries/converters/jansson/parse_json_02.xq
 : @example test_json/Queries/converters/jansson/parse_json_ml_01.xq
 :)
declare function json:parse(
  $arg as xs:string?,
  $options as element(json-options:options)?
) as document-node(element(*, xs:untyped))
{
  try {
    let $validated-options := if(empty($options)) then
                                $options
                              else
                                if(zorba-schema:is-validated($options)) then
                                  $options
                                else
                                  validate{$options} 
    return
      json:parse-internal($arg, $validated-options)
  } catch * ($ecode, $desc)
  {
    fn:error($json:errWrongParam, $desc)
  }
};

(:~
 : This function parses a JSON string and returns an XDM instance according
 : to simple XDM-JSON mapping described above.
 :
 : This function is the equivalent of calling
 :<pre class="brush: xquery;"> 
 :  json:parse($arg,
 :  <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
 :    <jsonParam name="mapping" value="simple-json" />
 :  </options>)</pre>
 :
 : @param $arg a sequence of valid JSON strings.
 : @return  a sequence of nodes according to Simple XDM-JSON mapping described above.
 : @error $json:errWrongParam if any of the strings passed as parameter is not valid JSON.
 : @example test_json/Queries/converters/jansson/parse_json_11.xq
 :)
declare function json:parse(
  $arg as xs:string?
) as document-node(element(*, xs:untyped))
{
  json:parse-internal($arg,
                      <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
                        <jsonParam name="mapping" value="simple-json" />
                      </options>)
};

(:~
 : This function parses a JSON string and returns an XDM instance according
 : to JsonML mapping described above.
 :
 : This function is the equivalent of calling
 : <pre class="brush: xquery;">
 :  json:parse($arg,
 :  <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
 :    <jsonParam name="mapping" value="json-ml" />
 :  </options>)
 : </pre>
 :
 : @param $arg a sequence of valid JSON strings.
 : @return  a sequence of nodes according the JSON-ML mapping described above.
 : @error $json:errWrongParam if any of the strings passed as parameter is not valid JSON.
 : @example test_json/Queries/converters/jansson/parse_json_ml_05.xq
 :)
declare function json:parse-ml(
  $arg as xs:string?
) as document-node(element(*, xs:untyped))
{
  json:parse-internal($arg,
                      <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
                        <jsonParam name="mapping" value="json-ml" />
                      </options>)
};

declare %private function json:parse-internal(
  $html as xs:string,
  $options as element(json-options:options)?
  ) as document-node(element(*, xs:untyped)) external;


(:~
 : The serialize function takes a sequence of nodes as parameter and
 : transforms each element into a valid JSON string according to one of the
 : mappings described above.
 :
 : @param $xml a sequence of nodes.
 : @param $options a set of name and value pairs that provide options
 :        to configure the JSON mapping process that have to be validated against the 
 :        "http://www.zorba-xquery.com/modules/converters/json-options" schema.
 : @return a JSON string.
 : @error $json:errWrongParam if the passed elements do not have a valid JSON structure.
 : @example test_json/Queries/converters/jansson/serialize_json_01.xq
 : @example test_json/Queries/converters/jansson/serialize_json_ml_01.xq
 :)
declare function json:serialize(
  $xml as item()*, 
  $options as element(json-options:options)? 
) as xs:string
{
  try {
    let $validated-options := if(empty($options)) then
                                $options
                              else
                                if(zorba-schema:is-validated($options)) then
                                  $options
                                else
                                  validate{$options} 
    return
      json:serialize-internal($xml, $validated-options)
  } catch * ($ecode, $desc)
  {
    fn:error($json:errWrongParam, $desc)
  }
};

(:~
 : The serialize function takes a sequence of nodes as parameter and
 : transforms each element into a valid JSON string according to the
 : Simple XDM-JSON mapping described above
 :
 : This function is the equivalent of calling 
 :<pre class="brush: xquery;">
 :  json:serialize($xml,
 :  <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
 :    <jsonParam name="mapping" value="simple-json" />
 :  </options>)</pre>
 :
 : @param $xml a sequence of nodes.
 : @return a JSON string.
 : @error json:errWrongParam if the passed elements do not have a valid JSON structure.
 : @example test_json/Queries/converters/jansson/serialize_json_18.xq
 :)
declare function json:serialize(
  $xml as item()* 
) as xs:string
{
  json:serialize-internal($xml,
                          <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
                            <jsonParam name="mapping" value="simple-json" />
                          </options>)
};

(:~
 : The serialize function takes a sequence of nodes as parameter and
 : transforms each element into a valid JSON string according to the
 : JsonML mapping described above.
 :
 : This function is the equivalent of calling 
 :<pre class="brush: xquery;">
 :  json:serialize($xml,<options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
 :    <jsonParam name="mapping" value="json-ml" />
 :  </options>)</pre>
 :
 : @param $xml a sequence of nodes.
 : @return a JSON string.
 : @error $json:errWrongParam if the passed elements do not have a valid JSON structure.
 : @example test_json/Queries/converters/jansson/serialize_json_ml_04.xq
 :)
declare function json:serialize-ml(
  $xml as item()* 
) as xs:string
{
  json:serialize-internal($xml,
                          <options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
                            <jsonParam name="mapping" value="json-ml" />
                          </options>)
};

declare %private function json:serialize-internal(
  $xml as item()*,
  $options as element(json-options:options)?
  ) as xs:string external;
