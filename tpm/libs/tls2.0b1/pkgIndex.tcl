# -*- tcl -*-
# Tcl package index file, version 1.1
#
if {[package vsatisfies [package provide Tcl] 9.0-]} {
    package ifneeded tls 2.0b1 [list apply {{dir} {
	# Load library
	load [file join $dir tcl9tls20b1.dll] [string totitle tls]

	# Source init file
	set initScript [file join $dir tls.tcl]
	if {[file exists $initScript]} {
	    source -encoding utf-8 $initScript
	}
    }} $dir]
} else {
    if {![package vsatisfies [package provide Tcl] 8.5]} {return}
    package ifneeded tls 2.0b1 [list apply {{dir} {
	# Load library
	if {[string tolower [file extension tls20b1t.dll]] in [list .dll .dylib .so]} {
	    # Load dynamic library
	    load [file join $dir tls20b1t.dll] [string totitle tls]
	} else {
	    # Static library
	    load {} [string totitle tls]
	}

	# Source init file
	set initScript [file join $dir tls.tcl]
	if {[file exists $initScript]} {
	    source -encoding utf-8 $initScript
	}
    }} $dir]
}
