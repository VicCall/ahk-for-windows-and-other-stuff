Menu, Tray, Icon, shell32.dll, 100 ;changes the icon to a little clicking hand

#singleinstance force
#MaxHotkeysPerInterval 2000


; HOT TEXT bug FIX #############################################


;ORIGINAL BUG REPORT THREAD ON ADOBE FORUMS, WITH DanielOvrutskiy's SOLUTION: https://forums.adobe.com/message/6258808#6258808

;DanielOvrutskiy's code is below, was taken from here: https://pastebin.com/aUPjqnkL

;I do not yet know if this code might interfere with other left-click functions in Premiere. I'll keep running the script on my own machine to test for any possible problems.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;F12::DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 11, UInt, 0)


;this might be better and simpler. just use a different mouse default when Premiere is the active window.
; https://autohotkey.com/board/topic/118644-run-the-script-if-window-become-active/
Loop
{
WinWaitActive, ahk_exe Adobe Premiere Pro.exe

DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 11, UInt, 0) ;0x71 will 
settimer, meowzers, -250

WinWaitNotActive, ahk_exe Adobe Premiere Pro.exe
; DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UInt, MOUSE_NOW, UInt, 0)
; If MOUSE_NOW != 10 ; Check if the speed is not default, adjust this as needed.
    ; DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 10, UInt, 0) ; Default Windows 6 Ticks [10], adjust this as needed.
; tooltip, deactivated
;so like, you can set it back to 10 for the rest of the computer... but then the mouse will be faster in Premiere all the time, and slower for all other programs. It's just dumb. So just use speed 11 at all times!!
;VERY IMPORTANT NOTE:
;Mouse properties > Pointer Options > select a pointer speed
;IS the same thing. "11" refers to position #6 on there. yeah.

; DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UInt, MOUSE_NOW, UInt, 0) ; 0x70 will CHECK the value. i guess?

; tooltip, mouse_now is %MOUSE_NOW%

DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 11, UInt, 0)
settimer, meowzers, -50
sleep 10
}


return



meowzers:
;we have to use a timer, beacuse at lease Premiere and after effects seem to RESET that number to "10" every time you activate the program. So the timer gets around this.
DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 11, UInt, 0) ; Slightly Faster then Windows default
sleep 200
DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 11, UInt, 0) ; Slightly Faster then Windows default
return