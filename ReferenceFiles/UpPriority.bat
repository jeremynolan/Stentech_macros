@echo off
setlocal enabledelayedexpansion

set "processName=VisualCAM.exe"  @REM Replace with the name of your program
set "newPriority=High"  @REM Priority can be "Idle", "BelowNormal", "Normal", "AboveNormal", "High", or "Realtime"

for /f "tokens=2 delims==" %%i in ('wmic process where "name='!processName!'" get processid /value') do (
    set "pid=%%i"
)

if defined pid (
    wmic process where "processid='!pid!'" call setpriority !newPriority!
    echo Priority of process with ID !pid! changed to !newPriority!.
) else (
    echo Process !processName! not found.
)

endlocal
