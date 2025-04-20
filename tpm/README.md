# TPM - Tcl Package Manager (Client)

TPM is a cross-platform command-line utility to download and install packages from the Tcl Public Repository.

> **TPM is written entirely in Tcl using the NX object system and requires no external binaries.**

---

## 📦 Features

- List locally installed packages
- Fetch package index from a remote repository
- Install packages from remote
- Automatically installs to a writable path in `$auto_path`
- Works on Windows, Linux, macOS
- No `curl`, no `unzip` — pure Tcl (uses `http`, `zipfile::decode`)

---

## 🛠 Requirements

- Tcl 8.6+
- [Tcllib](https://core.tcl-lang.org/tcllib) (for `zipfile::decode`, `http`, etc.)

> You can check your version by running:  
> `tclsh` → `puts $tcl_version`

---

## 🚀 How to Use

1. **Clone this repo** or download it

```bash
git clone https://github.com/yourname/tpm.git
cd tpm
