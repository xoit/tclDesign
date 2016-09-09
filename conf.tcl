set wa [file dirname [info script]] ;

lappend auto_path $wa
lappend auto_path $wa/lib/mdb
lappend auto_path $wa/lib/scmd
lappend auto_path $wa/lib/ccmd


foreach itm_package [list mdb scmd ccmd tclDesign] {
  package forget $itm_package ;
  package require $itm_package ;
}

