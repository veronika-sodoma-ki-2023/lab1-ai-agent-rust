#!/usr/bin/env bash
set -euo pipefail

echo "== Configure =="
rustc --version
cargo --version
cargo fetch

echo "== Build =="
cargo build --release

echo "== Test =="
cargo test --release

echo "== Package =="
mkdir -p dist
cp target/release/hello dist/hello
./dist/hello
