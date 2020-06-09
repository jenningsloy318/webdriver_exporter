

GO           ?= go
GOFMT        ?= $(GO)fmt
FIRST_GOPATH := $(firstword $(subst :, ,$(shell $(GO) env GOPATH)))


BIN_DIR ?= $(shell pwd)/build
VERSION ?= $(shell cat VERSION)
REVERSION ?=$(shell git log -1 --pretty="%H")
BRANCH ?=$(shell git rev-parse --abbrev-ref HEAD)
TIME ?=$(shell date --rfc-3339=seconds)
HOST ?=$(shell hostname)  
DOCKER := $(shell { command -v podman || command -v docker; } 2>/dev/null)


all:  fmt style  build 
 

build: | 
	@echo ">> building binaries"
	$(GO) build -o build/webdriver_exporter -ldflags  '-X "github.com/prometheus/common/version.Branch=$(BRANCH)" -X "github.com/prometheus/common/version.Revision=$(REVERSION)" -X "github.com/prometheus/common/version.BuildUser=$(USER)"  -X "github.com/prometheus/common/version.BuildDate=$(TIME)"  '


fmt:
	@echo ">> format code style"
	$(GOFMT) -w $$(find . -path ./vendor -prune -o -name '*.go' -print) 

clean:
	rm -rf $(BIN_DIR)

.PHONY: all style  build  fmt  clean