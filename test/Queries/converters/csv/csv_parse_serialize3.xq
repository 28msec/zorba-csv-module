import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
import module namespace file="http://expath.org/ns/file";


let $options :=
<csv-options:options>
  <first-row-is-header accept-all-lines="true"/>
  <csv separator="&#009;"
       quote-char=""
       quote-escape=""/>
  <xml-nodes>
    <row>
      <column/>
    </row>
  </xml-nodes>
</csv-options:options>
return
csv:serialize(csv:parse(file:read-text(fn:resolve-uri("tri_2008_NH_v08.txt")), $options),
                    $options)
