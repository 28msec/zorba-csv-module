import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
import module namespace file="http://expath.org/ns/file";

let $options := validate{
<csv-options:options>
  <first-row-is-header accept-all-lines="true"/>
  <csv separator="&#009;"
       quote-char=""
       quote-escape=""/>
  <xml-nodes>
    <csv:row xmlns:csv="http://zorba.io/modules/csv"/>
  </xml-nodes>
</csv-options:options>}
return 
csv:serialize(
    csv:parse(file:read-text(fn:resolve-uri("ME_1_2008_v08.txt")), $options),
    $options) 
