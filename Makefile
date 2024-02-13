TARGET_linux_x86_64 = x86_64-unknown-linux-musl
TARGET_linux_arm64 = aarch64-unknown-linux-musl

RUST_VERSION = nightly
TOOLCHAIN = +$(RUST_VERSION)

BUILD_ARG = $(TOOLCHAIN) build -r
BUILD_DIR = ./target/release
BUNDLE_DIR = bundle

RELEASE_ARCH_NAME_x64 = x86_64
RELEASE_ARCH_NAME_arm64 = arm64

RELEASE_TARGETS = arm64 x64
CURRENT_TARGET ?= $(TARGET_$(DETECTED_OS)_$(ARCH))


ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
	ARCH := x64
else
    DETECTED_OS := $(shell uname | tr A-Z a-z)
	ARCH := $(shell uname -m)
endif

CURRENT_TARGET ?= $(TARGET_$(DETECTED_OS)_$(ARCH))

bench:
	cargo build -r
	hyperfine -N --warm64up=100s

build:
	scripts/cargo-ci.sh build

release:
	scripts/cargo-ci.sh build --release

deploy:
	cd example/infrastructure && yarn deploy --require-approval never

flame: export CARGO_PROFILE_RELEASE_DEBUG = true
flame:
	cargo flamegraph

fix:
	cargo fix --allow-dirty
	cargo clippy --fix --allow-dirty
	cargo fmt
