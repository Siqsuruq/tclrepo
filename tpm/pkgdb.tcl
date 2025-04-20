namespace eval tpm {
    nx::Class create pkgdb {
        :property {installed_pkgs ""}
        :property {available_pkgs ""}

        :method init {} {
            :refresh
        }

        :public method refresh_remote {} {
            set net [::tpm::net new]
            try {
                set pkgs [$net fetch_package_index]
                set :available_pkgs $pkgs
            } finally {
                $net destroy
            }
        }

        :public method find_remote_package {name} {
            foreach pkg ${:available_pkgs} {
                if {[dict get $pkg package_name] eq $name} {
                    return $pkg
                }
            }
            return ""
        }

        :public method refresh {} {
            set :installed_pkgs {} ;# reset

            foreach path $::auto_path {
                if {![file isdirectory $path]} continue

                set pkgs [glob -nocomplain -type f -directory $path */pkgIndex.tcl]
                foreach indexfile $pkgs {
                    set f [open $indexfile r]
                    while {[gets $f line] >= 0} {
                        set pkg ""
                        set ver ""
                        if {[regexp {package ifneeded ([^\s]+) ([^\s]+)} $line -> pkg ver]} {
                            dict set :installed_pkgs $pkg $ver
                        }
                    }
                    close $f
                }
            }
        }

        :public method list_installed {} {
            if {[dict size ${:installed_pkgs}] == 0} {
                puts " (none found)"
            } else {
                foreach {pkg ver} ${:installed_pkgs} {
                    puts " - $pkg $ver"
                }
            }
        }

        :public method is_installed {pkg} {
            return [dict exists ${:installed_pkgs} $pkg]
        }

        :public method get_version {pkg} {
            if {[dict exists ${:installed_pkgs} $pkg]} {
                return [dict get ${:installed_pkgs} $pkg]
            }
            return ""
        }
    }
}