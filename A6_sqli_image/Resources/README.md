## Exploitation Process

1. Test for vulnerability by injecting a logical condition (`1 OR 1=1`) into the "Image number" search field.

    *The application returned all images in the database instead of just one, confirming the query structure was altered.*

    **Why this works:** The injection `1 OR 1=1` creates a WHERE clause that evaluates to `TRUE` for every row. If the original query was `SELECT * FROM images WHERE id = '$input'`, it becomes `SELECT * FROM images WHERE id = '1' OR 1=1`, which returns all records because `1=1` is always true.

2. Retrieve columns from the `list_images` table.
   *(Note: The table name `list_images` is hex-encoded to `0x6c6973745f696d61676573` to bypass quote filters).*

   ```sql
   -1 UNION SELECT column_name, 1 FROM information_schema.columns WHERE table_name=0x6c6973745f696d61676573
   ```

   *Found columns `id`, `url`, `title` and `comment`.*

3. Extract the content of `title` and `comment` columns.

    ```sql
    -1 UNION SELECT title, comment FROM list_images
    ```

    **Result:**
   - **title:** `If you read this just use this md5 decode lowercase then sha256 to win this flag ! : 1928e8083cf461a51303633093573c46`

## Definitions

**SQL Injection (Boolean-Based / Tautology)**
A type of injection where the attacker forces the database to evaluate a condition as true (`OR 1=1`) for every row, often causing the application to dump the entire contents of a table.

**HEX Encoding Bypass**
A technique to evade Web Application Firewalls (WAF) or simple filters that block single quotes (`'`). By converting strings to their Hexadecimal representation (e.g., `0x616263`), attackers can pass string values to the database without using quotes.

**ORM (Object-Relational Mapping)**
A programming technique used to convert data between object-oriented programming languages and relational databases. ORM libraries automatically use prepared statements, effectively preventing SQL injection by default.

## How to Fix

### Use Prepared Statements
   Separate the code from the data. Use PDO (PHP Data Objects) with placeholders to ensure user input is treated as data, not executable code.
   ```php
   $stmt = $pdo->prepare('SELECT * FROM list_images WHERE id = :id');
   $stmt->execute(['id' => $input_id]);
   ```
### Use an ORM (Object-Relational Mapping)
Modern frameworks (like **Eloquent** in Laravel, **Hibernate** in Java, or **Entity Framework** in .NET) use ORMs. They automatically handle input sanitization and parameter binding, significantly reducing the risk of SQL injection by abstracting raw SQL queries away from the developer.
    