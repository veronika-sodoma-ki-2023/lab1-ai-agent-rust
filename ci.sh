#!/usr/bin/env bash
set -eu

cargo test --release
mkdir -p dist
cargo build --release
cp target/release/hello dist/hello
./dist/hello
