namespace eval tpm {
    nx::Class create net {
        :property {repo_url ""}

        :method init {} {
            set :repo_url [::tpm::config cget -default_repo_url]
        }

        :public method fetch_package_index {} {
            if {${:repo_url} eq ""} {
                return -code error "No repository URL configured."
            }

            set base [string trimright ${:repo_url} "/"]
            set listUrl "$base/packages/list_packages"

            set start [clock milliseconds]
            set token [::http::geturl $listUrl -binary true -keepalive 1]
            set duration [expr {[clock milliseconds] - $start}]
            puts "Fetch took ${duration} ms"

            if {[::http::status $token] ne "ok"} {
                set errorMsg "Failed to fetch package list from $listUrl"
                catch {::http::cleanup $token}
                return -code error $errorMsg
            }

            set body [::http::data $token]
            ::http::cleanup $token

            set jsonDict [::json::json2dict $body]
            if {![dict exists $jsonDict data]} {
                return -code error "Invalid response: missing 'data' key"
            }

            return [dict get $jsonDict data]
        }
    }
}
