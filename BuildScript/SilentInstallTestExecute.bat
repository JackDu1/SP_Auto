C:\Components\TestExecute\setup.exe /z"-silentmode"
ping /n 10 127.0.0.1 > nul

:waitstop
	ping /n 2 127.0.0.1 > nul
	tasklist /v /fi "WINDOWTITLE eq SmartBear TestExecute*" |findstr /C:"INFO: No tasks" > nul || goto :waitstop