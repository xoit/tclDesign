#!/usr/bin/tclsh

# define die and core

set die_w       600 ;
set die_h       620 ;

set core_top    50 ;
set core_right  50 ;
set core_bottom 50 ;
set core_left   50 ;


# -----------------------------------------------
# SVG DRAWER
# -----------------------------------------------
set origin_x 0 ;
set origin_y 0 ;

set canva_x0 50 ;
set canva_y0 750 ;

proc corchgx {x} {
  global canva_x0 ;
  global canva_y0 ;
  return [expr $canva_x0 + $x]
}
proc corchgy {y} {
  global canva_x0 ;
  global canva_y0 ;
  return [expr $canva_y0 - $y]
}
set svg floorplan.svg
set fh [open $svg w] ;
set canva_w [expr $die_w + 150 ] ;
set canva_h [expr $die_h + 150 ] ;
puts $fh [subst {<svg id="floorplan" width="$canva_w" height="$canva_h" xmlns="http://www.w3.org/2000/svg">}] ;
puts $fh [subst {<marker id="markerArrow" viewBox="0 0 10 10" }]
puts $fh [subst {                refX="1" refY="5"}]
puts $fh [subst {                markerWidth="6" }]
puts $fh [subst {                markerHeight="6"}]
puts $fh [subst {                orient="auto">}]
puts $fh [subst {    <path d="M2,2 L2,11 L10,6 L2,2" style="fill: #000000;" />}]
puts $fh [subst {</marker>}]

# draw die to core
puts $fh [subst {<line id="arrow_left" x1="[corchgx 0]" y1="[expr [corchgy $die_h]+$core_top+55]" x2="[expr [corchgx 0]+$core_left - 5]" y2="[expr [corchgy $die_h]+$core_top+55]"  stroke="red" stroke-width="1" marker-end="url(#markerArrow)" />}]
puts $fh [subst {<text id="text_left" x="[expr [corchgx 0]+0.3 * $core_left]" y="[expr [corchgy $die_h]+$core_top+52]" fill="red">$core_left</text>}]

puts $fh [subst {<line id="arrow_right"  x1="[expr [corchgx 0]+$die_w]" y1="[expr [corchgy $die_h]+$core_top+55]" x2="[expr int([corchgx 0]+$die_w - $core_right)+5+2]" y2="[expr [corchgy $die_h]+$core_top+55]"  stroke="red" stroke-width="1" marker-end="url(#markerArrow)" />}]
puts $fh [subst {<text id="text_right" x="[expr int([corchgx 0]+$die_w - 0.6* $core_right)]" y="[expr [corchgy $die_h]+$core_top+52]" fill="red">$core_right</text>}]


puts $fh [subst {<line id="arrow_top"  x1="[expr [corchgx 0]+$core_left+20]" y1="[corchgy $die_h]" x2="[expr [corchgx 0]+$core_left+20]" y2="[expr [corchgy $die_h]+$core_top-5]"  stroke="red" stroke-width="1" marker-end="url(#markerArrow)" />}]
puts $fh [subst {<text id="text_top" x="[expr int([corchgx 0]+$core_left+20+3)]" y="[expr int([corchgy $die_h]+0.6*$core_top)]" fill="red">$core_top</text>}]

puts $fh [subst {<line id="arrow_bottom"  x1="[expr [corchgx $die_w]-$core_right-20]" y1="[corchgy 0]" x2="[expr [corchgx $die_w]-$core_right-20]" y2="[expr [corchgy 0]-$core_bottom+5+2]"  stroke="red" stroke-width="1" marker-end="url(#markerArrow)" />}]
puts $fh [subst {<text id="text_bottom" x="[expr int([corchgx $die_w]-$core_right-20+3)]" y="[expr int([corchgy 0]-0.6*$core_bottom)]" fill="red">$core_bottom</text>}]

# Hard macro
set ip1_w 140 ;
set ip1_h 220 ;
set pg_start [expr 0+$core_left+1];
set pg_end [expr $pg_start + $ip1_w] ;
set pg_pitch 20 ;

for {set i 0} {$i<[expr int(abs($pg_end - $pg_start)/$pg_pitch) + 1]} {incr i} {
  if {[expr $i%2]} {
    puts $fh [subst {<line x1="[expr [corchgx $pg_start]+$pg_pitch*$i]" y1="[corchgy [expr 1+$core_bottom+1+$ip1_h]]" x2="[expr [corchgx $pg_start]+$pg_pitch*$i]" y2="[corchgy [expr 0+$core_bottom]]" style="stroke:white;stroke-width:6;stroke-dasharray='2 2'"><set attributeName="stroke" to="red" begin="showpower_v.click"/><set attributeName="stroke" to="white" begin="hidepower.click"/></line>}]
  } else {
    puts $fh [subst {<line x1="[expr [corchgx $pg_start]+$pg_pitch*$i]" y1="[corchgy [expr 1+$core_bottom+1+$ip1_h]]" x2="[expr [corchgx $pg_start]+$pg_pitch*$i]" y2="[corchgy [expr 0+$core_bottom]]" style="stroke:white;stroke-width:6;stroke-dasharray='2 2'"><set attributeName="stroke" to="grey" begin="showpower_v.click"/><set attributeName="stroke" to="white" begin="hidepower.click"/></line>}]
  }
}

set ip2_w 120 ;
set ip2_h 180 ;

set pg_start [expr $core_left+10] ;
set pg_end [expr $die_w - $core_right-10] ;
set pg_pitch 60 ;

