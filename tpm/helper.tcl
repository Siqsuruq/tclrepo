namespace eval tpm {
    nx::Class create Helper {
        :property colors
        :method init {} {
            # Initialize the colors dict
            set :colors {
                red_bold "1;31"
                red     "0;31"
                green   "0;32"
                yellow  "1;33"
                blue    "1;34"
                magenta "1;35"
                cyan    "1;36"
                reset   "0"
            }
            next
        }
 
        :public method cputs {args} {
            set color ""
            set text ""

            if {[llength $args] == 1} {
                set text [lindex $args 0]
            } elseif {[llength $args] == 2} {
                set color [lindex $args 0]
                set text  [lindex $args 1]
            } else {
                error "Usage: cputs ?color? text"
            }

            if {$color ne "" && [dict exists ${:colors} $color]} {
                set code [dict get ${:colors} $color]
                puts "\x1b\[[set code]m$text\x1b\[0m"
            } else {
                puts $text
            }
        }

        :public method cputs_multi {segments} {
            set result ""
            foreach {color text} $segments {
                if {[dict exists ${:colors} $color]} {
                    set code [dict get ${:colors} $color]
                    append result "\x1b\[[set code]m$text"
                } else {
                    append result $text
                }
            }
            append result "\x1b\[0m"
            puts $result
        }
    }
}