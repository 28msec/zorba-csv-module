(: csv-to-xml example with 1 row :)

import module namespace csv = "http://zorba.io/modules/csv";

csv:parse("f1, f2, f3, f4", ())
