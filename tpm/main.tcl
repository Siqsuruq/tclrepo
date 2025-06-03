#!/usr/bin/env tclsh
# Extend package path to include local libs/

# Save original auto_path before adding local libs
namespace eval tpm {
    set original_auto_path $::auto_path
}


set here [file dirname [file normalize [info script]]]
set auto_path [linsert $auto_path 0 [file join $here libs]]

package require nx
package require http
package require tls 2.0b1
package require json
package require zipfile::decode
package require fileutil
package require dicttool
package require platform
package require inifile

::http::register https 443 ::tls::socket

# Load modules
foreach file {config.tcl helper.tcl system.tcl net.tcl installer.tcl pkgdb.tcl app.tcl} {
    source [file join [file dirname [file normalize [info script]]] $file]
}
::tpm::config init

set app [::tpm::app new]
$app start