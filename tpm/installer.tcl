namespace eval tpm {
    nx::Class create installer -mixin Helper {
        :property {pkgdbObj:object,required,type=pkgdb}

        :method init {} {
        }

        :public method install {pkgName} {
            ${:pkgdbObj} refresh_remote
            set pkg [${:pkgdbObj} find_remote_package $pkgName]

            if {$pkg eq ""} {
                puts "Package not found: $pkgName"
                return
            }

            set base [string trimright [::tpm::config cget -default_repo_url] "/"]
            set uuid [dict get $pkg uuid_pkg_version]
            set download_url "$base/download/package/$uuid"

            :cputs_multi [list green "Downloading from: " blue "$download_url"]
            set temp_file [file tempfile tmpfile "tpm_pkg_XXXXXX.zip"]
            # close $tmpfile

            if {[catch {
                set token [::http::geturl $download_url -binary true]
                set data  [::http::data $token]
                set f [open $temp_file wb]
                fconfigure $f -translation binary
                puts -nonewline $f $data
                close $f
                ::http::cleanup $token
            } err]} {
                puts "✗ Failed to download: $err"
                file delete -force $temp_file
                return
            }

            set install_dir [[::tpm::system new] get_install_path]
            :cputs_multi [list green "Installing to: " blue "$install_dir"]
            if {[catch {
                # exec unzip -o $temp_file -d $install_dir
                :extract_zip_to $temp_file $install_dir
            } unzip_err]} {
                puts "Failed to unzip: $unzip_err"
                file delete -force $temp_file
                return
            }

            file delete -force $temp_file
            :cputs_multi [list green "Package " yellow "$pkgName"  green " version " blue "[dict get $pkg version]" green " installed successfully."]
            ${:pkgdbObj} refresh
        }

        :method extract_zip_to {zip_path dest_dir} {
            if {![file isdirectory $dest_dir]} {
                file mkdir $dest_dir
            }
            try {
                ::zipfile::decode::unzipfile $zip_path $dest_dir
                return -code ok
            } on error {errMsg opts} {
                return -code error "Failed to unzip '$zip_path': $errMsg"
            }
        }

        :public method uninstall {pkgName} {
            set pkgs [${:pkgdbObj} get_installed_packages_by_name $pkgName]
            if {[llength $pkgs] == 0} {
                :cputs_multi [list green "Cannot find installation information for " yellow "$pkgName"]
                return
            }
            foreach pkg $pkgs {
                set indx [dict get $pkg indx]
                if {![file exists $indx]} {
                    :cputs_multi [list red_bold "Installed package path does not exist: " red "$indx"]
                    return
                }
                # is it tm file
                if {[string match *.tm [file tail $indx]] == 1} {
                    try {
                        file delete -force -- $indx
                    } on error {errMsg} {
                        :cputs_multi [list red_bold "Failed to delete package " yellow "$pkgName" red_bold " : " red "$errMsg"]
                    }
                } elseif {[string match pkgIndex.tcl [file tail $indx]] == 1} {
                    try {
                        file delete -force -- [dict get $pkg path]
                    } on error {errMsg} {
                        :cputs_multi [list red_bold "Failed to delete package " yellow "$pkgName" red_bold " : " red "$errMsg"]
                    }
                }
                :cputs_multi [list green "Removing package from: " blue "$indx"]
                ${:pkgdbObj} refresh
                :cputs_multi [list green "Package " yellow "$pkgName" green " uninstalled successfully."]
            }
        }
    }
}
