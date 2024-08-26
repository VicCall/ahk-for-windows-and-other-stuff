#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



;= EXPLORER########################################
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


;= PREMIERE PRO#################################

switchToPremiere(){
IfWinNotExist, ahk_class Premiere Pro
	{
	;Run, Adobe Premiere Pro.exe
	;Adobe Premiere Pro CC 2017
	Run, D:\Adobe\Adobe Premiere Pro 2023\Adobe Premiere Pro.exe ;if you have more than one version instlaled, you'll have to specify exactly which one you want to open.
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


;= EDGE########################################

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

switchToNotion()
{
IfWinNotExist, ahk_exe Notion.exe
	Run, C:\Users\garel\AppData\Local\Programs\Notion\Notion.exe
if WinActive("ahk_exe Notion.exe")
	SendInput, ^+k
else
	WinActivate ahk_exe Notion.exe
}

switchToOneNote()
{
IfWinNotExist, ahk_exe ONENOTE.exe
	Run, C:\Program Files\Microsoft Office\root\Office16\ONENOTE.exe
if WinActive("ahk_exe ONENOTE.exe")
	SendInput, <#{Up}
else
	WinActivate ahk_exe ONENOTE.exe
}

switchToPureRef()
{
IfWinNotExist, ahk_exe PureRef.exe
	Run, C:\Program Files\PureRef\PureRef.exe
if WinActive("ahk_exe PureRef.exe")
	SendInput, ^+{l}
else
	WinActivate ahk_exe PureRef.exe
}

switchToSpotify()
{
IfWinNotExist, ahk_exe Spotify.exe
	Run, C:\Users\garel\AppData\Roaming\Spotify\Spotify.exe
if WinActive("ahk_exe Spotify.exe")
	WinMinimize
else
	WinActivate ahk_exe Spotify.exe
}

switchToVSCode()
{
IfWinNotExist, ahk_exe Code.exe
	Run, C:\Users\garel\AppData\Local\Programs\Microsoft VS Code\Code.exe
if WinActive("ahk_exe Code.exe")
	WinMinimize
else
	WinActivate ahk_exe Code.exe
}

switchToPS()
{
IfWinNotExist, ahk_exe Photoshop.exe
	Run, D:\Adobe\Adobe Photoshop 2024\Photoshop.exe
if WinActive("ahk_exe Photoshop.exe")
	WinMinimize
else
	WinActivate ahk_exe Photoshop.exe
}

switchToAE()
{
IfWinNotExist, ahk_exe AfterFX.exe
	Run, C:\Program Files\Adobe\Adobe After Effects 2023\Support Files\AfterFX.exe
if WinActive("ahk_exe AfterFX.exe")
	WinMinimize
else
	WinActivate ahk_exe AfterFX.exe
}

switchToAI()
{
IfWinNotExist, ahk_exe Illustrator.exe
	Run, D:\Adobe\Adobe Illustrator 2023\Support Files\Contents\Windows\Illustrator.exe
if WinActive("ahk_exe Illustrator.exe")
	WinMinimize
else
	WinActivate ahk_exe Illustrator.exe
}

switchToLR()
{
IfWinNotExist, ahk_exe Lightroom.exe
	Run, C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe
if WinActive("ahk_exe Lightroom.exe")
	WinMinimize
else
	WinActivate ahk_exe Lightroom.exe
}

openWrk()
{
Run, C:\Folder\Wrk
}

openDownload()
{
Run, C:\Users\garel\Downloads
}