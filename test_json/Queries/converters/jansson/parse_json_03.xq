(: try parsing a Unicode UTF-8 value :)

import module namespace json = "http://www.zorba-xquery.com/modules/converters/json";
import schema namespace html-options="http://www.zorba-xquery.com/modules/converters/json-options";

json:parse(('{"mdash": "–"}'),<options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
              <json-param name="mapping" value="simple-json" />
            </options>)