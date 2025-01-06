# Docker Security Scan

Este proyecto configura un workflow de GitHub Actions para analizar imágenes Docker utilizando Snyk, detectando vulnerabilidades de seguridad.

## Configuración

1. **Secretos necesarios**:
   - `AWS_ACCESS_KEY_ID`: Clave de acceso para AWS.
   - `AWS_SECRET_ACCESS_KEY`: Clave secreta para AWS.
   - `SNYK_TOKEN`: Token de autenticación de Snyk.

2. **Archivo del workflow**: 
   El workflow ejecuta los siguientes pasos:
   - Autenticación en Amazon ECR.
   - Pull de la imagen Docker.
   - Escaneo de vulnerabilidades usando Snyk.

```yaml
name: Docker Security Scan

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  snyk-docker-scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Log in to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v1

      - name: Pull Docker image
        run: |
          docker pull --platform linux/amd64 982081066879.dkr.ecr.us-east-1.amazonaws.com/mi-app-docker:latest

      - name: Install Snyk
        run: npm install -g snyk

      - name: Authenticate Snyk
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        run: snyk auth $SNYK_TOKEN

      - name: Run Snyk Docker scan
        run: snyk container test 982081066879.dkr.ecr.us-east-1.amazonaws.com/mi-app-docker:latest --file=Dockerfile --severity-threshold=high
```

## Ejecución
Cada vez que realices un push o pull request a la rama main, el workflow:

1. **Autentica en AWS y ECR.
2. **Descarga la imagen Docker desde ECR.
3. **Ejecuta un análisis de vulnerabilidades con Snyk.
## Resultados
Los resultados del escaneo se pueden visualizar en la pestaña Actions de este repositorio.
