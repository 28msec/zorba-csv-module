(:Serialize a sequence of constructed nodes in csv lines, without header:)
import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
declare namespace data="http://zorba.io/data";
declare variable $input-xml external;

csv:serialize(
for $person in $input-xml/data:root/data:person
return <row>{$person/data:name}
            {$person/data:address}
            {$person/data:address2}
        </row>, 
validate{
<csv-options:options>
  <first-row-is-header ignore-foreign-input="true"/>
  <csv separator=","
       quote-char="&quot;"
       quote-escape="&quot;&quot;"/>
</csv-options:options>})
