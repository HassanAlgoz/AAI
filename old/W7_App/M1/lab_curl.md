This playground uses **curl**, a command-line tool for transferring data with URLs, to explore the client-server concepts from Module 1. We will use [`httpbin.org`](https://httpbin.org/#/), a simple service that mirrors the HTTP requests you send to it.

---

## Activity 0: The Address Book (DNS)

This activity explores how your computer finds the server using **DNS**.

### 1. Predict

When you type `httpbin.org`, how does `curl` know where to send the message?

### 2. Run

**`curl -v https://httpbin.org/get`**

### 3. Investigate

* Find the line that says `* Connecting to httpbin.org (x.x.x.x) port 443`.
* The numbers in parentheses (e.g., `35.171.x.x`) are the **IP Address**. This is the phone number; `httpbin.org` is just the name in the phone book (DNS).

---

## Activity 1: The Anatomy of a URL

This activity explores the parts of a Uniform Resource Locator (URL).

### 1. Predict

In the URL `https://httpbin.org/get?name=student`, which part is the **Path** and which is the **Query**?

### 2. Run

**`curl -v "https://httpbin.org/anything/my/path?id=101&sort=desc"`**

### 3. Investigate

* **Scheme**: `https` (Secure method)
* **Host**: `httpbin.org` (The building)
*   **Path**: `/anything/my/path` (The specific room)
*   **Query Strings**: `id=101` and `sort=desc` (Instructions)

### 4. Make

Construct a URL that talks to the host `httpbin.org`, uses the path `/delay/2`, and passes a query `n=5` (forcing the server to wait 2 seconds).

> **Command:** `curl -v "https://httpbin.org/delay/2?n=5"`

---

## Activity 2: The Anatomy of a Request

This activity explores **HTTP Headers** and **Status Codes**.

### 1. Predict

Look at the following command. What information do you think the server will return? What status code do you expect to see?
`curl -v https://httpbin.org/status/200`

### 2. Run

Open your terminal and execute:
**`curl -v https://httpbin.org/status/200`**

### 3. Investigate

* Find the lines starting with `>`. These are the **Request Headers** sent by your "User-Agent" (curl).
* Find the lines starting with `<`. These are the **Response Headers** from the server.
* Identify the **Status Code**. Is it "200 OK"?

### 4. Modify

Change the URL to trigger a "Client Error" (4xx) or a "Server Error" (5xx).

* **Try:** `curl -v https://httpbin.org/status/404`
* **Try:** `curl -v https://httpbin.org/status/500`

### 5. Make

Create a curl command that sends a custom **User-Agent** header to "pretend" you are a mobile phone.

> **Hint:** Use the `-H` flag: `curl -H "User-Agent: MyFakeMobile" -v https://httpbin.org/get`

---

## Activity 3: Content Negotiation

This activity explores how clients tell servers what format they prefer (JSON vs. HTML).

### 1. Predict

If you ask the server for "image/png" but the endpoint is designed to return text, what happens?

### 2. Run

Execute these two commands and compare the "Content-Type" in the response headers:

1. **`curl -v -H "Accept: application/json" https://httpbin.org/get`**
2. **`curl -v -H "Accept: text/html" https://httpbin.org/get`**

### 3. Investigate

* Did the server change its representation based on your "Accept" header?
* Look for the `Content-Length` header. Does it change when the format changes?

### 4. Modify

Try to request a format that doesn't exist, like `application/xml-made-up`. See how the server reacts.

### 5. Make

Use curl to fetch only the **Headers** (and no body) of `google.com` to see what server software they are using.

> **Hint:** Use the `-I` (capital i) flag for a HEAD request.

---

## Activity 4: The RESTful Verbs (Nouns & Verbs)

This activity explores **Methods** like GET, POST, and DELETE.

### 1. Predict

What is the difference between sending data in a **GET** query string versus a **POST** body?

### 2. Run

Run these two commands:

1. **`curl "https://httpbin.org/get?name=Alice&status=learning"`** (GET with Query Params)
2. **`curl -X POST -d "name=Alice&status=learning" https://httpbin.org/post`** (POST with Data Body)

### 3. Investigate

* In the first command, where is the data located in the URL?
* In the second command, find the `Content-Type: application/x-www-form-urlencoded` header. This tells the server how to process the body.

### 4. Modify

Try a **PUT** request to `https://httpbin.org/put` and a **DELETE** request to `https://httpbin.org/delete`. Notice how the URL (the noun) stays similar, but the verb changes the action.

* **Try:** `curl -X PUT https://httpbin.org/put`
* **Try:** `curl -X DELETE https://httpbin.org/delete`
* **Try:** `curl -X PATCH -d "status=updated" https://httpbin.org/patch` (Partial Update)

### 5. Make

Submit a JSON object using a POST request. This is the standard for modern APIs.

> **Command:** `curl -X POST -H "Content-Type: application/json" -d '{"id": 123, "item": "coffee"}' https://httpbin.org/post`

---

## Activity 5: Statelessness and Cookies

This activity explores how servers "remember" you despite HTTP being stateless.

### 1. Predict

If you send a request to "set" a cookie, will the next request automatically remember it?
*(Note: Curl is stateless by default!)*

### 2. Run

1. **`curl -v https://httpbin.org/cookies/set/theme/dark`**
2. **`curl -v https://httpbin.org/cookies`**

### 3. Investigate

* In the first command, look for the `Set-Cookie` header from the server.
* In the second command, does the server "remember" your theme? (It won't, because curl didn't save the "badge").

### 4. Modify

To make curl behave like a browser and "remember" the state, we use a "cookie jar" (a text file).

1. **`curl -c cookies.txt https://httpbin.org/cookies/set/theme/dark`**
2. **`curl -b cookies.txt https://httpbin.org/cookies`**

### 5. Make

Open the `cookies.txt` file in your text editor. Can you manually change the "theme" from "dark" to "light" and then run the second command again? This is how "Session Management" can be manipulated.

This exercise explores how data travels through **Proxies** and the difference between **HTTP** and **HTTPS**. We will use `curl` to inspect how servers handle redirects and encryption.

---

## Activity 6: The Middlemen and Security

This activity explores **Redirects**, **Proxies**, and **Encryption (HTTPS)**.

### 1. Predict

If you try to visit a website using plain `http://`, but the site requires security, what **Status Code** do you expect the "middleman" (server or proxy) to send back?

### 2. Run

Execute the following command to see how a server "forces" you to use a secure connection:
**`curl -I http://google.com`**

### 3. Investigate

* Look at the **Status Code**. Is it `301 Moved Permanently`?
* Look for the `Location` header in the response. Where is the server trying to send you?
* Now, run a command to see the "Armored Envelope" of HTTPS:
**`curl -vI https://www.google.com`**
* Find the lines that mention `TLS handshake` or `SSL connection`. This confirms the "armored envelope" is being built before any data is sent.

### 4. Modify

Proxies can be used to "filter" or "cache" data. You can simulate a proxy-like behavior by telling `curl` to follow redirects automatically using the `-L` (Location) flag.

* **Try:** `curl -L -v http://google.com`
* Notice how `curl` now performs **two** requests: first the insecure one, then the secure one automatically.

### 5. Make

Imagine you are a network administrator. You want to see if a specific proxy is adding its own "stamp" (header) to a request. Use `curl` to inspect the headers of a site that uses a Content Delivery Network (a type of proxy), like GitHub.

> **Command:** `curl -I https://github.com`
> **Task:** Look for headers starting with `X-` (like `X-GitHub-Request-Id` or `Via`). These are often added by proxies or load balancers to track the request.

---

### Key Concepts Refresher

* **HTTPS** encrypts the URL Path, Headers, and Body, but the IP Address and Domain remain visible to the "mailman" (routers/ISPs).
* **Proxies** act as middlemen for caching (speed), filtering (security), or load balancing (scaling).
