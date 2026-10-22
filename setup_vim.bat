@echo off

set AUTOLOAD_DIR=%userprofile%\vimfiles\autoload

if not exist "%AUTOLOAD_DIR%" mkdir "%AUTOLOAD_DIR%"
if not exist "%AUTOLOAD_DIR%\plug.vim" powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile %AUTOLOAD_DIR%\plug.vim"

copy .vimrc %userprofile%

