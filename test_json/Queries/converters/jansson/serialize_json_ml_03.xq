import module namespace json = "http://www.zorba-xquery.com/modules/converters/json";
import schema namespace html-options="http://www.zorba-xquery.com/modules/converters/json-options";

declare variable $tmp :=<!--comment-->;

json:serialize($tmp,<options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
              <json-param name="mapping" value="json-ml" type="array"/>
            </options>)