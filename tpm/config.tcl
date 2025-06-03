namespace eval tpm {
    nx::Object create config {
        :object property {basedir:substdefault {[file dirname [file normalize [info script]]]}}
        :object property {default_repo_url "https://tclrepo.daidze.org/api/v2"}
        :object property {tpm_version ""}
        :object property config_path

        :public object method init {} {
            set :config_path [file join ${:basedir} var config.ini]
            :read_config
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