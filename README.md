# Custom 404 Page Default Backend

## Overview

This Docker image provides a simple, customizable 404 page solution for Kubernetes ingress controllers. It can be used as a default backend to handle undefined or unmatched routes across various ingress implementations.

## Features

- Lightweight Docker image
- Simple HTML 404 page
- Easily configurable
- Compatible with multiple Kubernetes ingress controllers
- Prometheus metric (`:1234/metrics`)

## Configuration Options

`404` can be configured using command-line arguments, environment variables, or a YAML configuration file. The following options are available:

- `--port` / `404_PORT`: HTTP server port (default 1234)
- `--path` / `404_PATH`: Root file path
- `--config`: Path to config file (default: `$HOME/.404.yaml`)

### Example YAML Configuration File

You can also use a YAML configuration file to specify options. Here's an example:

```yaml
# .404.yaml
port: 1234
path: ""
```

The config file will be automatically loaded from your home directory if named `.404.yaml`. Alternatively, you can specify a custom path:

```sh
404 --config path/to/config.yaml
```

## Supported Ingress Controllers

### 1. Nginx Ingress Controller

#### Installation
```bash
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --set defaultBackend.enabled=false \
  --set controller.defaultBackend.enabled=false
```

#### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: 404-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: 404-backend
  template:
    metadata:
      labels:
        app: 404-backend
    spec:
      containers:
      - name: 404-backend
        image: ghcr.io/lab42/404:latest
        ports:
        - containerPort: 1234
---
apiVersion: v1
kind: Service
metadata:
  name: 404-backend
spec:
  selector:
    app: 404-backend
  ports:
  - port: 80
    targetPort: 1234
```

#### Configure Nginx Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  template:
    spec:
      containers:
      - name: nginx-ingress-controller
        args:
        - /nginx-ingress-controller
        - --default-backend-service=$(POD_NAMESPACE)/404-backend
```

### 2. Traefik Ingress Controller

#### Helm Installation
```bash
helm install traefik traefik/traefik \
  --set ports.traefik.expose=true
```

#### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: 404-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: 404-backend
  template:
    metadata:
      labels:
        app: 404-backend
    spec:
      containers:
      - name: 404-backend
        image: ghcr.io/lab42/404:latest
        ports:
        - containerPort: 1234
---
apiVersion: v1
kind: Service
metadata:
  name: 404-backend
spec:
  selector:
    app: 404-backend
  ports:
  - port: 80
    targetPort: 1234
```

### 3. Contour Ingress Controller

#### Helm Installation
```bash
helm install contour bitnami/contour
```

#### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: 404-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: 404-backend
  template:
    metadata:
      labels:
        app: 404-backend
    spec:
      containers:
      - name: 404-backend
        image: ghcr.io/lab42/404:latest
        ports:
        - containerPort: 1234
---
apiVersion: v1
kind: Service
metadata:
  name: 404-backend
spec:
  selector:
    app: 404-backend
  ports:
  - port: 80
    targetPort: 1234
```

### 4. Ambassador (Emissary-Ingress) Controller

#### Helm Installation
```bash
helm install ambassador datawire/ambassador
```

#### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: 404-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: 404-backend
  template:
    metadata:
      labels:
        app: 404-backend
    spec:
      containers:
      - name: 404-backend
        image: ghcr.io/lab42/404:latest
        ports:
        - containerPort: 1234
---
apiVersion: v1
kind: Service
metadata:
  name: 404-backend
spec:
  selector:
    app: 404-backend
  ports:
  - port: 80
    targetPort: 1234
```

## Note on Windows Support

Please be aware that I do not use Windows as part of my workflow. As a result, I cannot provide support for Windows-related issues or configurations. However, I do generate Windows executables as a courtesy for those who need them.

Thank you for your understanding!

## Contributing

I welcome contributions to this project! If you have ideas for new features or improvements, please submit a feature request or contribute directly to the project.

## License

This project is licensed under the [MIT License](LICENSE).
