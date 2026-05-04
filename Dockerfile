FROM golang:1.25-alpine AS builder
WORKDIR /app

ARG SERVICE=api

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN mkdir -p /out \
 && for service in api core frontend login platform; do \
      CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o "/out/${service}" "./cmd/${service}"; \
    done \
 && cp "/out/${SERVICE}" /out/service

FROM alpine:3.19
RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /out/ /app/bin/

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/app/bin/service"]