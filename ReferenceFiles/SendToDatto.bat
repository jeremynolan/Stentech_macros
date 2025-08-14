@echo off
setlocal enabledelayedexpansion

@REM Get the current date in a consistent format using PowerShell
for /f "usebackq tokens=*" %%a in (`powershell -Command "Get-Date -Format 'yyyy-MM-dd'"`) do set "standardDate=%%a"
set "year=%standardDate:~0,4%"

@REM Assign arguments to variables
set "drive=%~1"
set "filepath=%~2"
set "category=%~3"
set "group=%~4"
set "customer=%~5"
set "designer=%~6"

@REM Extract filename without extension
set "filename=%~n2"
set "sourcedir=%~dp2"

@REM set json location
set "json_file=C:\CADmatic\NewJob.json"

@REM Validate filepath
if not exist "%filepath%" (
    echo Error: File does not exist: %filepath%
    exit /b 1
)

@REM Process the file
echo Processing file: %filepath%
echo Filename       : %filename%
echo Customer       : %customer%
echo Group          : %group%
echo Category       : %category%
echo Source Folder  : %sourcedir%
echo Designer       : %designer%
echo ---------------

@REM Create directory
set "firstLetter=%customer:~0,1%"
echo First letter of customer: %firstLetter%

set "targetDir=%drive%:\%category%\%group%_%year%\%group%_%firstLetter%\%customer%\%filename%"
echo Target directory: %targetDir%


@REM Create the target directories
if not exist "%targetDir%" (
    mkdir "%targetDir%"
    if errorlevel 1 (
        echo Error: Failed to create directory %targetDir%
        exit /b 1
    ) else (
        echo Created directory: %targetDir%
    )
) else (
    @REM echo Directory exists: %targetDir%
)

if not exist "%targetDir%\CustomerData\" (
    mkdir "%targetDir%\CustomerData\"
    if errorlevel 1 (
        echo Error: Failed to create directory "%targetDir%\CustomerData\"
        exit /b 1
    ) else (
        echo Created directory: "%targetDir%\CustomerData\"
    )
) else (
    @REM echo Directory exists: "%targetDir%\CustomerData\"
)

if not exist "%targetDir%\CheckPlots\" (
    mkdir "%targetDir%\CheckPlots\"
    if errorlevel 1 (
        echo Error: Failed to create directory "%targetDir%\CheckPlots\"
        exit /b 1
    ) else (
        echo Created directory: "%targetDir%\CheckPlots\"
    )
) else (
    @REM echo Directory exists: "%targetDir%\CheckPlots\"
)

if not exist "%targetDir%\JobData\" (
    mkdir "%targetDir%\JobData\"
    if errorlevel 1 (
        echo Error: Failed to create directory "%targetDir%\JobData\"
        exit /b 1
    ) else (
        echo Created directory: "%targetDir%\JobData\"
    )
) else (
    @REM echo Directory exists: "%targetDir%\JobData\"
)

if not exist "%targetDir%\%filename%\" (
    mkdir "%targetDir%\%filename%\"
    if errorlevel 1 (
        echo Error: Failed to create directory "%targetDir%\%filename%\"
        exit /b 1
    ) else (
        echo Created directory: "%targetDir%\%filename%\"
    )
) else (
    @REM echo Directory exists: "%targetDir%\%filename%\"
)
echo ---------------

@REM Log the target directory if user is cadmatic
if /i "%designer%"=="cadmatic" (
    set "temp_file=%temp%\temp_%random%.json"
    echo Target directory: %targetDir% >> "%sourcedir%JobData\folderPath.txt"
    jq ".rbData.folderLink = \"%targetDir%\"" "%json_file%" > "%temp_file%"
    :: Check if jq command was successful
    if %ERRORLEVEL% neq 0 (
        echo Error: Failed to update JSON file
        del "%temp_file%" 2>nul
        exit /b 1
    )
    :: Replace original file with updated content
    move /y "%temp_file%" "%json_file%" >nul
    copy "%json_file%" "%targetDir%\JobData\NewJob.json"
)

echo ---------------
@REM Copy the CustomerData folder
if exist "%sourcedir%CustomerData" (
    echo Copying CustomerData folder...
    xcopy "%sourcedir%CustomerData" "%targetDir%\CustomerData\" /E /I /H /Y
    if errorlevel 1 (
        echo Error: Failed to copy CustomerData folder
    ) else (
        echo CustomerData folder copied successfully
    )
) else (
    echo CustomerData folder not found in source directory
)
echo ---------------

@REM Copy the CheckPlots folder
if exist "%sourcedir%CheckPlots" (
    echo Copying CheckPlots folder...
    xcopy "%sourcedir%CheckPlots" "%targetDir%\CheckPlots\" /E /I /H /Y
    if errorlevel 1 (
        echo Error: Failed to copy CheckPlots folder
    ) else (
        echo CheckPlots folder copied successfully
    )
) else (
    echo CheckPlots folder not found in source directory
)
echo ---------------

@REM Copy Vcam File
if exist "%filepath%" (
    echo Copying %filepath% ...
    xcopy "%filepath%" "%targetDir%\%filename%\" /Q /Y
    if errorlevel 1 (
        echo Error: Failed to copy %filepath%
    ) else (
        echo %filepath% folder copied successfully
    )
) else (
    echo %filename% folder not found in source directory
)
echo ---------------

@REM Copy Production Files
if exist "%sourcedir%%filename%" (
    echo Copying %sourcedir%%filename% folder...
    xcopy "%sourcedir%%filename%" "%targetDir%\%filename%\"  /Q /Y
    if errorlevel 1 (
        echo Error: Failed to copy Production folder
    ) else (
        echo %sourcedir%%filename% folder copied successfully
    )
) else (
    echo %sourcedir%%filename% folder not found in source directory
)
echo ---------------

echo %targetDir% > "%sourcedir%JobData\folderPath.txt"
echo Wrote target path to JobData\folderPath.txt

echo ---------------
@REM Copy JobData folder
if exist "%sourcedir%JobData" (
    echo Copying JobData folder...
    xcopy "%sourcedir%JobData" "%targetDir%\JobData\"  /Q /Y
    if errorlevel 1 (
        echo Error: Failed to copy JobData folder
    ) else (
        echo %sourcedir%%filename% folder copied successfully
    )
) else (
    echo %sourcedir%%filename% folder not found in source directory
)
echo ---------------

@REM Copy .txt and .rpt files from the source folder
echo Copying .txt and .rpt files...
for %%F in ("%sourcedir%*.txt" "%sourcedir%*.rpt") do (
    echo Copying: %%F
    xcopy "%%F" "%targetDir%\JobData\"  /Q /Y
    if errorlevel 1 (
        echo Error: Failed to copy %%F
    )
)

:: Check if designer is cadmatic
if /i "%designer%"=="cadmatic" (
    echo Designer is cadmatic - skipping folder opening
) else (
    start "Folder" "%targetDir%"
)
