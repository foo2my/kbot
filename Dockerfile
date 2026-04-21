FROM golang:1.21-alpine AS builder

WORKDIR /go/src/app
COPY . .
RUN apk add --no-cache make git
RUN go mod download
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot"]
