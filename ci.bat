@echo off
setlocal

echo == Configure ==
rustc --version
if errorlevel 1 exit /b %errorlevel%
cargo --version
if errorlevel 1 exit /b %errorlevel%
cargo fetch
if errorlevel 1 exit /b %errorlevel%

echo == Build ==
cargo build --release
if errorlevel 1 exit /b %errorlevel%

echo == Test ==
cargo test --release
if errorlevel 1 exit /b %errorlevel%

echo == Package ==
if not exist dist mkdir dist
if errorlevel 1 exit /b %errorlevel%
copy /Y target\release\hello.exe dist\hello.exe
if errorlevel 1 exit /b %errorlevel%
dist\hello.exe
if errorlevel 1 exit /b %errorlevel%
