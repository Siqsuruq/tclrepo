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
            set base_dir [file normalize [file dirname [info script]]]

            foreach path $::auto_path {
                set norm_path [file normalize $path]
                if {![file isdirectory $norm_path]} continue
                if {[string match "$base_dir/libs*" $norm_path]} continue  ;# Skip internal libs

                # 1. pkgIndex.tcl-style detection
                set pkgFiles [glob -nocomplain -type f -directory $norm_path */pkgIndex.tcl]
                foreach indexfile $pkgFiles {
                    set f [open $indexfile r]
                    while {[gets $f line] >= 0} {
                        if {[regexp {package ifneeded ([^\s]+) ([^\s]+)} $line -> pkg ver]} {
                            dict set :installed_pkgs $pkg $ver
                        }
                    }
                    close $f
                }

                

                foreach tmfile [fileutil::find $norm_path :is_tm_file] {
                    set name [file tail $tmfile]
                    if {[regexp {^(.+)-(\d+(?:\.\d+)*).tm$} $name -> pkg ver]} {
                        dict set :installed_pkgs $pkg $ver
                    }
                }
            }
        }

        # Custom filter: only include files ending in .tm
        :method is_tm_file {file} {
            return [string match *.tm [file tail $file]]
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