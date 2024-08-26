SetWorkingDir, C:\AHK\2nd-keyboard\support_files


#IfWinActive ahk_exe Adobe Premiere Pro.exe
;Macro key G11
F7::
global VFXkey = "F7" ;the VFXkey variable has to be defined NOW. IDK why.
instantVFX("anchor_point_vertical")
return

F5::
global VFXkey = "F5" ;the VFXkey variable has to be defined NOW. IDK why.
instantVFX("scale")
return

;;;;;;temporary tooltip maker;;;;;;
Tippy(tipsHere, wait:=-333)
{
ToolTip, %tipsHere% TIP,,,8
SetTimer, noTip, %wait% ;--in 1/3 seconds by default, remove the tooltip
;return
}

;um I am trying this because i think the tooltip was being deleted like every bazillionth of a second?
noTip:
ToolTip,,,,8

clickTransformIcon()
{
ControlGetPos, Xcorner, Ycorner, Width, Height, DroverLord - Window Class3, ahk_class Premiere Pro ;you will need to set this value to the window class of your own Effect Controls panel! Use window spy and hover over it to find that info.

; Xcorner := Xcorner+83 ;150% ui
; Ycorner := Ycorner+98 ;150% ui
Xcorner := Xcorner+56 ;100% ui
Ycorner := Ycorner+66 ;100% ui

MouseMove, Xcorner, Ycorner, 0 ;these numbers should move the cursor to the location of the transform icon. Use the message box below to debug this.
sleep 10 ; just to make sure it gets there, this is done twice.
MouseMove, Xcorner, Ycorner, 0 ;these numbers should move the cursor to the location of the transform icon. Use the message box below to debug this.
;msgbox, the cursor should now be positioned directly over the transform icon. `n Xcorner = %Xcorner% `n Ycorner = %Ycorner%
MouseClick, left
}


;script to lock video and audio layers V1 and A1.
;I don't recommend that anyone else use this. It's really finnicky to set up. Requires a ton of very carefully taken screenshots in order to work...
tracklocker()
{
;sleep 15 ;modifiers?
BlockInput, on
BlockInput, MouseMove
MouseGetPos xPosCursor, yPosCursor

xPos = 400
yPos = 1050 ;the coordinates of roughly where my timeline usually is located on the screen (a 4k screen.)
CoordMode Pixel ;, screen  ; IDK why, but it works like this...
CoordMode Mouse, screen
; CoordMode, mouse, window
; CoordMode, pixel, window
; coordmode, Caret, window
;you might need to take your own screenshot (look at mine to see what is needed) and save as .png. Mine are done with default UI brightness, plus 150% UI scaling in Wondows.
;msgbox, workingDir is %A_WorkingDir%
ImageSearch, FoundX, FoundY, xPos, yPos, xPos+600, yPos+1000, *5 %A_WorkingDir%\v1_ALT_unlocked_targeted_2019_ui100.png
if ErrorLevel = 1
	ImageSearch, FoundX, FoundY, xPos, yPos, xPos+600, yPos+1000, *5 %A_WorkingDir%\v1_unlocked_targeted_2019_ui100.png
; if ErrorLevel = 1
	; ImageSearch, FoundX, FoundY, xPos, yPos, xPos+600, yPos+1000, *5 %A_WorkingDir%\v1_unlocked_untargeted_2018.png
; if ErrorLevel = 1
	; ImageSearch, FoundX, FoundY, xPos, yPos, xPos+600, yPos+1000, *5 %A_WorkingDir%\v1_ALT_unlocked_untargeted_2018.png
if ErrorLevel = 1
	{
	;msgbox, we made it to try 2
    tippy("NO UNLOCK WAS FOUND")
	goto try2
	}
if ErrorLevel = 2
	{
    tippy("Could not conduct the search!")
	goto resetlocker
	}
if ErrorLevel = 0
	{
	;tooltip, The icon was found at %FoundX%x%FoundY%.
	;msgbox, The icon was found at %FoundX%x%FoundY%.
	MouseMove, FoundX+10, FoundY+10, 0
	sleep 5
	click left
	MouseMove, FoundX+10, FoundY+60, 0 ;moves downwards and onto where A1 should be...
	click left ;clicks on Audio track 1 as well.
	sleep 10
	goto resetlocker
	}
	
try2:
tippy("we are now on try 2")
; ImageSearch, FoundX_LOCK, FoundY_LOCK, xPos, yPos, xPos+600, yPos+1000, *2 %A_WorkingDir%\v1_ALT_locked_targeted_2018.1.png

	
if ErrorLevel = 1
	{
    tippy("try 2 part 1")
	ImageSearch, FoundX_LOCK, FoundY_LOCK, xPos, yPos, xPos+600, yPos+1000, *5 %A_WorkingDir%\v1_ALT_locked_targeted_2019_ui100.png
	}
if ErrorLevel = 1
	{
    tippy("ALT LOCKED TARGETED V1 could not be found on the screen")
	ImageSearch, FoundX_LOCK, FoundY_LOCK, xPos, yPos, xPos+600, yPos+1000, *5 %A_WorkingDir%\IDK_2.png
	}
; if ErrorLevel = 1
	; {
    ; tippy("ALT LOCKED TARGETED V1 could not be found on the screen")
	; ImageSearch, FoundX_LOCK, FoundY_LOCK, xPos, yPos, xPos+600, yPos+1000, %A_WorkingDir%\v1_ALT_locked_untargeted.png
	; }
if ErrorLevel = 2
	{
    tippy("Could not conduct search #2")
	goto resetlocker
	}
	
if ErrorLevel = 0
	{
	;tippy("found a locked lock")
	MouseMove, FoundX_LOCK+10, FoundY_LOCK+10, 0
	sleep 5
	click left ;clicks on Video track 1
	MouseMove, FoundX_LOCK+10, FoundY_LOCK+60, 0
	click left ;clicks on Audio track 1 as well.
	sleep 10
	goto resetlocker
	}
;msgbox, , , num enter, 0.5;msgbox, , , num enter, 0.5
resetlocker:
MouseMove, xPosCursor, yPosCursor, 0
blockinput, off
blockinput, MouseMoveOff
sleep 10
}
;End of trackLocker()

