## Exploitation process

1. Run `bash script.sh`

2. Wait the flag in the file `line_with_flag.txt`

## Definitions

On the login page, using a random username and a random password generates the following request URL:
`http://<ip>/index.php?page=signin&username=randomusername&password=randompassword&Login=Login#`

This URL can be added in a script to perform a password‑guessing attack by iterating through a list of commonly used passwords available online.

For example, a collection of the 1,000 most common passwords was used to obtain the flag: [1,000 most common passwords](https://lucidar.me/en/security/list-of-1000-most-common-passwords/).

Username `admin` we can see after run the script:
```bash
   docker run --rm secfigo/nikto -h <ip>
```
**Nikto** is an Open Source (GPL) web server scanner. It performs comprehensive tests against web servers for multiple items, including potentially dangerous files, outdated server versions, and configuration issues.

## How to Fix

1. Temporary account lockout (ex: after 3 failed attempt - wait 2 h)

2. CAPTCHA enforcement

3. Increasing response delays after each failed attempt

4. Multi factor authentication (ex: email or SMS verification)

5. Avoid sensitive data in URL parameters

6. Use strong password policies