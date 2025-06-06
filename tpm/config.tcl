namespace eval tpm {
    nx::Object create config {
        :object property {basedir:substdefault {[file dirname [file normalize [info script]]]}}
        :object property {default_repo_url "https://tclrepo.daidze.org/api/v2"}
        :object property {tpm_version ""}
        :object property {tpm_path:substdefault {[file dirname [file normalize [info script]]]}}
        :object property {config_path ""}

        :public object method init {} {
            set :config_path [file join ${:basedir} var config.ini]
            :read_config
            :libs_path
        }

        :object method read_config {} {
            try {
                set f [::ini::open ${:config_path} r]
                set :default_repo_url [::ini::value $f "repository" "default_repo_url"]
                set :tpm_version [::ini::value $f "tpm" "version"]
                ::ini::close $f
            } on error {errMsg} {
                puts "Failed to load config: $errMsg"
            }
        }

        :object method libs_path {} {
            # Construct the full local tpm libs path to remove
            set remove_path [file normalize [file join ${:tpm_path} libs]]
            # Rebuild ::auto_path without the remove_path
            set filtered_auto_path {}
            foreach path $::auto_path {
                if {[file normalize $path] ne $remove_path} {
                    lappend filtered_auto_path $path
                }
            }
            set ::tpm::libsdirs [:get_top_level_paths $filtered_auto_path]
        }

        # Function to filter only top-level libs paths from auto_path
        :object method get_top_level_paths {paths} {
            set topLevels {}
            foreach path $paths {
                set isSubfolder 0
                foreach other $paths {
                    if {$path eq $other} continue
                    # Normalize both paths to compare cleanly
                    set normPath   [file normalize $path]
                    set normOther  [file normalize $other]
                    if {[string match "${normOther}/*" $normPath]} {
                        set isSubfolder 1
                        break
                    }
                }
                if {!$isSubfolder} {
                    lappend topLevels $path
                }
            }
            return $topLevels
        }

        :public object method save {} {
            set f [open ${:config_path} w]
            puts $f "# tpm config"
            foreach name [info object variables] {
                if {$name eq "config_path"} continue
                puts $f "$name=[set :$name]"
            }
            close $f
        }
    }
}