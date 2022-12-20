# xBashIO

**xBashIO** is a bash function library for commonly uses operations.

## Install xBashIO

Copy follow link in your terminal an execute it

```bash
curl -s https://git.x-breitschaft.de/global/xbashio/raw/branch/main/src/xbashio.install/install.sh | bash
```

> **Attention**
>
> Install only works if `curl` is installed. `curl` could installed with `sudo apt update && sudo apt install -qy --no-install-recommends curl`

## Prepare your System for remote Access

To activate **SSH** and harden your System call the script

```bash
curl -s https://git.x-breitschaft.de/global/xbashio/raw/branch/main/src/xbashio.install/prepare-system.sh | bash
```

This will install and configure
- `OpenSSH` Server
- `sudo`
- `nano`
- `openssl`
- Creates a `support` User
