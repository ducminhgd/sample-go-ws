FROM golang:1.17-alpine AS builder

WORKDIR /build

ENV GO111MODULE=on \
    CGO_ENABLED=1  \
    GOARCH="amd64" \
    GOOS=linux

COPY . .
RUN apk update && apk add make pkgconfig gcc g++ bash \ 
    && go mod download \
    && go build -ldflags="-s -w" -o server cmd/gorilla-ws/server.go

FROM alpine:3.14.2

EXPOSE 8001

COPY --from=builder ["/build/server", "/"]
CMD ["/server", "--addr", "0.0.0.0:8001"]
