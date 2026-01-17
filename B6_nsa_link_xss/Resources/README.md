## Exploitation process

1. On the main page image "National Security Agency" has a link: `http://<ip>/?page=media&src=nsa`.

2. Send a script as `src`: `http://<ip>/?page=media&src=data:text/html;base64,PHNjcmlwdD5hbGVydCgnRGFuZ2Vyb3VzIGNvbnRlbnQnKTwvc2NyaXB0Pg==`.

3. Get the flag.

## Definitions

The `src` parameter is not properly sanitized or restricted. As a result, an attacker can control the resource loaded by the application and force the browser to process random content.

The `data:text/html` scheme allows HTML content to be added directly within a URL. The browser interprets the data as an HTML document and executes any embedded JavaScript.

`Base64` encoding is used to "hide" the real payload and safely transmit special characters (`<`, `>`, quotes) through the URL. This also helps bypass weak input validation and filtering mechanisms.

We use script `<script>alert('Dangerous content')</script>` encoded in Base64 `PHNjcmlwdD5hbGVydCgnRGFuZ2Vyb3VzIGNvbnRlbnQnKTwvc2NyaXB0Pg==`

[base-64-encoding](https://www.dcode.fr/base-64-encoding)

## How to Fix

1. Never pass user-controlled input directly to resource loaders.

2. Implement a strong Content Security Policy (CSP) that disallows `data:` sources and inline scripts.

3. Treat all user input as untrusted by default.

4. Strict whitelist for the `src` parameter.

5. Use security libraries or frameworks.