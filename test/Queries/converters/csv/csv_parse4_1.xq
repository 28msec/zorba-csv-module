import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
import module namespace file="http://expath.org/ns/file";

csv:parse(file:read-text(fn:resolve-uri("ME_1_2008_v08.txt")),

validate{
<csv-options:options>
  <first-row-is-header accept-all-lines="true"/>
  <add-last-void-columns/>
  <csv separator="&#009;"
       quote-char=""
       quote-escape=""/>
  <xml-nodes>
    <row/>
  </xml-nodes>
</csv-options:options>}
)
