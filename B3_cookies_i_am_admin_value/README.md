## Exploitation process

1. Open the browser’s Developer Tools by pressing `F12`

2. Locate the cookies:
  * FireFox: `Storage` -> `Cookies`
  * For Chrome: `Application` -> `Stoirage` -> `Cookies`

3. The entry with the `Name``I_am_admin` has a `Value` of `68934a3e9455fa72420237eb05902327`, which appears to be a hash. According to [https://www.dcode.fr/cipher-identifier](Cipher Identifier), it uses the MD5 algorithm.

4. Decrypt the hash using [https://www.dcode.fr/md5-hash](MD5-hash). The decoded value is `false`. Reading the entry again shows that `I_am_admin` is set to `false`, indicating the user is not an administrator.

5. Use [https://www.dcode.fr/md5-hash](MD5-hash) again to hash the value `true`. Replace the existing cookie `Value` with the hashed version of `true`.

6. Refresh the page to get the flag.

## Definitions

The server trusted a client-controlled cookie to determine administrative access. 

In real-world scenarios, this type of vulnerability can be exploited for more than just gaining administrative access. If a web application stores critical parameters in cookies and trusts them without proper server-side validation, an attacker can manipulate the system’s behavior to their advantage.

For example, in an online learning platform, cookies may store information about a user’s subscription type - free or premium. If this value is only hashed and not securely protected, an attacker could modify it to gain access to paid courses, exams, or certificates without paying. Since the server relies on client-side data, it would incorrectly treat the user as authorized.

## How to Fix

Do not give acces to values. Espetially to unauthorized users.

1. To protect integrity, the server can sign the cookie. A signature is appended to the cookie value. When the server reads the cookie on a later request, it verifies that the value hasn’t been tampered with by checking the signature. But the cookie value is still visible in plain text, so sensitive information should not be stored this way.

2. For sensitive data, the cookie value can be encrypted using a server-side secret key. When the cookie is created, the value is encrypted, and the server decrypts it when reading. This prevents the client from seeing or modifying sensitive information directly.

3. Adding `HttpOnly` prevents JavaScript from accessing the cookie, protecting it from XSS attacks. Only the server can read or modify it.

4. Adding `Secure` ensures the cookie is only sent over HTTPS connections, protecting it from interception MitM attacks (Man-in-the-Middle).

5. The `SameSite` attribute restricts sending cookies to other domains, mitigating CSRF attacks (Cross-Site Request Forgery).