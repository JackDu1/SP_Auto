
'===============================================================================
Function ProcessNode(aNode,aGroupName)

	if aNode.haschildnodes then
		for i = 0 to aNode.childnodes.length - 1
			set childlist=anode.childnodes(i)
			for j = 0 to childlist.attributes.length - 1
				if UCase(childlist.attributes.item(j).nodename) = UCase("value") and UCase(childlist.attributes.item(j).nodevalue) = UCase(Trim(aGroupName))then
					'set attribute enabled=-1
					set bothernode=anode.childnodes(i-4)
					call bothernode.setAttribute("value","-1")
					ProcessNode=True
					exit function
				else
					ProcessNode=False
				end if
			next
			Call ProcessNode(childlist,aGroupName)
		Next
	end if
	
End Function

'================================================================================

Sub XMLDriver()
	on error resume next

	Dim XMLDoc
	Dim ErrorMsg
	Dim Position
	Dim ProjectFile
	Dim RunGroupName
	Dim ParentGroup,groupowner,childgroup

	If WScript.Arguments.Count>=2 then
		ProjectFile=Trim(WScript.Arguments(0))
		RunGroupName=Trim(WScript.Arguments(1))
		
		RunGroupNameArray = Split(RunGroupName, ",")
	Else
		wscript.Quit 400
	End If

	set XMLDoc=CreateObject("MSXML2.DOMDOCUMENT")

	XMLDoc.async=False

	XMLDoc.ValidateonParse=True
	'Open project file
	Call XMLDoc.load(ProjectFile)

	If XMLDoc.parseError.errorCode <> 0 Then
		ErrorMsg = "Reason:" + Chr(9) + XMLDoc.parseError.reason + Chr(13) + Chr(10) + _
			"Line:" + Chr(9) + CStr(XMLDoc.parseError.line) + Chr(13) + Chr(10) + _
			"Pos:" + Chr(9) + CStr(XMLDoc.parseError.linePos) + Chr(13) + Chr(10) + _
			"Source:" + Chr(9) + XMLDoc.parseError.srcText
		' Post an error to the log and exit
		Wscript.echo("Cannot parse the document:" + ErrorMsg) 
		wscript.quit 500
	End If

	Set RootNode=XMLDoc.documentElement
	
	'Find a particular element using XPath:
	Set GroupNode=XMLDOC.selectSingleNode("//Nodes/Node/Node/Node[@name='child list']")
	
	'loop to find the specified Node according to the Group Name
	for i = 0 to Ubound(RunGroupNameArray)
		if GroupNode.haschildnodes then
			'find the parent group
			for j = 0 to groupnode.childnodes.length - 1
				Position=InStr(RunGroupNameArray(i),"-")
				parentgroup=Left(Trim(RunGroupNameArray(i)),Position - 2)
				if ProcessNode(GroupNode,parentgroup)=0 then
					'wscript.echo("find the parent group")
					'find the group itself
					groupowner=RunGroupNameArray(i)
					if ProcessNode(GroupNode,groupowner)=0 then
						'wscript.echo("find the group itself")
						'find the child group
						childgroup=Left(Trim(RunGroupNameArray(i)),Position - 2) & "TestItem"
						if ProcessNode(GroupNode,childgroup) =0 then
							'wscript.echo("find the Child group")
							exit for
						end if
					end if
				end if
			next
		else
			exit for
		end if	
	Next
	'Close and save the project file
	XMLDOC.save(ProjectFile)

End Sub

'================================================================================
call XMLDriver()