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

            # foreach path $::tpm::original_auto_path {
            #     puts "Scanning for installed packages in: $path"
            #     set norm_path [file normalize $path]
            #     if {![file isdirectory $norm_path]} continue

            #     # 1. pkgIndex.tcl-style detection
            #     set pkgFiles [glob -nocomplain -type f -directory $norm_path */pkgIndex.tcl]
            #     puts "Found pkgIndex.tcl files: $pkgFiles"
            #     # foreach indexfile $pkgFiles {
            #     #     set f [open $indexfile r]
            #     #     while {[gets $f line] >= 0} {
            #     #         if {[regexp {package ifneeded ([^\s]+) ([^\s]+)} $line -> pkg ver]} {
            #     #             dict set :installed_pkgs $pkg [dict create version $ver path [file dirname $indexfile]]
            #     #         }
            #     #     }
            #     #     close $f
            #     # }
            #     # foreach tmfile [fileutil::find $norm_path :is_tm_file] {
            #     #     set f [open $tmfile r]
            #     #     set contents [read $f]
            #     #     close $f

            #     #     # Extract all "package provide <name> <version>" lines
            #     #     foreach {line} [split $contents "\n"] {
            #     #         if {[regexp {package provide\s+([^\s]+)\s+([^\s]+)} $line -> pkg ver]} {
            #     #             dict set :installed_pkgs $pkg [dict create version $ver path [file dirname $tmfile]]
            #     #         }
            #     #     }
            #     # }
            # }
        }

        # Custom filter: only include files ending in .tm
        :method is_tm_file {file} {
            return [string match *.tm [file tail $file]]
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
                    ]
                    :cputs_multi $line
                }
            }
        }

        :public method is_installed {pkg} {
            return [dict exists ${:installed_pkgs} $pkg]
        }

        :public method get_version {pkg} {
            if {[dict exists ${:installed_pkgs} $pkg]} {
                return [dict get [dict get ${:installed_pkgs} $pkg] version]
            }
            return ""
        }

        :public method get_install_info {pkgName} {
            if {![dict exists ${:installed_pkgs} $pkgName]} {
            return ""
        }
            return [dict get ${:installed_pkgs} $pkgName]
        }
    }
}