@echo off
:: Get the directory where the batch file is located
set "batchPath=%~dp0"
:: Set the source path relative to the batch file's location
set "source=%batchPath%BlueRing Black.png"
:: Set the destination path
set "destination=%ProgramData%\WISE Software Solutions\VisualCAM 16.9\logos\VisualCAM_Stencils_Blk_Text_Logo_for_Report.png"
:: Check if the source file exists
if not exist "%source%" (
    echo Source file not found.
    echo "%source%"
    exit /b
)
:: Check if the destination file exists and delete if it does
if exist "%destination%" (
    echo Overwriting existing file.
    del "%destination%"
)
:: Copy the file
copy "%source%" "%destination%"