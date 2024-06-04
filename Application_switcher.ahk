#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



;= EXPLORER
switchToExplorer(){
IfWinNotExist, ahk_class CabinetWClass
	Run, explorer.exe
GroupAdd, vicexplorers, ahk_class CabinetWClass
if WinActive("ahk_exe explorer.exe")
	GroupActivate, vicexplorers, r
else
	WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
}

; ;trying to activate these windows in reverse order from the above. it does not work.
; ^+F2::
; IfWinNotExist, ahk_class CabinetWClass
	; Run, explorer.exe
; GroupAdd, vicexplorers, ahk_class CabinetWClass
; if WinActive("ahk_exe explorer.exe")
	; GroupActivate, vicexplorers ;but NOT most recent.
; else
	; WinActivatebottom ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
; Return

;closes all explorer windows :/
;^!F2 -- for searchability


;`::
;if WinActive("ahk_exe explorer.exe")
;WinMinimize,ahk_group vicexplorers
;Return


;the end


;= PREMIERE PRO

switchToPremiere(){
IfWinNotExist, ahk_class Premiere Pro
	{
	;Run, Adobe Premiere Pro.exe
	;Adobe Premiere Pro CC 2017
	Run, C:\Program Files\Adobe\Adobe Premiere Pro 2022\Adobe Premiere Pro.exe ;if you have more than one version instlaled, you'll have to specify exactly which one you want to open.
	;Run, Adobe Premiere Pro.exe
	}
if WinActive("ahk_class Premiere Pro")
	{
	IfWinNotExist, ahk_exe notepad++.exe
		{
		Run, notepad++.exe
		sleep 200
		}
	WinActivate ahk_exe notepad++.exe ;so I have this here as a workaround to a bug. Sometimes Premeire becomes unresponsive to keyboard input. (especially after timeline scrolling, especially with a playing video.) Switching to any other application and back will solve this problem. So I just hit the premiere button again, in those cases.g
	sleep 10
	WinActivate ahk_class Premiere Pro
	}
else
	WinActivate ahk_class Premiere Pro
}

;THE END


;= EDGE

switchToEdge()
{
IfWinNotExist, ahk_exe msedge.exe
	Run, C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
if WinActive("ahk_exe msedge.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe msedge.exe
}



switchToGom()
{
IfWinNotExist, ahk_exe gom64.exe
	Run, C:\Program Files\GRETECH\GOMPlayerPlus\gom64.exe
if WinActive("ahk_exe gom64.exe")
	Sendinput {Enter}
else
	WinActivate ahk_exe gom64.exe
}


!F1::
{
Run, C:\Folder\Wrk
}