for {set i 0} {$i<[expr int(abs($pg_end - $pg_start)/$pg_pitch)]} {incr i} {
  if {[expr $i%2]} {
    puts $fh [subst {<line x1="[expr [corchgx $pg_start]+$pg_pitch*$i]" y1="[expr [corchgy $core_bottom]]" x2="[expr [corchgx $pg_start]+$pg_pitch*$i]" y2="[corchgy [expr $die_h - $core_top]]" style="stroke:white;stroke-width:6;stroke-dasharray='2 2'"><set attributeName="stroke" to="red" begin="showpower_v.click"/><set attributeName="stroke" to="white" begin="hidepower.click"/></line>}]
  } else {
    puts $fh [subst {<line x1="[expr [corchgx $pg_start]+20+$pg_pitch*$i]" y1="[expr [corchgy $core_bottom]]" x2="[expr [corchgx $pg_start]+20+$pg_pitch*$i]" y2="[corchgy [expr $die_h - $core_top]]" style="stroke:white;stroke-width:6;stroke-dasharray='2 2'"><set attributeName="stroke" to="grey" begin="showpower_v.click"/><set attributeName="stroke" to="white" begin="hidepower.click"/></line>}]
  }
}
set pg_start [expr $core_bottom] ;
set pg_end [expr $die_h - $core_top] ;
set pg_pitch    30 ;

for {set i 0} {$i<[expr int(abs($pg_end - $pg_start)/$pg_pitch)]} {incr i} {
  puts $fh [subst {<line x1="[expr [corchgx $core_left]+1]" y1="[expr [corchgy $pg_start]-$pg_pitch*$i]" x2="[expr [corchgx [expr $die_w - $core_right]]-1]" y2="[expr [corchgy $pg_start]-$pg_pitch*$i]" style="stroke:rgb(0,255,0);stroke-width:2;"></line>}]
  if {[expr $i%2]} {
    puts $fh [subst {<line x1="[expr [corchgx $core_left]+1]" y1="[expr [corchgy $pg_start]-$pg_pitch*$i]" x2="[expr [corchgx [expr $die_w - $core_right]]-1]" y2="[expr [corchgy $pg_start]-$pg_pitch*$i]" style="stroke:white;stroke-width:6;stroke-dasharray='2 2'"><set attributeName="stroke" to="red" begin="showpower.click"/><set attributeName="stroke" to="white" begin="hidepower.click"/></line>}]
  } else {
    puts $fh [subst {<line x1="[expr [corchgx $core_left]+1]" y1="[expr [corchgy $pg_start]-$pg_pitch*$i]" x2="[expr [corchgx [expr $die_w - $core_right]]-1]" y2="[expr [corchgy $pg_start]-$pg_pitch*$i]" style="stroke:white;stroke-width:6;stroke-dasharray='2 2'"><set attributeName="stroke" to="grey" begin="showpower.click"/><set attributeName="stroke" to="white" begin="hidepower.click"/></line>}]
  }
}

puts $fh [subst {<rect id="ip1" x="[corchgx [expr 0+$core_left+1]]" y="[corchgy [expr 0+$core_bottom+1+$ip1_h]]" width="$ip1_w" height="$ip1_h" style="fill:none;stroke-width:1;stroke:rgb(0,0,0);"><set attributeName="fill" to="blue" begin="hidepower.click" end="showpower.click"/></rect>}]
puts $fh [subst {<rect id="ip1" x="[corchgx [expr 0+$core_left+1+$ip1_w+20]]" y="[corchgy [expr 0+$core_bottom+1+$ip2_h]]" width="$ip2_w" height="$ip2_h" style="fill:none;stroke-width:1;stroke:rgb(0,0,0);"><set attributeName="fill" to="blue" begin="hidepower.click" end="showpower.click"/></rect>}]


# draw die
puts $fh [subst {<rect id="die" x="[corchgx 0]" y="[corchgy $die_h]" width="$die_w" height="$die_h" style="fill:none;stroke-width:1;stroke:rgb(0,0,0);" />}]
puts $fh [subst {<text id="origin" x="[expr [corchgx 0]-15]" y="[expr [corchgy 0]+15]">(0,0)</text>}]
# draw core
puts $fh [subst {<rect id="core" x="[corchgx [expr 0 + $core_left]]" y="[expr [corchgy $die_h]+$core_top]" width="[expr $die_w - $core_left - $core_right]" height="[expr $die_h - $core_top - $core_bottom]" style="fill:none;stroke-width:1;stroke:rgb(0,0,0);" />}]

puts $fh [subst {<rect id="showpower" x="20" y="20" width="25" height="25" rx="5" ry="5" style="fill:lightgrey"/><text x="48" y="36" >show pg strap</text>}] ;
puts $fh [subst {<rect id="hidepower" x="20" y="50" width="25" height="25" rx="5" ry="5" style="fill:lightgrey"/><text x="48" y="66" >hide pg strap</text>}] ;
puts $fh [subst {<rect id="showpower_v" x="220" y="20" width="25" height="25" rx="5" ry="5" style="fill:lightgrey"/><text x="248" y="36" >show vertical pg strap</text>}] ;

# pins
set pin_w 10 ;
set pin_h 25 ;

set pin_x [expr 10]
for {set i 0} {$i<10} {incr i} {
  puts $fh [subst {<rect x="[corchgx [expr $pin_x+$i*($pin_w+10)]]" y="[corchgy $pin_h]" width="$pin_w" height="$pin_h" style="fill:yellow;" />}]
}

puts $fh [subst {</svg>}]

close $fh ;
