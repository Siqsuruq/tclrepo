namespace eval tpm {
    nx::Class create installer {
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

            puts "Downloading from: $download_url"
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
            puts "Installing to: $install_dir"

            if {[catch {
                # exec unzip -o $temp_file -d $install_dir
                :extract_zip_to $temp_file $install_dir
            } unzip_err]} {
                puts "Failed to unzip: $unzip_err"
                file delete -force $temp_file
                return
            }

            file delete -force $temp_file
            puts "Package '$pkgName' installed successfully"
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
            # Find where the package was installed
            set install_info [${:pkgdbObj} get_install_info $pkgName]

            if {$install_info eq ""} {
                puts "Cannot find installation information for '$pkgName'."
                return
            }

            set install_path [dict get $install_info path]

            if {![file exists $install_path]} {
                puts "Installed package path does not exist: $install_path"
                return
            }

            puts "Removing package from: $install_path"

            if {[catch {
                file delete -force -- $install_path
            } err]} {
                puts "Failed to delete package: $err"
                return
            }

            # Update the database after successful deletion
            ${:pkgdbObj} delete_package $pkgName
            ${:pkgdbObj} refresh

            puts "Package '$pkgName' uninstalled successfully."
        }

    }
}
