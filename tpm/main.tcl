#!/usr/bin/env tclsh
package require nx
package require http
package require tls 2.0b1
package require json
package require zipfile::decode
package require zlibtcl

::http::register https 443 ::tls::socket

# Load modules
foreach file {config.tcl system.tcl net.tcl installer.tcl pkgdb.tcl app.tcl} {
    source [file join [file dirname [file normalize [info script]]] $file]
}
::tpm::config init

set app [::tpm::app new]
$app start