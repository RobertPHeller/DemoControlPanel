##-*- makefile -*-############################################################
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Mon Jun 5 14:35:31 2023
#  Last Modified : <230605.1447>
#
#  Description	
#
#  Notes
#
#  History
#	
#  $Log$
#
##############################################################################
#
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
#
# 
#
##############################################################################


all: DemoControlPanelLabel

SDX = /usr/local/bin/sdx
TCLKIT = /usr/local/bin/tclkit
RUNTIME = /usr/local/share/tclkits/tclkit-8.6.11-x86_64-Img1.4.7
SNITLIB = /usr/share/tcltk/tcllib1.20/snit
SUPPORT = ParseXML.tcl

DemoControlPanelLabel: DemoControlPanelLabel.tcl $(SUPPORT) \
			Tclxml3.1-GenericPureTcl.zip
	rm -rf DemoControlPanelLabel.kit DemoControlPanelLabel.vfs
	$(TCLKIT) $(SDX) qwrap DemoControlPanelLabel.tcl
	$(TCLKIT) $(SDX) unwrap DemoControlPanelLabel.kit
	rm -rf DemoControlPanelLabel.kit
	unzip -qq Tclxml3.1-GenericPureTcl.zip -d DemoControlPanelLabel.vfs/lib/
	ln -s /usr/share/tcltk/tcllib1.20/snit DemoControlPanelLabel.vfs/lib/
	ln -s /usr/share/tcltk/tcllib1.20/uri DemoControlPanelLabel.vfs/lib/
	mkdir DemoControlPanelLabel.vfs/lib/support
	cp $(SUPPORT) DemoControlPanelLabel.vfs/lib/support/
	echo 'pkg_mkIndex DemoControlPanelLabel.vfs/lib/support/ *.tcl'|$(TCLKIT)
	$(TCLKIT) $(SDX) wrap DemoControlPanelLabel -runtime $(RUNTIME)
	rm -rf DemoControlPanelLabel.kit DemoControlPanelLabel.vfs

