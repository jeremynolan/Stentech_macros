@echo off
setlocal enabledelayedexpansion

@REM Assign the destination directory to a variable
@REM set "destDir=C:\BRS\Work\00BRS-Macro-Test\JobNumT\CheckPlots"
set "destDir=%~1"

@REM Validate the destination directory
if not exist "%destDir%" (
    echo Error: Destination directory does not exist: %destDir%
    exit /b 1
)

@REM Source directory
set "sourceDir=C:\CADmatic\CheckPlots"

@REM Move PDF files
echo Moving PDF files from %sourceDir% to %destDir%...
for %%F in ("%sourceDir%\*.pdf") do (
    move /Y "%%F" "%destDir%\"
    if errorlevel 1 (
        echo Error: Failed to move %%F
    ) else (
        echo Moved: %%F
    )
)

echo Move operation completed.