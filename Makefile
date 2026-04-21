APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=sergfut
VERSION=$(shell git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")-$(shell git rev-parse --short HEAD)
TARGET_OS ?= $(shell go env GOOS)
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	$(shell go env GOPATH)/bin/golint $(shell go list ./... | grep -v /vendor/)

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/foo2my/kbot/cmd.appVersion=${VERSION}"

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot