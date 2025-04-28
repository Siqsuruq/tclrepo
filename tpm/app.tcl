namespace eval tpm {
    nx::Class create app {
        :property {pkgdbObj:object,type=pkgdb,substdefault {[::tpm::pkgdb new]}}
        :property {netObj:object,type=net,substdefault {[::tpm::net new]}}

        :method init {} {
        }

        :public method start {} {
            puts "Welcome to tpm (NX version)"
            puts "Type 'help' for commands. Type 'exit' to quit."
            puts "Repository: [::tpm::config cget -default_repo_url]"
            puts "----------------------------------"

            while {1} {
                puts -nonewline "> "
                flush stdout
                if {[gets stdin line] < 0 || $line eq "exit"} {
                    puts "Goodbye!"
                    break
                }
                if {$line eq ""} {
                    continue
                }
                :process_command $line
            }
        }

        :method process_command {line} {
            set cmd [lindex $line 0]
            set args [lrange $line 1 end]

            switch -- $cmd {
                installed {
                    :list_local {*}$args
                }
                available {
                    :list_remote
                }
                install {
                    if {[llength $args] != 1} {
                        puts "Usage: install <package>"
                    } else {
                        :install_package [lindex $args 0]
                    }
                }
                delete {
                    if {[llength $args] != 1} {
                        puts "Usage: delete <package>"
                    } else {
                        :delete_package [lindex $args 0]
                    }
                }
                help {
                    :help
                }
                default {
                    puts "Unknown command: $cmd"
                    :help
                }
            }
        }

        :method list_local {args} {
            if {[llength $args] == 0} {
                puts "Locally installed packages:"
                ${:pkgdbObj} list_installed
            } else {
                foreach pkg $args {
                    if {[${:pkgdbObj} is_installed $pkg]} {
                        set ver [${:pkgdbObj} get_version $pkg]
                        puts [format "%-20s version: %s" $pkg $ver]
                    } else {
                        puts [format "%-20s not installed" $pkg]
                    }
                }
            }
        }

        :method list_remote {} {
            puts "Fetching packages from remote..."
            try {
                set net [::tpm::net new]
                set packages [$net fetch_package_index]
                $net destroy

                foreach pkg $packages {
                    set name      [dict get $pkg package_name]
                    set version   [dict get $pkg version]
                    set platform  [dict get $pkg platform_name]
                    set desc      [dict get $pkg package_description]
                    puts [format " - %-20s %-8s (%s): %s" $name $version $platform $desc]
                }
            } trap error {msg} {
                puts "✗ Error: $msg"
            }
        }

        :method install_package {pkgName} {
            set inst [::tpm::installer new -pkgdbObj ${:pkgdbObj}] 
            $inst install $pkgName
            $inst destroy
        }

        :method delete_package {pkgName} {
            if {![${:pkgdbObj} is_installed $pkgName]} {
                puts "Package '$pkgName' is not installed."
                return
            }
            set inst [::tpm::installer new -pkgdbObj ${:pkgdbObj}] 
            $inst uninstall $pkgName
            $inst destroy
        }

        :method help {} {
            puts "Available commands:"
            puts "  installed                 List all locally installed packages"
            puts "  installed <name(s)>       Show version info of a specific installed package(s)"
            puts "  available                 List packages in the remote repository"
            puts "  install <name>            Install package from the remote repository"
            puts "  delete <name>             Delete (uninstall) package"
            puts "  help                      Show this help message"
            puts "  exit                      Exit the package manager"
        }
    }
}