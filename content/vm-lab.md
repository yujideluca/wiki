---
id: vm-lab
title: vm-lab (test machines for Windows)
aliases: [vmlab, Windows test VMs]
kind: script
project: laptop-setup
status: active
since: 2026-11-06
location: vm-lab:vmlab
fed_by: []
feeds: [status-quo]
sources: [vm-lab:vmlab, vm-lab:README.md, vm-lab:templates/autounattend.xml, vm-lab:templates/lab-setup.ps1, vm-lab:templates/provision-rust.ps1, vm-lab:.gitignore]
reviewed: 2026-11-06T22:03Z
---

## What it is
`vm-lab` is a small command, `vmlab`, that keeps disposable Windows computers on the [[acer-nitro]] so that software can be tried on a real Windows without owning a second machine. A virtual machine (VM) is a whole computer simulated by a program; here the simulation is [QEMU](https://www.qemu.org/) with KVM, the Linux feature that makes it nearly as fast as the real thing. It needs no administrator rights. It was made so that [[status-quo]] could be built and tested on Windows 10 and Windows 11, but any test that needs a clean Windows can use it: an installer, a program, a browser.

## What it does
`vmlab fetch` downloads Microsoft's free evaluation disc image (ISO) of Windows 10 Enterprise LTSC 2021 or Windows 11 Enterprise 24H2. `vmlab create` installs it without anyone clicking: a small extra disc carries an answer file (`autounattend.xml`) that tells Windows Setup how to partition the disk, which language to use and to create a local administrator named `lab`; a first-logon script (`lab-setup.ps1`) then turns on the SSH (Secure Shell) server, a way to run commands from outside, puts the lab key in it and switches off sleep. Windows 11 normally refuses a machine without a security chip, so the answer file switches those checks off; the VM has none. `vmlab provision NAME rust` installs the Rust compiler and Microsoft's C++ build tools inside the VM. `vmlab start`, `stop`, `ssh`, `ps` (run PowerShell code exactly as written), `push`, `pull`, `sync` (copy a source folder in, keeping its build folder), `shot` (screenshot of the VM screen), `reset`, `seal`, `status` and `destroy` cover the rest. The guest reaches the internet through QEMU's private network and can be reached only from this laptop (SSH on port 2210 for Windows 10, 2211 for Windows 11).

## How it does it
It is one Python 3 file with no extra packages. Everything it makes lives in `~/.local/share/vm-lab`: the downloaded images, one folder per VM with its disk and UEFI settings, and an SSH key made only for this purpose. After a VM is installed its disk is **sealed** (`base.qcow2`, never written again). `start` boots a second, thin disk (`work.qcow2`) that records only the changes, so a test cannot damage the clean image: `reset` deletes the thin disk, `seal` merges it into the clean one (used after installing tools). Windows ships drivers for the virtual disk (NVMe) and network card (Intel e1000e), so no driver disc is needed. The screen is kept in memory and `shot` asks QEMU to save it as a picture. Each VM gets 6 GB of memory (`VMLAB_MEM` changes that); on this 23 GB laptop run one at a time.

## Where it sits in the pipeline
It is a tool of the [[acer-nitro]] used by the Windows part of [[status-quo]] (requirement SQ-36): the project is copied into the VM with `sync`, built with `cargo` there and its tests run, and failures that only Windows shows are fixed in the code. Examples found this way: saving a file failed because Windows cannot flush a folder like a file, a recreated file kept its old creation time so a log rotation was missed, and the installer rejected its own record.

## Who receives its output
Giovanni and Claude read the test logs and screenshots it produces; the results shape the Windows support of [[status-quo]].

## Notes
The images are Microsoft's evaluation editions (90 days). The Windows 10 image shows "license expired" on its desktop because of the date baked into that build; use `vmlab create --force` for a fresh one. The VM has no graphics card, so the Windows program can open its window there only with a software OpenGL driver (Mesa) copied next to it and `GALLIUM_DRIVER=llvmpipe` set; Giovanni approved this on 2026-11-06 and it was done in the Windows 11 VM (see the README of vm-lab). Windows 11 was installed and its Rust setup was started the same day. Since 2026-11-06 the folder `~/dev/vm-lab` is a local git repository (branch main, no remote); its `.gitignore` keeps out of git the Python caches (`__pycache__/`), every VM disk, ISO, firmware, socket or process-id file, and secret files (`.env`, `*.pem`, `*.key`, SSH keys, cookies).
