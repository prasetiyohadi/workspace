# Tilt

[Tilt](https://tilt.dev/) is a multi-service dev environment for teams on Kubernetes.

[Github repository](https://github.com/tilt-dev/tilt/)

## Getting started

Run command `tilt up` in the project directory and go to the Tilt dashboard page. The dashboard will show error because we don't have a `Tiltfile` yet.

Tilt is controlled using `Tiltfile`, the first function `print` prints a string to Tilt logs stream.

```
print('Hello Tiltfile')
docker_build('pras/simple-python-server', '.')
k8s_yaml('app.yaml')
k8s_resource('simple-python-server', port_forwards=8080)
```

Prepare application source file, e.g., `app.py`.

```
from http.server import BaseHTTPRequestHandler, HTTPServer


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello, World!\n")


server = HTTPServer(("0.0.0.0", 8080), SimpleHTTPRequestHandler)
server.serve_forever()
```

Function `docker_build` will build the application based on existing `Dockerfile`.

```
FROM python:3.8-slim
WORKDIR /app
COPY . /app
EXPOSE 8080
CMD ["python", "/app/app.py"]
```

Function `k8s_yaml` will deploy the container image created from the previous line using manifest file `app.yaml`.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-python-server
  labels:
    app: simple-python-server
spec:
  selector:
    matchLabels:
      app: simple-python-server
  template:
    metadata:
      labels:
        app: simple-python-server
    spec:
      containers:
        - name: simple-python-server
          image: pras/simple-python-server
          ports:
            - containerPort: 8080
```

The function `k8s_resource` will monitor the kubernetes resources with label `app: simple-python-server` and expose the application using port forwarding to port 8080.
