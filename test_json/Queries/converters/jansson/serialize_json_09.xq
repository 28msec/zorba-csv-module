(: valid json generation: array in an array :)

import module namespace json = "http://www.zorba-xquery.com/modules/converters/json";
import schema namespace html-options="http://www.zorba-xquery.com/modules/converters/json-options";

json:serialize((<json type="object">
    <pair name="servlet" type="array">
  <item type="array">
          <item type="string">value1</item>
  </item>
        <item type="string">value2</item>
    </pair>
  </json>),<options xmlns="http://www.zorba-xquery.com/modules/converters/json-options" >
              <json-param name="mapping" value="simple-json" />
            </options>)
