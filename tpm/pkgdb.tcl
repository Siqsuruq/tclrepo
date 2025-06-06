namespace eval tpm {
    nx::Class create pkgdb -mixin Helper {
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
            set base_dir [file normalize [file dirname [info script]]]
            
            set pkgParserObj [::tpm::pkgParser new -pkgDirs $::tpm::original_auto_path]
            set :installed_pkgs [$pkgParserObj get_packages]
        }

        :public method list_installed {} {
            if {[llength ${:installed_pkgs}] == 0} {
                puts " (none found)"
            } else {
                foreach pkgDict ${:installed_pkgs} {
                    set line [list \
                        cyan " - " \
                        yellow [format "%-20s" [dict get $pkgDict name]] \
                        green  [format "%-8s" [dict get $pkgDict version]] \
                        cyan  [format "%-40s" [dict get $pkgDict path]] \
                        magenta [format "%-9s" [dict get $pkgDict type]] \
                    ]
                    :cputs_multi $line
                }
            }
        }

        :public method is_installed {pkg} {
            foreach pkgDict ${:installed_pkgs} {
                if {[dict get $pkgDict name] eq $pkg} {
                    return 1
                }
            }
            return 0
        }

        :public method get_installed_packages_by_name {pkg} {
            set result {}
            # puts "Searching for installed packages named '$pkg'... ${:installed_pkgs}"
            foreach pkgDict ${:installed_pkgs} {
                if {[dict get $pkgDict name] eq $pkg} {
                    lappend result $pkgDict
                }
            }
            return $result
        }
    }
}