
pushd "%~dp0"

set PORT=8448
set MYBOAT=%1
set MODEL=%2

cd NMEA_CACHE
python3 ../nmea_cashe2.py --port 8081 &
cd ..

python3 DisplayServer.py %PORT% %MYBOAT% %MODEL%

python3 -m webbrowser -t "http://localhost:%PORT%/chart"

python3 -m webbrowser -t "http://localhost:%PORT%/view3d"

run_IDE.bat

