source conf.tcl ;

load_design ;

set top_bbox [get_attribute [current_design] bbox] ;

puts $top_bbox ;
