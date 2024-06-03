
pushd "%~dp0"

set PORT=8448
set MYBOAT=%1
set MODEL=%2

taskkill /f /IM python3.exe

sleep 20s

cd NMEA_CACHE
python3.exe ../nmea_cashe2.py --port 8081 &
cd ..

python3.exe DisplayServer.py %PORT% %MYBOAT% %MODEL%

python3.exe -m webbrowser -t "http://localhost:%PORT%/chart"

python3.exe -m webbrowser -t "http://localhost:%PORT%/view3d"

run_IDE.bat

