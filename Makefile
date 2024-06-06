SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
BAZEL ?= bazel

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX =

.PHONY: all
all: build test

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@echo "  all      Build and test the project (default)"
	@echo "  build    Build the project"
	@echo "  test     Run tests"
	@echo "  push     Push images to the registry"
	@echo "  gazelle  Run Gazelle to update Bazel build files"
	@echo "  tidy     Run bazel mod tidy to update dependencies"
	@echo "  clean    Clean the project"

.PHONY: build
build:
	$(BAZEL) build //...

.PHONY: test
test: buildifier
	$(BAZEL) test //...

.PHONY: push
push: build
	$(BAZEL) run //:buf_push

.PHONY: gazelle
gazelle:
	$(BAZEL) run //:gazelle

.PHONY: tidy
tidy:
	$(BAZEL) mod tidy

.PHONY: clean
clean:
	$(BAZEL) clean