prFocus(panel)
{


Sendinput, ^!+7 

sleep 12 ;waiting for Premiere to actaully do the above.

Sendinput, ^!+7 ;Bring focus to the effects panel AGAIN. Just in case some panel somewhere was maximized, THIS will now guarantee that the Effects panel is ACTAULLY in focus.

sleep 5 ;waiting for Premiere to actaully do the above.

sendinput, {blind}{SC0EA} ;scan code of an unassigned key. Used for debugging. You do not need this.

if (panel = "effects")
	goto theEnd ;do nothing. The shortcut has already been sent.
else if (panel = "timeline")
	Sendinput, ^!+3 ;if focus had already been on the timeline, this would have switched to the "next" sequence (in some unpredictable order.)
else if (panel = "program") ;program monitor. If focus had already been here, this would have switched to the "next" sequence.
	Sendinput, ^!+4
else if (panel = "source") ;source monitor. If focus had already been here, this would have switched to the next loaded item.
{
	Sendinput, ^!+2
	;tippy("send ^!+2") ;tippy() was something I used for debugging. you don't need it.
}
else if (panel = "project") ;AKA a "bin" or "folder"
	Sendinput, ^!+1
else if (panel = "effect controls")
	Sendinput, ^!+5

theEnd:
sendinput, {blind}{SC0EB} ;more debugging - you don't need this.
}
;end of prFocus()




