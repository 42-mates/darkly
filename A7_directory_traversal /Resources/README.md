## Exploitation Process

1. Identify that the website uses the `page` parameter in `index.php` to load different content:
   `http://[IP]/index.php?page=[filename]`

   *This suggests the server-side PHP code is insecurely using a file inclusion function, likely looking like this:*
   ```php
   include($_GET['page']);
   ```

2. Test if the parameter is vulnerable to directory traversal by using the `../` sequence to exit the web root directory.

    *This suggests the application uses a function like `include()` to render pages based on user input.*

3. Start adding `../` sequences one by one to the `page` parameter to find the root directory.
   - `?page=../`
   - `?page=../../`
   - ... and so on.

4. Observe the page output during testing. In this case, once you go deep enough, the message **"You can DO it !!! :]"** appears.

    *This behavior confirms that we have reached the system's root directory (`/`). In Linux, navigating "above" the root directory (e.g., `cd /../../`) simply keeps you at the root.*

5. Attempt to include a sensitive system file, such as `/etc/passwd`, by injecting the following path into the `page` parameter:

   ```text
   ../../../../../../../../etc/passwd
   ```

   *We do not know exactly where `index.php` is located (it could be in `/var/www/html/` or deeper). By using an excessive number of `../` sequences, we ensure we reach the root `/` and then navigate to `/etc/passwd`. In Linux, `/etc/passwd` is a standard file that is readable by all users, making it the ideal target to prove the vulnerability.*

6. Navigate to the final URL. The server executes the `include()` function with the provided path, reads the system file, and displays the Flag on the page as a result of the successful exploit.

## Definitions

**Local File Inclusion (LFI)** A vulnerability that allows an attacker to trick a web application into exposing or running files on the web server. This occurs when an application includes a file without properly validating the input path, allowing an attacker to read sensitive files (like logs, configurations, or system files).

**Directory Traversal** An exploit that uses the `../` (dot-dot-slash) sequence to access files and directories that are stored outside the web root folder.


## How to Fix

### PHP open_basedir

 Configure the `open_basedir` directive in `php.ini`. This is the most effective server-side defense as it restricts PHP's ability to access files outside of specific designated directories, regardless of the code logic.
   ```ini
   open_basedir = "/var/www/html/"
   ```

### Use a Whitelist

Strictly define a list of allowed files. If the page parameter does not match the whitelist, reject the request.

```php
$allowed = ['home.php', 'about.php', 'contact.php'];
if (!in_array($_GET['page'], $allowed)) {
    die("Invalid page requested.");
}
```

### Nginx URI Filtering

Implement a security rule in Nginx to block any requests containing directory traversal sequences (`../`) before they are passed to the PHP interpreter.

```nginx
    if ($request_uri ~ "\.\./") {
    return 403;
}
```
