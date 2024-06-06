
pushd "%~dp0"

set PORT=8448
set MYBOAT=%1
set MODEL=%2

cd NMEA_CACHE
start python ../nmea_cashe2.py --port 8081
cd ..

start /b python DisplayServer.py %PORT% %MYBOAT% %MODEL%

start /b python -m webbrowser -t "http://localhost:%PORT%/chart"

start /b python -m webbrowser -t "http://localhost:%PORT%/view3d"

clips\CLIPSIDE.exe


