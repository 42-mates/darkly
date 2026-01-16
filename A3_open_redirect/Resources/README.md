## Exploitation process

1. Inspect the social media links on the homepage footer (Facebook, Twitter, Instagram).

2. Open browser DevTools (F12) to identify the URL structure of these links:
```html
    <li><a href="index.php?page=redirect&amp;site=facebook" class="icon fa-facebook"></a></li>
	<li><a href="index.php?page=redirect&amp;site=twitter" class="icon fa-twitter"></a></li>
	<li><a href="index.php?page=redirect&amp;site=instagram" class="icon fa-instagram"></a></li>
```

3. Change the `site` parameter value from `twitter` to `tvvitter`:
```html
	<li><a href="index.php?page=redirect&amp;site=tvvitter" class="icon fa-twitter"></a></li>
```

4. Click on the modified Twitter icon to trigger the redirect.

## Definitions

**Open Redirect** is a security flaw of web sites, where a site accepts a URL that includes a request for redirection to another site, and performs that redirection without verifying the target site’s legitimacy. The site might support redirection for legitimate purposes, but when the redirection is open to any destination address, attackers can use it to engineer malicious links that look legitimate.

## How to Fix

### Use a Whitelist
The server should only allow specific, pre-approved values.

```php
$allowed = ['facebook', 'twitter', 'instagram'];
if (in_array($_GET['site'], $allowed)) {
    // allow redirect
} else {
    http_response_code(400);
    die('Invalid redirect target');
}
```

### Never trust links blindly
- Before clicking a link, mouse over it and check the structure of the URL - look for suspicious parameters like `redirect`, `url`, `site`. If a site doesn't validate these parameters properly, attackers can make you visit malicious sites while the URL still shows a trusted domain at the beginning.
- Keep your browser up to date. Security patches are released for popular browsers all the time as a response to emerging attacks and vulnerabilities.