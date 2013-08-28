(: csv-to-xml example with utf8 characters :)

import module namespace csv = "http://zorba.io/modules/csv";

csv:parse("ü,ö,ä, ă,î,ș,ț,â", ())
