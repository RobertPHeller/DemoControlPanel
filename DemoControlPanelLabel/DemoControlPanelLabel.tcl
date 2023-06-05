#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Mon Jun 5 14:47:24 2023
#  Last Modified : <230605.1755>
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
%%BoundingBox: 0 0 792 612
%%Orientation: Landscape
%%Pages: 1
%%EndComments
%%BeginProlog
/mm {25.4 div 72 mul} def
/led {gsave translate 1.5 mm 1.5 mm 1.5 mm 0 360 arc fill grestore} def
/button {gsave translate newpath 0 0 moveto 6 mm 0 rlineto 0 6 mm 
    rlineto -6 mm 0 rlineto closepath fill grestore} def
%%EndProlog
}
    typeconstructor {
        global argv
        global argv0
        global argc
        set outputfile [from argv -o "DemoControlPanelLabel.ps"]
        set argc [llength $argv]
        if {$argc > 0} {
            set filename [lindex $argv 0]
        } else {
            set filename DemoControlPanel/DemoControlPanel.fz
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
        set paneltree [ParseXML create %AUTO% $XML]
        set views [$paneltree getElementsByTagName views -depth 2]
        set scale 1.0
        foreach c [$views children] {
            if {[$c attribute name] eq "breadboardView"} {
                set gridSize [$c attribute gridSize]
                if {[regexp {^([[:digit:].-]*)mm$} $gridSize => number] > 0} {
                    set scale [expr {1.0 / $number}]
                }
                break
            }
        }
        set instances [$paneltree getElementsByTagName instances -depth 2]
        #puts stderr "*** llength instances is [llength $instances]"
        set lnames [list]
        set bnames [list]
        foreach instance [$instances children] {
            set idRef [$instance attribute moduleIdRef]
            set title [$instance getElementsByTagName title -depth 1]
            if {[llength $title] > 0} {
                set title [$title data]
            }
            switch $idRef {
                BPS_POW3U {
                    set views [$instance getElementsByTagName views -depth 1]
                    #puts stderr "*** (BPS_POW3U leg): llength of views is [llength $views]"
                    set bbview [$views getElementsByTagName breadboardView -depth 1]
                    #puts stderr "*** (BPS_POW3U leg): llength of bbview is [llength $bbview]"
                    #foreach c [$bbview children] {
                    #    puts stderr "*** (BPS_POW3U leg): ($c) child of bbview: [$c cget -tag]"
                    #}
                    set bbgeo [$bbview getElementsByTagName geometry -depth 1]
                    #foreach c $bbgeo {
                    #    puts stderr "*** (BPS_POW3U leg): ($c) element of bbgeo: [$c cget -tag]"
                    #}
                    #puts stderr "*** (BPS_POW3U leg): llength of bbgeo is [llength $bbgeo]"
                    set BPS_POW3U_x [$bbgeo attribute x]
                    set BPS_POW3U_y [$bbgeo attribute y]
                    #puts stderr "*** (BPS_POW3U leg): BPS_POW3U_x is $BPS_POW3U_x, BPS_POW3U_y is $BPS_POW3U_y"
                    set BPS_POW3U_bboardfile [file join $inpath svg.breadboard.POW3U.svg]
                    if {[catch {open $BPS_POW3U_bboardfile r} fp]} {
                        error "$::argv0: open $BPS_POW3U_bboardfile: $fp"
                        exit 99
                    }
                    set BPS_POW3U_SVG [ParseXML create %AUTO% [read $fp]]
                    #puts stderr "*** (BPS_POW3U leg): llength BPS_POW3U_SVG is [llength $BPS_POW3U_SVG]"
                    close $fp
                    set svg [$BPS_POW3U_SVG getElementsByTagName svg -depth 1]
                    #puts stderr "*** (BPS_POW3U leg): llength svg is [llength $svg]"
                    set BPS_POW3U_SVG_width [$svg attribute width]
                    set BPS_POW3U_SVG_height [$svg attribute height]
                }
                LED3D254P_4781289a84728a1c1014dcad4a419d78_1 {
                    set views [$instance getElementsByTagName views -depth 1]
                    #puts stderr "*** (LED3D254P_ leg): llength of views is [llength $views]"
                    set bbview [$views getElementsByTagName breadboardView -depth 1]
                    set bbgeo [$bbview getElementsByTagName geometry -depth 1]
                    set LEDs($title,x) [$bbgeo attribute x]
                    set LEDs($title,y) [$bbgeo attribute y]
                    lappend lnames $title
                }
                20A9BBEE34_ST {
                    set views [$instance getElementsByTagName views -depth 1]
                    #puts stderr "*** (20A9BBEE34_ST leg): llength of views is [llength $views]"
                    set bbview [$views getElementsByTagName breadboardView -depth 1]
                    set bbgeo [$bbview getElementsByTagName geometry -depth 1]
                    set Buttons($title,x) [$bbgeo attribute x]
                    set Buttons($title,y) [$bbgeo attribute y]
                    lappend bnames $title
                }
                default {
                    #puts [format "%-20s: %s" $title $idRef]
                }
            }
        }
        #
        if {[catch {open $outputfile w} PS_fp]} {
            error "$::argv0: open $outputfile: $PS_fp"
            exit 99
        }
        puts $PS_fp $PS_PreAmble
        puts $PS_fp {%%Page: 1 1}
        puts $PS_fp {newpath 12.5 mm 12.5 mm moveto}
        puts $PS_fp "[regsub {mm$} $BPS_POW3U_SVG_width {}] mm 0 rlineto"
        puts $PS_fp "0 [regsub {mm$} $BPS_POW3U_SVG_height {}] mm rlineto"
        puts $PS_fp "-[regsub {mm$} $BPS_POW3U_SVG_width {}] mm 0 rlineto"
        puts $PS_fp {closepath 2 setlinewidth 0 setgray stroke}
        foreach l $lnames {
            set xx [expr {($LEDs($l,x) - $BPS_POW3U_x) * $scale}]
            set yy [expr {($LEDs($l,y) - $BPS_POW3U_y) * $scale}]
            puts $PS_fp [format {%f mm %f mm led} $xx $yy]
        }
        puts $PS_fp {showpage}
        puts $PS_fp {%%Trailer}
        puts $PS_fp {%%EOF}
        close $PS_fp
    }
}


        
