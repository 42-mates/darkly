## Exploitation process

1. Go to feedback page `http://<ip>/?page=feedback`

2. Leave a comment and instead of `Name` or `Message` input `a` or `script`

3. Get the flag.

## Definitions

The application check the input and sanitize it in a strange way: `<teany text`, `"`, `'`.
But when you send `script`, `a`, `p`, `i` the app give you the flag. So its a bad sanitizing againsty XSS.

## How to Fix

1. Use security libraries or frameworks.

2. Never pass user-controlled input directly to resource loaders.

3. Treat all user input as untrusted by default.

4. Use whitelisting rather than blacklisting.