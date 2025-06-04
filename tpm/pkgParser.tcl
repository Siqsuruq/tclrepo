namespace eval tpm {
    nx::Class create pkgParser {
        :property {pkgDirs ""}
        # List of dictionaries representing packages at least with 4 keys: name, version, path, and type.
        :property {pkgs ""}


        :method init {} {
            next
            :parse_package_files
            :get_packages
        }

        :public method parse_package_files {} {
            set pkgFiles {}
            foreach dir ${:pkgDirs} {
                if {![file isdirectory $dir]} {
                    continue
                }
                set norm_dir [file normalize $dir]
                puts "Scanning for installed packages in: $norm_dir"
                set files [glob -nocomplain -type f -directory $norm_dir */pkgIndex.tcl]
                lappend pkgFiles {*}$files

                foreach tmfile [fileutil::find $norm_dir :is_tm_file] {
                    puts "Found TM File: $tmfile"
                    set f [open $tmfile r]
                    set contents [read $f]
                    close $f

                    # Extract all "package provide <name> <version>" lines
                    foreach {line} [split $contents "\n"] {
                        if {[regexp {package provide\s+([^\s]+)\s+([^\s]+)} $line -> pkg ver]} {
                            dict set :installed_pkgs $pkg [dict create version $ver path [file dirname $tmfile]]
                        }
                    }
                }
            }
            foreach pkgIndex $pkgFiles {
                puts "Parsing pkgIndex file: $pkgIndex"
                :parse_pkgIndex $pkgIndex
            }
        }

        :public method parse_pkgIndex {indexfile} {
            set f [open $indexfile r]
            set pkgDict [dict create]
            try {
                while {[gets $f line] >= 0} {
                    if {[regexp {package ifneeded ([^\s]+) ([^\s]+)} $line -> pkg ver]} {
                        dict set pkgDict name $pkg
                        dict set pkgDict version $ver
                        dict set pkgDict path [file dirname $indexfile]
                        dict set pkgDict type "pkgIndex"
                    }
                }
                puts "Found package: $pkg (version: $ver) in $indexfile"
                lappend :pkgs $pkgDict
            } on error {errMsg} {
                return -code error "Error parsing pkgIndex file '$indexfile': $errMsg"
            } finally {
                close $f
            }
        }

        :method is_tm_file {file} {
            return [string match *.tm [file tail $file]]
        }

        :public method get_packages {} {
            if {[llength ${:pkgs}] == 0} {
                return "No packages found."
            }
            puts "Found [llength ${:pkgs}] packages:"
            foreach pkg ${:pkgs} {
                set name [dict get $pkg name]
                set version [dict get $pkg version]
                set path [dict get $pkg path]
                set type [dict get $pkg type]
                puts " - Name: $name, Version: $version, Path: $path, Type: $type"
            }
            return ${:pkgs}
        }
    }
}