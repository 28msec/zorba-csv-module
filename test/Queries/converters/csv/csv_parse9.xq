import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
import module namespace file="http://expath.org/ns/file";

csv:parse(
        file:read-text(fn:resolve-uri("budauth.csv")),
validate{
<csv-options:options>
  <first-row-is-header/>
  <csv separator=","
       quote-char="&quot;"
       quote-escape="&quot;&quot;"/>
  <xml-nodes>
    <test7:row xmlns:test7="http://zorba.io/modules/csv">
    </test7:row>
  </xml-nodes>
</csv-options:options>}
)
