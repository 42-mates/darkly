# How to get the key

Open the survey page:
http://ip/index.php?page=survey

Open the browser’s Developer Tools and activate the element inspector:
Press Ctrl + Shift + C.

Select any grade-related input field.
In the Developer Tools console, locate and expand the corresponding <select> HTML element.
Modify the value of one of the <option> elements.

Example:
`<option value="2">2</option>` -> `<option value="200000">2</option>`

On the page, select the modified option from the dropdown and submit the survey.

It sends POST request and server return a data with the key

According info about request from Dev Tools we can build script to get the same flag:

```
curl -X POST "http://ip/index.php?page=survey" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	-d "sujet=2&valeur=200000" \
	| grep flag
```

(suject [2..6] - line in the table)

# Why so bad

1. The survey page is accessible without authentication, allowing any user to submit data.
2. There are no restrictions preventing multiple submissions by the same user.
3. Client-side validation does not enforce acceptable value ranges; modified values are still submitted.
4. Server-side validation is missing or insufficient:
	- The backend accepts the manipulated value.
	- The server responds with HTTP status code 200, indicating successful processing.

As a result, random and invalid data can be inserted into the database.