instantVFX(foobar)
{
dontrestart = 0
restartPoint:
blockinput, sendandMouse
blockinput, MouseMove
blockinput, on

;fortunately, this whole thing is fast enough that i don't NEED to buffer keypresses. I can just fully block them while we wait. But here's a thread about that:
;https://autohotkey.com/board/topic/59606-input-buffer-during-blockinput/

;-Sendinput ^!+5

;clickTransformIcon()

prFocus("effect controls") ;essentially just hits CTRL ALT SHIFT 5 to highlight the effect controls panel.
sleep 10


; Send {tab}
; if (A_CaretX = "")
; {
	; tooltip, No Caret (blinking vertical line) can be found. Therefore`, no clip is selected.
	; ;Therefore, we try to select the TOP clip at the playhead, using the code below.
	; Send ^p ;"selection follows playhead,"
	; sleep 10
	; Send ^p
; }




;ToolTip, A, , , 2
MouseGetPos Xbeginlol, Ybeginlol
global Xbegin = Xbeginlol
global Ybegin = Ybeginlol
; MsgBox, "please verify that the mouse cannot move"
; sleep 2000
ControlGetPos, Xcorner, Ycorner, Width, Height, DroverLord - Window Class3, ahk_class Premiere Pro ;This is HOPEFULLY the ClassNN of the effect controls panel. Use Window Spy to figure it out.
;I might need a far more robust way of ensuring the effect controls panel has been located, in the future.

;move mouse to expected triangle location. this is a VERY SPECIFIC PIXEL which will be right on the EDGE of the triangle when it is OPEN.
;This takes advantage of the anti-aliasing between the color of the triangle, and that of the background behind it.
;these pixel numbers will be DIFFERENT depending upon the RESOLUTION and UI SCALING of your monitor(s)
; YY := Ycorner+99 ;ui 150%
; XX := Xcorner+19 ;ui 150%
YY := Ycorner+66 ;ui 100%
XX := Xcorner+13 ;ui 100%

MouseMove, XX, YY, 0
sleep 10

PixelGetColor, colorr, XX, YY

; if (colorr = "0x353535") ;for 150% ui
if (colorr = "0x222222") ;for 100% ui
{
	tooltip, color %colorr% means closed triangle. Will click and then SCALE SEARCH
	blockinput, Mouse
	Click XX, YY
	sleep 5
	clickTransformIcon()
	findVFX(foobar)
	Return
}
;else if (colorr = "0x757575") ;for 150% ui. again, this values could be different for everyone. check with window spy. This color simply needs to be different from the color when the triangle is closed. it also cannot be the same as a normal panel color (1d1d1d or 232323)
else if (colorr = "0x7A7A7A") ;for 100% ui
{
	;tooltip, %colorr% means OPENED triangle. SEARCHING FOR SCALE
	blockinput, Mouse
	sleep 5
	clickTransformIcon()
	findVFX(foobar)
	;untwirled = 1
	Return, untwirled
}
else if (colorr = "0x1D1D1D" || colorr = "0x232323")
	{
	;tooltip, this is a normal panel color of 0x1d1d1d or %colorr%, which means NO CLIP has been selected ; assuming you didnt change your UI brightness. so we are going to select the top clip at playhead.
	;I should experiement with putting a "deselect all clips on the timeline" shortcut here...
	Send ^p ;--- i have CTRL P set up to toggle "selection follows playhead," which I never use otherwise. ;this makes it so that only the TOP clip is selected.
	sleep 10
	Send ^p ;this disables "selection follows playhead." I don't know if there is a way to CHECK if it is on or not. 
	resetFromAutoVFX()
	;play noise
	;now you need to do all that again, since the motion menu is now open. But only do it ONCE more! 
	If (dontrestart = 0)
		{
		dontrestart = 1
		goto, restartPoint ;this is stupid but it works. Feel free to improve any of my code.
		}
	Return reset
	}
else
	{
	tooltip, %colorr% not expected
	;play noise
	resetFromAutoVFX()
	Return reset
	}
}
Return ;from autoscaler part 1




findVFX(foobar) ; searches for text inside of the Motion effect. requires an actual image.
{
;tooltip, WTF
;msgbox, now we are in findVFX
sleep 5
MouseGetPos xPos, yPos
;CoordMode Pixel  ; Interprets the coordinates below as relative to the screen rather than the active window.

/*
if foobar = "scale"
	ImageSearch, FoundX, FoundY, xPos-90, yPos, xPos+800, yPos+500, %A_WorkingDir%\scale_D2017.png
else if foobar = "anchor_point"
	ImageSearch, FoundX, FoundY, xPos-90, yPos, xPos+800, yPos+500, %A_WorkingDir%\anchor_point_D2017.png
*/

;ImageSearch, FoundX, FoundY, xPos-90, yPos, xPos+800, yPos+900, %A_WorkingDir%\%foobar%_D2018.png

;something was wrong with using %A_WorkingDir% here. now fixed.

;ImageSearch, FoundX, FoundY, xPos-90, yPos, xPos+800, yPos+900, %A_WorkingDir%\%foobar%_D2019.png
ImageSearch, FoundX, FoundY, xPos-90, yPos, xPos+800, yPos+900, %A_WorkingDir%\%foobar%_D2019_ui100.png
;within 0 shades of variation (this is much faster)
;obviously, you need to take your own screenshot (look at mine to see what is needed) save as .png, and link to it from the line above.
;Again, your UI brightness might be different from mine! I now use the DEFAULT brightness.
; if ErrorLevel = 0
	; msgbox, error 0
if ErrorLevel = 1
	{
	;ImageSearch, FoundX, FoundY, xPos-30, yPos, xPos+1200, yPos+1200, *10 %A_WorkingDir%\%foobar%_D2019.png ;within 10 shades of variation (in case SCALE is fully extended with bezier handles, in which case, the other images are real hard to find because the horizontal seperating lines look a BIT different. But if you crop in really closely, you don't have to worry about this. so this part of the code is not really necessary execpt to expand the range to look.
	;msgbox, whwhwuhuat
	ImageSearch, FoundX, FoundY, xPos-30, yPos, xPos+1200, yPos+1200, *10 %A_WorkingDir%\%foobar%_D2019_ui100.png
	}
if ErrorLevel = 2
	{
    msgbox,,, ERROR LEVEL 2`nCould not conduct the search,1
	resetFromAutoVFX()
	Return
	}
if ErrorLevel = 1
	{
	;msgbox, , , error level 1, .7
    msgbox,,, ERROR LEVEL 1`n%foobar% could not be found on the screeen,1
	resetFromAutoVFX()
	Return
	}
else
	{
	;tooltip, The %foobar% icon was found at %FoundX%x%FoundY%.
	;msgbox, The %foobar% icon was found at %FoundX%x%FoundY%.
	MouseMove, FoundX, FoundY, 0
	;msgbox,,,moved to located text,1
	sleep 5
	findHotText(foobar)
	Return
	}
}


;2d8ceb
findHotText(foobar)
{
tooltip, ; removes any tooltips that might be in the way of the searcher.
; https://www.autohotkey.com/docs/commands/PixelSearch.htm
;CoordMode Pixel
MouseGetPos, xxx, yyy

;msgbox, foobar is %foobar%
if (foobar = "scale" ||  foobar = "anchor_point" ||  foobar = "anchor_point_vertical" || foobar = "rotation")
{
	;msgbox,,,scale or the other 3,1
	;PixelSearch, Px, Py, xxx+50, yyy, xxx+350, yyy+11, 0x3398EE, 30, Fast RGB ;this is searching to the RIGHT, looking the blueness of the scrubbable hot text. Unfortunately, it sees to start looking from right to left, so if your window is sized too small, it'll possibly latch onto the blue of the playhead/CTI.
	PixelSearch, Px, Py, xxx+50, yyy, xxx+250, yyy+11, 0x2d8ceb, 30, Fast RGB
    ;this is searching to the RIGHT, looking the blueness of the scrubbable hot text. Unfortunately, it sees to start looking from right to left, so if your window is sized too small, it'll possibly latch onto the blue of the playhead/CTI. TEchnically, I could check to see the size of the Effect controls panel FIRST, and then allow the number that is currently 250 to be less than half that, but I haven't run into too much trouble so far...
}
else if (foobar = "anchor_point_vertical")
{
	tooltip, 0.00? 
	
	ImageSearch, Px, Py, xxx+50, yyy, xxx+800, yyy+100, *3 %A_WorkingDir%\anti-flicker-filter_000_D2019_ui100.png ;for a user interface at 100%...
	;the *3 allows some minor variation in the searched image.
	if ErrorLevel = 1
		ImageSearch, Px, Py, xxx+50, yyy, xxx+800, yyy+100, *3 %A_WorkingDir%\anti-flicker-filter_000_D2019_2.png
}

; ImageSearch, FoundX, FoundY, xPos-70, yPos, xPos+800, yPos+500, %A_WorkingDir%\anchor_point_D2017.png
; ImageSearch, FoundX, FoundY, xPos-70, yPos, xPos+800, yPos+500, %A_WorkingDir%\anti-flicker-filter_000.png


if ErrorLevel
	{
    ;tooltip, blue not Found
	sleep 100
	resetFromAutoVFX()
	return ;i am not sure if this is needed.
	}
else
	{
	;tooltip, A color within 30 shades of variation was found at X%Px% Y%Py%
	;sleep 1000
    ;MsgBox, A color within 30 shades of variation was found at X%Px% Y%Py%.
	if (foobar <> "anchor_point_vertical" ||  foobar <> "position_vertical")
	{
		
		MouseMove, Px+10, Py+5, 0 ;moves the cursor onto the scrubbable hot text
		;msgbox, anything but anchor point vertical
		;sleep 1000
	}
	else if (foobar = "anchor_point_vertical" ||  foobar = "position_vertical")
	{
		;msgbox,,,, about to move,0.5
		MouseMove, Px+60, Py-0, 0
        ;relative to the unrelated 0.00 text (which I've never changed,) this moves the cursor onto the SECOND variable for the anchor point... the VERTICAL number, rather than horizontal.
		;tooltip, where am I?
		;sleep 2000
	}
	Click down left
	
	GetKeyState, stateFirstCheck, %VFXkey%, P
		
	if stateFirstCheck = U
		{
			;tooltip, you have already released the key.
			;a bit of time has passed by now, so if the user is no longer holding the key down at this point, that means that they pressed it an immediately released it.
			;I am going to take this an an indicaiton that the user just wants to RESET the value, rather than changing it.
			Click up left
			Sleep 10
			;I am removing the clode below, which acts to set specific values automatically, which can be used to "reset" those values. Instead of that, I'm able to type in my own custom value.
			
			; if (foobar = "scale")
			; {
				; Send, 100
				; sleep 50
				; Send, {enter} ;"enter" can be a volatile and dangerous key, since it has so many other potential functions that might interfere somehow... in fact, I crashed the whole program once by using this and the anchor point script in rapid sucesssion.... but "ctrl enter" doesn't work... maybe numpad enter is a safer bet?
				; sleep 20
			; }
			; if (foobar = "rotation")
			; {
				; Send, 0
				; sleep 50
				; Send, {enter} ;"enter" can be a volatile and dangerous key, since it has so many other potential functions that might interfere somehow... in fact, I crashed the whole program once by using this and the anchor point script in rapid sucesssion.... but "ctrl enter" doesn't work... maybe numpad enter is a safer bet?
				; sleep 20
			; }
			resetFromAutoVFX(0) ;zero means, DO NOT click on the timeline to put the focus there.
			return ;this return has to be here, or the function will continue on to the next loop! Agh, I didn't realize that for a long time, dumb!
		}
	;Now we start the official loop, which will continue as long as the user holds down the VFXkey. They can now simply move the mouse to change the value of the hot text which has been automatically selected for them.
	Loop
		{
		blockinput, off
		blockinput, MouseMoveOff
		;tooltip, %VFXkey% Instant %foobar% mod
		tooltip, ;removes any tooltips that might exist.
		sleep 15
		GetKeyState, state, %VFXkey%, P ;since this relies on the PHYSICAL state of the key on the attached keyboard, this and other functions do NOT work if you're using Parsec, Teamviewer, or other remote access software.
		
		;NOW is when the user moves their mouse around to change the value of the hot text. You can also use SHIFT or CTRL to make it change faster or slower. Then release the VFX key to return to normal.
		
		if state = U
			{
			Click up left
			;tooltip, "%VFXkey% is now physically UP so we are exiting now"
			sleep 15
			resetFromAutoVFX(1) ;1 means, DO send a middle click to put focus onto the timeline (or wherever the cursor was.)
			; MouseMove, Xbegin, Ybegin, 0
			; tooltip,
			; ToolTip, , , , 2
			; blockinput, off
			; blockinput, MouseMoveOff
			Return
			}
		}
	}
}

;;;--------------------------------------------------------------------------------------------

resetFromAutoVFX(clicky := 0)
{
	;tooltip, you're in RESET land
	;msgbox,,, is resetting working?,1
	global Xbegin
	global Ybegin
	MouseMove, Xbegin, Ybegin, 0
	;MouseMove, global Xbegin, global Ybegin, 0
	;MouseMove, Xbeginlol, Ybeginlol, 0
	
	if clicky = 1
		{
		;tooltip, WHY
		send, {mbutton} ;sends middle click. This will bring the panel you were hovering over, back into focus. Alternatively, i could do this with a keyboard shortcut that highlights the timeline panel, but that is probably less reliable, for... reasons.
		clicky = 0
		}
	;sleep 10
	blockinput, off
	blockinput, MouseMoveOff
	ToolTip, , , , 2
	SetTimer, noTip, 333
}
