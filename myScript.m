function myScript

fprintf('launching script...\n');

fprintf('launching GUI......\n');

myGui;
hGui = findobj('Tag','tformChoiceGui');
waitfor(hGui);

fprintf('continuing script..\n');


@echo off
set "ZIP=C:\Program Files\7-Zip\7z.exe"
set "ARGS=%*"
setlocal EnableDelayedExpansion
for %%F in (!ARGS!) do (
    endlocal
    dir /A "%%~fF" | > nul 2>&1 findstr "DIR" && (
        "%ZIP%" a -tzip "%%~F.zip" "%%~F\*" -mx0
    ) || (
        "%ZIP%" a -tzip "%%~F.zip" "%%~fF" -mx0
    )
    setlocal
)
endlocal
