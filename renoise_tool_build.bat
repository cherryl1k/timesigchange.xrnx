@echo off
set directory=src
set output=com.timesigchange

:: Remove previous files if they exist
if exist %output%.xrnx del %output%.xrnx
if exist %output%.zip del %output%.zip

:: Compress src's content directly into a .zip
cd %directory%
tar -a --options compression-level=0 -c -f ../%output%.zip *
cd ..

:: Rename .zip to .xrnx
rename %output%.zip %output%.xrnx

echo Done! %output%.xrnx has been created, replacing any previous files.
pause