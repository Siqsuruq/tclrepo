# BAWT Build System (Ubuntu 20.04 / glibc 2.31)

Container-based build environment for compiling Tcl via [BAWT](https://www.bawt.tcl3d.org/).

## 1. Download BAWT

```bash
mkdir -p /opt/bawt
cd /opt/bawt
curl -LO https://www.tcl3d.org/bawt/download/Bawt-3.3.0.zip
unzip Bawt-3.3.0.zip
```

## 2. Build & start the container

```bash
docker compose up -d --build
```

## 3. Log into the container

```bash
docker compose exec ubuntu-builder bash
```

## 4. Run BAWT

Preview

```bash
cd Bawt-3.3.0
./tclkit-Linux64-intel Bawt.tcl Setup/MyLibs.bawt --list --nosetupwarning
```
and then build or rebuild --complete (first run) or --update (subsequent runs)

```bash
cd Bawt-3.3.0
./tclkit-Linux64-intel Bawt.tcl --tclversion 9.0.4 --architecture x64 --compiler gcc --complete Setup/MyLibs.bawt all
```


Output is written to `BawtBuild/Linux/x64/`.

## Notes

- `LC_ALL`/`LANG` are set to `C.UTF-8` in the container so `p7zip` extracts archives correctly.
- Required system packages (`zlib1g-dev`, `libx11-dev`, `libxft-dev`, `libcups2-dev`, etc.) are installed via the Dockerfile — rebuild the image (`--build`) after any dependency change.
- Use `--update` instead of `--complete` for incremental rebuilds.
