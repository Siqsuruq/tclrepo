namespace eval tpm {
    nx::Class create system -mixin Helper {
        :variable instance:object

        :public object method create {args} {
            return [expr {[info exists :instance] ? ${:instance} : [set :instance [next]]}]
        }

        :public method get_install_path {} {
            # Use saved pre-libs auto_path
            foreach path $::tpm::libsdirs {
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
            :cputs_multi [list green "Tcl Version: " blue "$::tcl_version"]
            :cputs_multi [list green "Tcl executable path: " blue "[info nameofexecutable]"]
            :cputs_multi [list green "Tcl library path: " blue "$::tcl_library"]
            :cputs_multi [list green "Tcl executable path: " blue "[info nameofexecutable]"]

            :cputs green "Package path(s):"
            foreach path $::auto_path {
                :cputs blue "    $path"
            }

            :cputs_multi [list green "Tcl Platform: " blue "[platform::generic]"]
            :cputs_multi [list green "Writable install path: " blue "[:get_install_path]"]

            set base [file dirname [file normalize [info script]]]
            :cputs_multi [list green "Config path: " blue "[file join $base var config]"]
        }

        :public method get_tcl_version_major {args} {
            set major [lindex [split $::tcl_version "."] 0]
            return $major
        }

        :public method get_tcl_version_minor {args} {
            set minor [lindex [split $::tcl_version "."] 1]
            return $minor
        }
    }
}