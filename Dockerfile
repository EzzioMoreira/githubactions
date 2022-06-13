FROM golang:1.17-alpine
LABEL maintainer="Ezzio Moreira"
WORKDIR /app

COPY . /app

RUN go build main.go

EXPOSE 8080

CMD  [ "/app/main" ]
