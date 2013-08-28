import schema namespace csv-options="http://zorba.io/modules/csv-options";
import module namespace csv = "http://zorba.io/modules/csv";
import module namespace file="http://expath.org/ns/file";

csv:parse(file:read-text(fn:resolve-uri("NAWQA.swmaster.CROSSTAB_COUNT.1260179451247.csv")),
                    validate{
                    <csv-options:options>
                      <first-row-is-header/>
                      <csv separator=","
                           quote-char=""
                           quote-escape=""/>
                      <xml-nodes>
                        <row>
                          <column/>
                        </row>
                      </xml-nodes>
                    </csv-options:options>}                    
                    )
