## Exploitation process

1. Used `nikto` to scan web server.
```bash
   docker run --rm secfigo/nikto -h $IP
```

2. Found `/robots.txt` mentioning `/.hidden` and directory listing enabled.

3. Browsed to `http://$IP/.hidden/` and saw recursive directories with README files.

4. Downloaded entire structure recursively using `wget`:
```bash
   wget --recursive --no-parent --execute robots=off http://$IP/.hidden/
```

5. Searched locally for "flag" in downloaded files:
```bash
   cd $IP
   grep -r "flag" .
```

## Definitions

**robots.txt** is a publicly accessible file that tells bots which directories to avoid. Attackers can read it to discover hidden paths.

**Directory Listing** displays folder contents when no index file exists. This exposes the directory structure to attackers.

**wget** is a command-line utility for downloading files from the web. It supports recursive downloads, following links automatically, and can handle large directory structures efficiently.

Manual browsing through deeply nested directories is extremely time-consuming. A script would need to make HTTP requests for each directory and parse HTML to find subdirectories, which is slow for hundreds of nested folders. wget automates this process, downloading all files recursively and preserving directory structure for easy searching.

**wget command breakdown:**
- `--recursive` (or `-r`): Downloads files by following links recursively. Without this, only the index.html of the first directory would be downloaded.
- `--no-parent` (or `-np`): Prevents wget from ascending to parent directories. Ensures we stay within `/.hidden/` and don't download the entire website.
- `--execute robots=off`: Ignores robots.txt restrictions. The server's robots.txt blocks `/.hidden/`, so we need this to access it.

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

Never list sensitive directories in `robots.txt` - it reveals them to attackers.