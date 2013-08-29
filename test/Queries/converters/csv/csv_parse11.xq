import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";

csv:parse(
'f1, f2, f3, f4, f10, f11
f5, f6, "f7", "f8
""f9",f8', 
validate{
<csv-options:options>
  <first-row-is-header accept-all-lines="true"/>
  <csv separator=","
       quote-char="&quot;"
       quote-escape="&quot;&quot;"/>
</csv-options:options>}
)

