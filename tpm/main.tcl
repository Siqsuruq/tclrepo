#!/usr/bin/env tclsh
# Extend package path to include local libs/

set here [file dirname [file normalize [info script]]]
set auto_path [linsert $auto_path 0 [file join $here libs]]

package require nx
package require http
package require tls
package require json
package require zipfile::decode
package require fileutil
package require dicttool
package require platform
package require inifile

::http::register https 443 ::tls::socket

# Load modules
foreach file {config.tcl helper.tcl pkgParser.tcl system.tcl net.tcl installer.tcl pkgdb.tcl app.tcl} {
    source [file join [file dirname [file normalize [info script]]] $file]
}

set app [::tpm::app new]
$app start