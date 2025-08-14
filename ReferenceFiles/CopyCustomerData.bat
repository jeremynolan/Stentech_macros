@echo off
setlocal enabledelayedexpansion

:: Check if both arguments were provided
if "%~2"=="" (
    echo Error: Please provide both a file list and destination folder path
    echo Usage: %~nx0 "file_list.txt" "destination_path"
    exit /b 1
)

:: Set source file list and destination folder from arguments
set "FILE_LIST=%~1"
set "DEST_FOLDER=%~2"

:: Check if file list exists
if not exist "%FILE_LIST%" (
    echo Error: File list not found: %FILE_LIST%
    exit /b 1
)

:: Check if destination folder exists, if not create it
if not exist "%DEST_FOLDER%" mkdir "%DEST_FOLDER%"

:: Read each line from the file list and copy to destination
for /f "usebackq delims=" %%a in ("%FILE_LIST%") do (
    if exist "%%a" (
        echo Copying: %%a
        copy "%%a" "%DEST_FOLDER%"
    ) else (
        echo File not found: %%a
    )
)

echo.
echo Copy process complete

