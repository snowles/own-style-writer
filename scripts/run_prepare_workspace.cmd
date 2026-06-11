@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "STYLE_DIR="
set "CONTENT_DIR="
set "OUTPUT_DIR="
set "RUNTIME_DIR="
set "EXTENSIONS="
set "MAX_FILES="
set "CONVERTER=auto"
set "ALLOW_UPLOAD="
set "RECURSIVE="
set "OVERWRITE="
set "MINERU_MODEL="

:parse
if "%~1"=="" goto run
if /I "%~1"=="--style-dir" (
  set "STYLE_DIR=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--content-dir" (
  set "CONTENT_DIR=%~2"
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
if /I "%~1"=="--converter" (
  set "CONVERTER=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--mineru-model" (
  set "MINERU_MODEL=%~2"
  shift
  shift
  goto parse
)
if /I "%~1"=="--allow-upload" (
  set "ALLOW_UPLOAD=1"
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
if "%STYLE_DIR%"=="" (
  echo Missing required --style-dir argument.
  exit /b 2
)

set "PS_ARGS=-StyleDir ""%STYLE_DIR%"" -Converter ""%CONVERTER%"""
if not "%CONTENT_DIR%"=="" set "PS_ARGS=%PS_ARGS% -ContentDir ""%CONTENT_DIR%"""
if not "%OUTPUT_DIR%"=="" set "PS_ARGS=%PS_ARGS% -OutputDir ""%OUTPUT_DIR%"""
if not "%RUNTIME_DIR%"=="" set "PS_ARGS=%PS_ARGS% -RuntimeDir ""%RUNTIME_DIR%"""
if not "%EXTENSIONS%"=="" set "PS_ARGS=%PS_ARGS% -Extensions ""%EXTENSIONS%"""
if not "%MAX_FILES%"=="" set "PS_ARGS=%PS_ARGS% -MaxFiles %MAX_FILES%"
if not "%MINERU_MODEL%"=="" set "PS_ARGS=%PS_ARGS% -MineruModel ""%MINERU_MODEL%"""
if "%ALLOW_UPLOAD%"=="1" set "PS_ARGS=%PS_ARGS% -AllowUpload"
if "%RECURSIVE%"=="1" set "PS_ARGS=%PS_ARGS% -Recursive"
if "%OVERWRITE%"=="1" set "PS_ARGS=%PS_ARGS% -Overwrite"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%run_prepare_workspace.ps1" %PS_ARGS%
exit /b %ERRORLEVEL%
