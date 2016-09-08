set wa [file dirname [info script]] ;

lappend auto_path $wa
lappend auto_path $wa/lib/mdb
lappend auto_path $wa/lib/scmd
lappend auto_path $wa/lib/ccmd

package require mdb
package require scmd
package require ccmd

package require tclDesign

