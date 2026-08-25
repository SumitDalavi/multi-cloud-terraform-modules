FROM golang:1.21-alpine

WORKDIR /app

# Install terraform
RUN apk add --no-cache curl unzip git bash \
    && curl -O https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip \
    && unzip terraform_1.5.7_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_1.5.7_linux_amd64.zip

COPY . .

WORKDIR /app/tests
RUN go mod init terraform-tests || true
RUN go mod tidy

CMD ["go", "test", "-v", "./..."]
