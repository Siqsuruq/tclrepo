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
- NX
- tls 2.0b1
- [Tcllib](https://core.tcl-lang.org/tcllib) (for `zipfile::decode`, `http`, `json`, )

> You can check your version by running:  
> `tclsh` → `puts $tcl_version`

---

## 🚀 How to Use

1. **Clone this repo** or download it

```bash
git clone https://github.com/Siqsuruq/tclrepo
cd tpm
```

2. Run the TPM shell:

```bash
tclsh main.tcl
```

3. Use interactive commands:

```bash
> help
> installed
> installed nats jsonlib
> available
> install nats
> exit
```

## 💡 Example Output

```bash
> available
Fetching packages from remote...
 - nats                 3.1.1   (Tcl): Tcl client for NATS messaging
 - jsonlib              1.0.0   (Tcl): Fast JSON parser

> install nats
Downloading from: https://tclrepo.daidze.org/api/v2/download/package/abc-uuid
Installing to: /home/user/.local/lib/tpm
✓ Package 'nats' installed successfully

> installed nats
✓ nats                 version: 3.1.1
```