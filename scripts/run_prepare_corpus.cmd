@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "INPUT_DIR="
set "OUTPUT_DIR="
set "RUNTIME_DIR="
set "EXTENSIONS="
set "MAX_FILES="
set "RECURSIVE="
set "OVERWRITE="

:parse
if "%~1"=="" goto run
if /I "%~1"=="--input-dir" (
  set "INPUT_DIR=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--output-dir" (
  set "OUTPUT_DIR=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--runtime-dir" (
  set "RUNTIME_DIR=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--extensions" (
  set "EXTENSIONS=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--max-files" (
  set "MAX_FILES=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--recursive" (
  set "RECURSIVE=1"
  shift
  goto parse
)
if /I "%~1"=="--overwrite" (
  set "OVERWRITE=1"
  shift
  goto parse
)
echo Unknown argument: %~1
exit /b 2

:run
if "%INPUT_DIR%"=="" (
  echo Missing required --input-dir argument.
  exit /b 2
)

set "PS_ARGS=-InputDir ""%INPUT_DIR%"""
if not "%OUTPUT_DIR%"=="" set "PS_ARGS=%PS_ARGS% -OutputDir ""%OUTPUT_DIR%"""
if not "%RUNTIME_DIR%"=="" set "PS_ARGS=%PS_ARGS% -RuntimeDir ""%RUNTIME_DIR%"""
if not "%EXTENSIONS%"=="" set "PS_ARGS=%PS_ARGS% -Extensions ""%EXTENSIONS%"""
if not "%MAX_FILES%"=="" set "PS_ARGS=%PS_ARGS% -MaxFiles %MAX_FILES%"
if "%RECURSIVE%"=="1" set "PS_ARGS=%PS_ARGS% -Recursive"
if "%OVERWRITE%"=="1" set "PS_ARGS=%PS_ARGS% -Overwrite"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%run_prepare_corpus.ps1" %PS_ARGS%
exit /b %ERRORLEVEL%
