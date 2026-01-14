## Exploitation process

1. Used `nikto` to scan web server.
```bash
   docker run --rm secfigo/nikto -h $IP
```

2. Found `/robots.txt` mentioning `/.hidden` and directory listing enabled.

3. Browsed to `http://$IP/.hidden/` and saw recursive directories with README files.

4. Downloaded entire structure recursively using `wget`:
```bash
   wget --recursive --no-parent --no-check-certificate --execute robots=off http://$IP/.hidden/
```

**Why wget:** Manual browsing through deeply nested directories is time-consuming. wget automates downloading all files recursively, preserving directory structure for easy searching.

5. Searched locally for "flag" in downloaded files:
```bash
   cd $IP
   grep -r "flag" .
```

## Definitions

**robots.txt** is a publicly accessible file that tells bots which directories to avoid. Attackers can read it to discover hidden paths.

**Directory Listing** displays folder contents when no index file exists. This exposes the directory structure to attackers.

**wget command breakdown:**
- `--recursive`: Downloads files by following links
- `--no-parent`: Stays within specified directory
- `--execute robots=off`: Ignores robots.txt restrictions

## How to Fix

### 1. Disable Directory Listing

**Nginx:**
```nginx
location /.hidden {
    autoindex off;
}
```

### 2. Block Access to Hidden Directories

**Nginx:**
```nginx
location ~ /\.hidden {
    deny all;
    return 404;
}
```

### 3. Don't Use robots.txt for Security

Never list sensitive directories in `robots.txt` - it reveals them to attackers. Use proper authentication instead.