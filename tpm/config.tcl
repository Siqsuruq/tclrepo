nx::Object create ::tpm::config {
    :object property {default_repo_url "https://tclrepo.daidze.org/api/v2"}
    :object property config_path

    :public object method init {} {
        set basedir [file dirname [file normalize [info script]]]
        set :config_path [file join $basedir var config]

        if {![file exists [file dirname ${:config_path}]]} {
            file mkdir [file dirname ${:config_path}]
        }

        if {[file exists ${:config_path}]} {
            try {
                set f [open ${:config_path} r]
                while {[gets $f line] >= 0} {
                    if {[regexp {^([^=]+)=(.+)$} $line -> key val]} {
                        if {[info exists :$key]} {
                            set :$key $val
                        }
                    }
                }
                close $f
            } trap error {msg} {
                puts "⚠️ Failed to load config: $msg"
            }
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
