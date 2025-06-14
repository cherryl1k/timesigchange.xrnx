@echo off
set directory=src
set output=tool

:: Compress src into tool.zip
tar -a -c -f %output%.zip %directory%

:: Rename tool.zip to tool.xrnx
rename %output%.zip %output%.xrnx

echo Done! %output%.xrnx has been created.
pause
