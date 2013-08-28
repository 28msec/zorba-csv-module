import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
import module namespace file="http://expath.org/ns/file";

let $options :=
validate{
<csv-options:options>
  <column-widths>
    <column-width>20</column-width>
    <column-width>45</column-width>
    <column-width>35</column-width>
    <column-width>17</column-width>
    <column-width>19</column-width>
    <column-width>4</column-width>
    <column-width>2</column-width>
    <column-width>17</column-width>
  </column-widths>
</csv-options:options>   }
return
let $result := 
csv:serialize(
csv:parse(file:read-text(fn:resolve-uri("PUAOSL95.TXT")), $options),
                $options)
return 
  $result
