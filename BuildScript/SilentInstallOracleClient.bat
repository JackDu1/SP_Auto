
C:\Components\OracleClient\client\setup.exe -silent -nowelcome -noconfig -ignoreSysPrereqs -showProgress -nowait -responseFile C:\Components\OracleClient\112040_32bit_client.rsp
ping /n 10 127.0.0.1 > nul

:waitstop
	ping /n 2 127.0.0.1 > nul
	tasklist /v /fi "WINDOWTITLE eq Access Bridge status" |findstr /C:"INFO: No tasks" > nul || goto :waitstop