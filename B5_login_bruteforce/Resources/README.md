## Exploitation process

1. Run `bash script.sh`

2. Wait the flag in the file `line_with_flag.txt`

## Definitions

On the login page, using a random username and a random password generates the following request URL:
`http://<ip>/index.php?page=signin&username=randomusername&password=randompassword&Login=Login#`

This URL can be added in a script to perform a password‑guessing attack by iterating through a list of commonly used passwords available online.

For example, a collection of the 100 most common passwords was used to obtain the flag: [100 most common passwords](https://lucidar.me/en/security/list-of-100-most-common-passwords/).

For example, a collection of the admin-users: [Wordlist Admin-User](https://www.scribd.com/document/461551487/wordlist-admin-user-txt?utm_source=chatgpt.com)

But we know that the most popular admin name is `admin`, and when we did `A1_insecure_htpasswd`, we obtained information about the `root` user. These two can be placed at the top of the list to find the flag using brute force.

## How to Fix

1. Temporary account lockout (ex: after 3 failed attempt - wait 2 h)

2. CAPTCHA enforcement

3. Increasing response delays after each failed attempt

4. Multi factor authentication (ex: email or SMS verification)

5. Avoid sensitive data in URL parameters

6. Use strong password policies