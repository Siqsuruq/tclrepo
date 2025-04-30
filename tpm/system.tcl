namespace eval tpm {
    nx::Class create system {
        :variable instance:object

        :public object method create {args} {
            return [expr {[info exists :instance] ? ${:instance} : [set :instance [next]]}]
        }

        :public method get_install_path {} {
            # Use saved pre-libs auto_path
            foreach path $::tpm::original_auto_path {
                if {[file writable $path]} {
                    return $path
                }
            }
            set home [file normalize ~]
            set fallback [file join $home .local lib tpm]
            file mkdir $fallback
            return $fallback
        }

        :public method print_summary {} {
            puts "Tcl executable path : [info nameofexecutable]"
            puts "Tcl library path    : $::tcl_library"
            puts "Package path(s)     :"
            foreach path $::auto_path {
                puts "  $path"
            }

            if {[info exists ::tcl_platform(os)] && [info exists ::tcl_platform(machine)]} {
                puts "Platform            : $::tcl_platform(os) / $::tcl_platform(machine)"
            }

            puts "Writable install path: [:get_install_path]"

            set base [file dirname [file normalize [info script]]]
            puts "Config path         : [file join $base var config]"
        }
    }
}