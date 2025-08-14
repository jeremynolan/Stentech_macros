@echo off
setlocal EnableDelayedExpansion

:: Check if all required parameters are provided
if "%~3"=="" (
    echo Usage: %~nx0 [json_file] [json_path] [new_value]
    echo Example: %~nx0 config.json ".settings.name" "new_name"
    exit /b 1
)

set "json_file=%~1"
set "json_path=%~2"
set "new_value=%~3"

:: Check if jq is installed
where jq >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: jq is not installed. Please install jq to use this script.
    echo Download from: https://stedolan.github.io/jq/download/
    exit /b 1
)

:: Check if input file exists
if not exist "%json_file%" (
    echo Error: File %json_file% not found
    exit /b 1
)

:: Create a temporary file
set "temp_file=%temp%\temp_%random%.json"

:: Check if the value is numeric (including decimals)
echo %new_value%| findstr /r "^[0-9][0-9]*$" >nul
if %ERRORLEVEL% equ 0 (
    :: For numbers, don't add quotes
    jq "%json_path% = %new_value%" "%json_file%" > "%temp_file%"
) else (    
    :: For strings, add quotes
    jq "%json_path% = \"%new_value%\"" "%json_file%" > "%temp_file%"
)

:: Check if jq command was successful
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to update JSON file
    del "%temp_file%" 2>nul
    exit /b 1
)

:: Replace original file with updated content
move /y "%temp_file%" "%json_file%" >nul

echo JSON file updated successfully
exit /b 0

@REM  C:\ProgramData\WISE Software Solutions\VisualCAM 16.9\macros\ReferenceFiles\updateJson.bat C:\CADmatic\NewJob.json .rbData.preCADEngineerID 123.000000
