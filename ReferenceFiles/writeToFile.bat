@echo off
setlocal enabledelayedexpansion

@REM Check if both arguments were provided
if "%~1"=="" (
    echo Error: No file path provided
    echo Usage: writeToFile.bat "file/path/output.txt" "text to write"
    exit /b 1
)
if "%~2"=="" (
    echo Error: No content provided
    echo Usage: writeToFile.bat "file/path/output.txt" "text to write"
    exit /b 1
)

@REM Extract the directory path from the full file path
set "dirPath=%~dp1"

@REM Create the directory if it doesn't exist
if not exist "%dirPath%" (
    mkdir "%dirPath%"
    echo Created directory: %dirPath%
)

@REM Write the second argument to the specified file path, overwriting any existing content
<nul set /p ".=%~2" > "%~1" 2>nul

echo Content written to %~1
