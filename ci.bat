@echo off
setlocal

cargo test --release
if errorlevel 1 exit /b %errorlevel%

if not exist dist mkdir dist
cargo build --release
if errorlevel 1 exit /b %errorlevel%

copy /Y target\release\hello.exe dist\hello.exe
if errorlevel 1 exit /b %errorlevel%

dist\hello.exe
if errorlevel 1 exit /b %errorlevel%
