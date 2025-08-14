setlocal
echo off

call "Supporting Files\Vcam_ini_cleanup.bat"
call "Supporting Files\CopyPitchTable.bat"
call "ReferenceFiles\replaceVcamLogo.bat"
set "source=%~dp0%"
set "destination=%ProgramData%\WISE Software Solutions\VisualCAM 16.9\macros"

if not exist "%destination%" (
  echo Error: Destination directory does not exist.
  md "%destination%"
)

xcopy /y /d "%source%*.mac" "%destination%\"
@REM xcopy /y /d "%source%*.bat" "%destination%\"
xcopy /y /d "%source%ReferenceFiles" "%destination%\ReferenceFiles\"

echo Files copied successfully to %destination%.