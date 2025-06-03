namespace eval tpm {
    nx::Class create app -mixin Helper {
        :property {pkgdbObj:object,type=pkgdb,substdefault {[::tpm::pkgdb new]}}
        :property {netObj:object,type=net,substdefault {[::tpm::net new]}}
        :property {sysObj:object,type=system,substdefault {[::tpm::system new]}}

        :method init {} {
        }

        :public method start {} {
            :cputs green "Welcome to tpm (NX version)"
            :cputs_multi [list green "Type " blue "'help' " green "for commands. Type " blue "'exit' " green "to quit."]
            :cputs_multi [list green "Repository: " blue "[::tpm::config cget -default_repo_url]"]
            :cputs red "------------------------------------------------------"

            while {1} {
                puts -nonewline "> "
                flush stdout
                if {[gets stdin line] < 0 || $line eq "exit"} {
                    :cputs green "Goodbye!"
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
                system {
                    :cputs green "System information:"
                    :cputs red "------------------------------------------------------"
                    ${:sysObj} print_summary
                }
                install {
                    if {[llength $args] != 1} {
                        :cputs_multi [list green "Usage: " blue "install <package>"]
                    } else {
                        :install_package [lindex $args 0]
                    }
                }
                delete {
                    if {[llength $args] != 1} {
                        :cputs_multi [list green "Usage: " blue "delete <package>"]
                    } else {
                        :delete_package [lindex $args 0]
                    }
                }
                help {
                    :help
                }
                default {
                    :cputs_multi [list red "Unknown command: " blue "$cmd"]
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

        :public method list_remote {} {
            try {
                set net [::tpm::net new]
                set packages [$net fetch_package_index]
                $net destroy

                # Header
                :cputs_multi [list \
                    cyan " - " \
                    yellow "Package Name         " \
                    green "Version   " \
                    blue "(Platform): " \
                    magenta "Description" \
                ]

                foreach pkg $packages {
                    set name      [dict get $pkg package_name]
                    set version   [dict get $pkg version]
                    set platform  [dict get $pkg platform_name]
                    set desc      [dict get $pkg package_description]

                    set line [list \
                        cyan " - " \
                        yellow [format "%-20s" $name] \
                        green  [format "%-8s" $version] \
                        blue   [format "(%s): " $platform] \
                        magenta $desc \
                    ]
                    :cputs_multi $line
                }
            } on error {errMsg} {
                :cputs_multi [list red_bold "Error: " red "$errMsg"]
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
            :cputs green "Available commands:"
            :cputs red "------------------------------------------------------"
            :cputs_multi [list green "  installed                 " blue "List all locally installed packages"]
            :cputs_multi [list green "  installed <name(s)>       " blue "Show version info of a specific installed package(s)"]
            :cputs_multi [list green "  available                 " blue "List packages in the remote repository"]
            :cputs_multi [list green "  install <name>            " blue "Install package from the remote repository"]
            :cputs_multi [list green "  delete <name>             " blue "Delete (uninstall) package"]
            :cputs_multi [list green "  system                    " blue "Shows current system information"]
            :cputs_multi [list green "  help                      " blue "Show this help message"]
            :cputs_multi [list green "  exit                      " blue "Exit the package manager"]
        }
    }
}