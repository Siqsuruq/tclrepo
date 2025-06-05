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

        # findFiles
        # basedir - the directory to start looking in
        # pattern - A pattern, as defined by the glob command, that the files must match
        :public method findFiles { basedir pattern } {

            # Fix the directory name, this ensures the directory name is in the
            # native format for the platform and contains a final directory seperator
            set basedir [string trimright [file join [file normalize $basedir] { }]]
            set fileList {}

            # Look in the current directory for matching files, -type {f r}
            # means ony readable normal files are looked at, -nocomplain stops
            # an error being thrown if the returned list is empty
            foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
                lappend fileList $fileName
            }

            # Now look for any sub direcories in the current directory
            foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
                # Recusively call the method on the sub directory and append any new files to the results
                set subDirList [:findFiles $dirName $pattern]
                if { [llength $subDirList] > 0 } {
                    foreach subDirFile $subDirList {
                        lappend fileList $subDirFile
                    }
                }
            }
            return $fileList
        }

        :public method parse_package_files {} {
            set pkgFiles {}
            foreach dir ${:pkgDirs} {
                if {![file isdirectory $dir]} {
                    continue
                }
                # Collect pkgIndex.tcl files
                set indexFiles [:findFiles $dir "pkgIndex.tcl"]
                # Collect .tm files
                set tmFiles [:findFiles $dir "*.tm"]
                lappend pkgFiles {*}$indexFiles 
                lappend pkgFiles {*}$tmFiles
            }
            foreach pkgFile $pkgFiles {
                if {[file tail $pkgFile] eq "pkgIndex.tcl"} {
                    :parse_pkgIndex $pkgFile
                } elseif {[string match *.tm $pkgFile]} {
                    :parse_tm $pkgFile
                }
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
                lappend :pkgs $pkgDict
            } on error {errMsg} {
                return -code error "Error parsing pkgIndex file '$indexfile': $errMsg"
            } finally {
                close $f
            }
        }

        :public method parse_tm {tmfile} {
            set filename [file tail $tmfile]

            # Match against official Tcl Module filename pattern
            if {[regexp {^([[:alpha:]_][[:alnum:]_]*)-([0-9][[:alnum:].]*)\.tm$} $filename -> pkg ver]} {
                # Confirm version is valid using package vcompare
                if {[catch {package vcompare $ver 0}]} {
                    return -code error "Invalid version '$ver' in tm file '$filename'"
                }

                set pkgDict [dict create \
                    name $pkg \
                    version $ver \
                    path [file dirname $tmfile] \
                    type "tm"]

                lappend :pkgs $pkgDict
            } else {
                return -code error "Invalid .tm filename format: $filename"
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