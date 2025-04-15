SET PROJECT=tm-scut
SET VERSION=0425
SET EXE=scut.EXE
SET FOLDER=%PROJECT%\%VERSION%

IntuneWinAppUtil.exe -c "..\%FOLDER%" -s "..\%FOLDER%\%EXE%" -o "..\%FOLDER%

copy /Y "..\%PROJECT%\scut.ps1" "..\%FOLDER%"
pause