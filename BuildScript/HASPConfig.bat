@echo off
systeminfo|findstr /i /C:"x86-based PC" > nul && set HASP=C:\Program Files\Common Files\Aladdin Shared\HASP
systeminfo|findstr /i /C:"x64-based PC" > nul && set HASP=C:\Program Files (x86)\Common Files\Aladdin Shared\HASP

sc stop hasplms
:waitstop
	ping /n 1 127.0.0.1 > nul
	sc query hasplms |findstr "STOPPED" > nul || goto :waitstop

echo [REMOTE] > "%HASP%\hasplm.ini"
echo serveraddr=10.1.145.11 >> "%HASP%\hasplm.ini"
echo aggressive=1 >> "%HASP%\hasplm.ini"
echo broadcastsearch=0 >> "%HASP%\hasplm.ini"

sc start hasplms
:waitstart
	ping /n 1 127.0.0.1 > nul
	sc query hasplms |findstr "RUNNING" > nul || goto :waitstart
