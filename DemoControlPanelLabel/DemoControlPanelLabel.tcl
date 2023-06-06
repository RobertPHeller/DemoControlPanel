#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Mon Jun 5 14:47:24 2023
#  Last Modified : <230606.1637>
#
#  Description	
#
#  Notes
#
#  History
#	
#*****************************************************************************
## @copyright
#    Copyright (C) 2023  Robert Heller D/B/A Deepwoods Software
#			51 Locke Hill Road
#			Wendell, MA 01379-9728
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
# @file DemoControlPanelLabel.tcl
# @author Robert Heller
# @date Mon Jun 5 14:47:24 2023
# 
#
#*****************************************************************************

package require snit
package require ParseXML

snit::type DemoControlPanelLabel {
    typevariable genindex 0
    ## @privatesection Gensym index.
    typemethod genname {class} {
        ## Generate a unique symbol.
        # @param class Symbol class.
        # @returns a new unique symbol.
        incr genindex
        return [format {%s%05d} [string toupper $class] $genindex]
    }
    typevariable PS_PreAmble {%!PS-Adobe-3.0
%%Title: Demo Control Panel Label
%%Creator: DemoControlPanelLabel
%%BoundingBox: 0 0 612 792
%%Orientation: Portrait
%%Pages: 1
%%EndComments
%%BeginProlog
/mm {25.4 div 72 mul} def
/inch {72 mul} def
/led {gsave translate 1.5 mm 1.5 mm 1.5 mm 0 360 arc fill grestore} def
/button {gsave translate newpath -6 mm -6 mm moveto 6 mm 0 rlineto 0 6 mm 
    rlineto -6 mm 0 rlineto closepath fill grestore} def
/LabelFont {/NewCenturySchlbk-Bold findfont 8 scalefont setfont} def
/LabelAt {gsave translate dup stringwidth pop 2 div neg 0 inch moveto show grestore} def
%%EndProlog
}
    proc _sizeInches {vv} {
        if {[regexp {^([[:digit:].-]*)(.*)$} $vv => v units] > 0} {
            switch $units {
                mm {
                    return [expr {$v / 25.4}]
                }
                in {
                    return $v
                }
                default {
                    error "$::argv0: Unknown units: $units"
                    exit 99
                }
            }
        } else {
            return 0
        }
    }
    typeconstructor {
        global argv
        global argv0
        global argc
        set outputfile [from argv -o "DemoControlPanelLabel.ps"]
        set labelmapfile [from argv -l "DemoControlPanelLabel.map"]
        set partmapfile [from argv -m "DemoControlPanelLabel.pmap"]
        set argc [llength $argv]
        if {$argc > 0} {
            set filename [lindex $argv 0]
        } else {
            set filename ../DemoControlPanel_bb.svg
        }
        set inpath [file dirname $filename]
        if {[catch {open $filename r} panelfp]} {
            error "$::argv0: open $filename: $panelfp"
            exit 99
        }
        set XML {}
        while {[gets $panelfp line] >= 0} {
            append XML "$line\n"
        }
        #puts stderr "*** read [string length $XML] characters"
        close $panelfp
        set bboardSVG [ParseXML create %AUTO% $XML]
        set bboardSVG [$bboardSVG getElementsByTagName svg -depth 1]
        set XOrg [_sizeInches [$bboardSVG attribute x]]
        set YOrg [_sizeInches [$bboardSVG attribute y]]
        set Width [_sizeInches [$bboardSVG attribute width]]
        set Height [_sizeInches [$bboardSVG attribute height]]
        #puts stderr "*** XOrg = $XOrg, YOrg = $YOrg, Width = $Width, Height = $Height"
        set vb [$bboardSVG attribute viewBox]
        set vbw [expr {[lindex $vb 2] - [lindex $vb 0]}]
        set XScale [expr {$Width / double($vbw)}]
        set vbh [expr {[lindex $vb 3] - [lindex $vb 1]}]
        set YScale [expr {$Height / double($vbh)}]
        #puts stderr "*** XScale = $XScale, YScale = $YScale"
        array set partlocations {}
        array set partchildrencount {}
        array set labels {}
        set LED 0
        set BUTTON 0
        foreach part [$bboardSVG children] {
            #puts stderr "*** part: tag is [$part cget -tag], partID is '[$part attribute partID]'"
            set child [lindex [$part children] 0]
            #puts stderr "*** partchild: tag is [$child cget -tag], attrs are [$child cget -attributes]"
            set transform [$child attribute transform]
            if {$transform ne {}} {
                if {[regexp {^translate\(([[:digit:].-]*),([[:digit:].-]*)\)$} \
                     $transform => tx ty] >= 0} {
                    set partlocations([$part attribute partID]) [list $tx $ty]
                    #puts stderr "*** partlocation: $tx $ty"
                }
                set child [lindex [$child children] 0]
                while {[llength [$child children]] == 1 && [$child cget -tag] eq "g"} {
                    if {[$child attribute id] eq "breadboard"} {
                        set child [lindex [$child children] 0]
                    } elseif {[$child attribute transform] ne {}} {
                        set newtransform [$child attribute transform]
                        #puts stderr "*** child: newtransform is $newtransform"
                        set child [lindex [$child children] 0]
                        if {[regexp {^matrix\(([[:digit:].-]*),([[:digit:].-]*),([[:digit:].-]*),([[:digit:].-]*),([[:digit:].-]*),([[:digit:].-]*)\)$} \
                             => a b c d e f] > 0} {
                            set tx [expr {$tx + $e}]
                            set ty [expr {$ty + $f}]
                            set partlocations([$part attribute partID]) [list $tx $ty]
                        }
                    } else {
                        #puts stderr "*** child: attrs are [$child cget -attributes]"
                        set child [lindex [$child children] 0]
                    }
                }
                    
                #puts stderr "*** child: [llength [$child children]] children"
                incr partchildrencount([llength [$child children]])
                #foreach gc [$child children] {
                #    puts stderr "*** gc: tag is [$gc cget -tag], attrs are [$gc cget -attributes]"
                #}
                switch [llength [$child children]] {
                    4 {
                        lappend LEDs [$part attribute partID]
                        incr LED
                        set labels([$part attribute partID]) [format {LED%d} $LED]
                    }
                    20 {
                        lappend Buttons [$part attribute partID]
                        incr BUTTON
                        set labels([$part attribute partID]) [format {S%d} $BUTTON]
                    }
                    2 {lappend Resistors [$part attribute partID]}
                }
            } else {
                set partlocations([$part attribute partID]) [list 0 0]
                set id [$child attribute id]
                if {$id eq "breadboard"} {
                    foreach bbpart [$child children] {
                        #puts stderr "*** bbpart: tag is [$bbpart cget -tag], attrs are [$bbpart cget -attributes]"
                        if {[$bbpart cget -tag] ne "path"} {continue}
                        set BBLocation $partlocations([$part attribute partID])
                        set BBoardPath [$bbpart attribute d]
                    }
                }
            }
        }
        #foreach childcounts [lsort -integer [array names partchildrencount]] {
        #    puts stderr [format {*** %d parts with %d children} \
        #                 $partchildrencount($childcounts) $childcounts]
        #}
        
        #
        if {[catch {open $outputfile w} PS_fp]} {
            error "$::argv0: open $outputfile: $PS_fp"
            exit 99
        }
        puts $PS_fp $PS_PreAmble
        puts $PS_fp {%%Page: 1 1}
        puts $PS_fp {.5 inch .5 inch translate}
        if {[info exists BBoardPath]} {
            puts $PS_fp {gsave newpath}
            set pathremaining $BBoardPath
            while {$pathremaining ne {}} {
                if {[regexp {^M([[:digit:].-]*),([[:digit:].-]*)(.*)$} \
                     $pathremaining => x y remaining] > 0} {
                    puts $PS_fp [format {%f inch %f inch moveto} \
                                 [expr {($x + [lindex $BBLocation 0]) * $XScale}] \
                                 [expr {($y + [lindex $BBLocation 1]) * $YScale}]]
                    set cmd moveto
                    set pathremaining $remaining
                } elseif {[regexp {^L([[:digit:].-]*),([[:digit:].-]*)(.*)$} \
                           $pathremaining => x y remaining] > 0} {
                    puts $PS_fp [format {%f inch %f inch lineto} \
                                 [expr {($x + [lindex $BBLocation 0]) * $XScale}] \
                                 [expr {($y + [lindex $BBLocation 1]) * $YScale}]]
                    set cmd lineto
                    set pathremaining $remaining
                } elseif {[regexp {^,([[:digit:].-]*),([[:digit:].-]*)(.*)$} \
                           $pathremaining => x y remaining] > 0} {
                    puts $PS_fp [format {%f inch %f inch %s} \
                                 [expr {($x + [lindex $BBLocation 0]) * $XScale}] \
                                 [expr {($y + [lindex $BBLocation 1]) * $YScale}] \
                                 $cmd]
                    set pathremaining $remaining
                } elseif {[regexp {^z} $pathremaining] > 0} {
                    puts $PS_fp {closepath 0 setgray 2 setlinewidth stroke grestore}
                    set pathremaining {}
                }
            }
        }
        puts $PS_fp {LabelFont}
        if {![catch {open $labelmapfile r} lmfp]} {
            while {[gets $lmfp line] >= 0} {
                lassign [split $line =] pn lab
                set labels($pn) $lab
            }
            close $lmfp
        }
        foreach l $LEDs {
            #puts stderr "*** l: $l, partlocations($l): $partlocations($l)"
            lassign $partlocations($l) x y
            puts $PS_fp [format {%f inch %f inch led} \
                         [expr {$x * $XScale}] \
                         [expr {$Height - ($y * $YScale)}]]
            puts $PS_fp [format {(%s) %f inch %f inch LabelAt} \
                         $labels($l) [expr {$x * $XScale}] \
                         [expr {$Height - ($y * $YScale) - .125}]]
        }
        foreach b $Buttons {
            #puts stderr "*** b: $b, partlocations($b: $partlocations($b)"
            lassign $partlocations($b) x y
            puts $PS_fp [format {%f inch %f inch button} \
                         [expr {$x * $XScale}] \
                         [expr {$Height - ($y * $YScale)}]]
            puts $PS_fp [format {(%s) %f inch %f inch LabelAt} \
                         $labels($b) [expr {$x * $XScale - .125}] \
                         [expr {$Height - ($y * $YScale) - .375}]]
        }
        puts $PS_fp {showpage}
        puts $PS_fp {%%Trailer}
        puts $PS_fp {%%EOF}
        close $PS_fp
        if {![catch {open $partmapfile w} lmfp]} {
            foreach p [lsort [array names labels]] {
                puts $lmfp [join [list $p $labels($p)] =]
            }
            close $lmfp
        }
        
    }
    proc _matmul {m v} {
        set x [lindex $v 0]
        set y [lindex $v 1]
        set s [lindex $v 2]
        set tx [expr {([lindex [lindex $m 0] 0] * $x) + ([lindex [lindex $m 1] 0] * $y) + ([lindex [lindex $m 2] 0] * $s)}]
        set ty [expr {([lindex [lindex $m 0] 1] * $x) + ([lindex [lindex $m 1] 1] * $y) + ([lindex [lindex $m 2] 1] * $s)}]
        set ts [expr {([lindex [lindex $m 0] 2] * $x) + ([lindex [lindex $m 1] 2] * $y) + ([lindex [lindex $m 2] 2] * $s)}]
        if {$ts != 0.0} {
            set tx [expr {$tx / $ts}]
            set ty [expr {$ty / $ts}]
            set ts 1.0
        }
        return [list $tx $ty $ts]
    }
    
            
}


        

