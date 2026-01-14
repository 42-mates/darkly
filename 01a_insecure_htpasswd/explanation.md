## Exploitation process

1. Used `nikto` to scan web server.
```bash
   docker run --rm secfigo/nikto -h $IP
```

2. Found `/whatever/htpasswd` and `/admin/`

4. Content was:
```
   root:437394baff5aa33daa618be47b75cb49
```

5. Decrypted MD5 hash using https://crackstation.net/

6. Result password: `qwerty123@`

7. Used these credentials to login at `/admin/`

## Definitions

**Nikto** is an Open Source (GPL) web server scanner. It performs comprehensive tests against web servers for multiple items, including potentially dangerous files, outdated server versions, and configuration issues.

**The .htpasswd file** is used by web servers (like Apache or Nginx) to store usernames and passwords for basic authentication. The passwords inside are encrypted (hashed) for security. This file should never be accessible from the web browser.

## How to Fix

### 1. Disable Directory Listing

The server should not display file lists for directories without an index file.

For Nginx: remove `autoindex on;` or set it to `autoindex off;`.
```nginx
location /whatever {
    autoindex off;
}
```

### 2. Protect Sensitive Files

Ensure that hidden files (starting with a dot like `.htpasswd`) are denied access in the server configuration.

Example for Nginx:
```nginx
location ~ /\. {
    deny all;
}
```

### 3. Stronger Hashing

MD5 is obsolete and easily cracked. Use modern, slow hashing algorithms like **bcrypt** for storing passwords.