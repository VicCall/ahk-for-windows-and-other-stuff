﻿#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


;#####FUNCTION FOR DIRECTLY APPLYING A PRESET EFFECT TO A CLIP!******
; preset() is my most used, and most useful AHK function for Premiere Pro!




preset(item)
{
keywait, %A_PriorHotKey% 

;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
; https://www.autohotkey.com/docs/commands/CoordMode.htm
coordmode, pixel, Window
coordmode, mouse, Window
coordmode, Caret, Window

;This (temporarily) blocks the mouse and keyboard from sending any information, which could interfere with the funcitoning of the script.
BlockInput, SendAndMouse
BlockInput, MouseMove
BlockInput, On
;The mouse will be unfrozen at the end of this function. Note that if you do get stuck while debugging this or any other function, CTRL SHIFT ESC will allow you to regain control of the mouse. You can then end the AHK script from the Task Manager.

SetKeyDelay, 0 ;NO DELAY BETWEEN STUFF sent using the "send"command! I thought it might actually be best to put this at "1," but using "0" seems to work perfectly fine.
; https://www.autohotkey.com/docs/commands/SetKeyDelay.htm


Sendinput, ^!+k ;in Premiere's shortcuts panel, ASSIGN "shuttle stop" to CTRL ALT SHIFT K.
sleep 10
Sendinput, ^!+k ; another shortcut for Shuttle Stop. Sometimes, just one is not enough.
;so if the video is playing, this will stop it. Othewise, it can mess up the script.
sleep 5

;msgbox, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
;;This was my debugging to check if there are lingering variables from last time the script was run. You do not need that line.

MouseGetPos, xposP, yposP ;------------------stores the cursor's current coordinates at X%xposP% Y%yposP%
;KEEP IN MIND that this function should only be called when your cursor is hovering over a clip, or a group of selected clips, on the timeline. That's because the cursor will be returned to that exact location, carrying the desired preset, which it will drop there. MEANING, that this function won't work if you select clips, but don't have the cursor hovering over them.

sendinput, {mButton} ;this will MIDDLE CLICK to bring focus to the panel underneath the cursor (which must be the timeline). I forget exactly why, but if you create a nest, and immediately try to apply a preset to it, it doesn't work, because the timeline wasn't in focus...? Or something. IDK.
sleep 5

;prFocus("effects") ;Brings focus to the effects panel. You must find, then copy/paste the prFocus() function definition into your own .ahk script as well. ALTERNATIVELY, if you don't want to do that, you can delete this line, and "comment in" the 3 lines below:

;
Sendinput, ^+!7 ;CTRL SHIFT ALT 7 --- In Premiere's Keyboard Shortcuts panel, you nust find the "Effects" panel and assign the shortcut CTRL SHIFT ALT 7 to it. (The default shortcut is SHIFT 7. Because Premiere does allow multiple shortcuts per command, you can keep SHIFT 7 as well, or you can delete it. I have deleted it.)
;sleep 12
;Sendinput, ^!+7 ;you must send this shortcut again, because there are some edge cases where it may not have worked the first time.

sleep 15 ;"sleep" means the script will wait for 15 milliseconds before the next command. This is done to give Premiere some time to load its own things.

Sendinput, ^b ;"select find box"
sleep 5

;The Effects panel's find box should now be activated.
;If there is text contained inside, it has now been highlighted. There is also a blinking vertical line at the end of any text, which is called the "text insertion point", or "caret".

if (A_CaretX = "")
{
;No Caret (blinking vertical line) can be found.

;The following loop is waiting until it sees the caret. THIS IS SUPER IMPORTANT, because Premiere is sometimes quite slow to actually select the find box, and if the function tries to proceed before that has happened, it will fail. This would happen to me about 10% of the time.
;Using the loop is also way better than just ALWAYS waiting 60 milliseconds like I was before. With the loop, this function can continue as soon as Premiere is ready.

;sleep 60 ;<—Use this line if you don't want to use the loop below. But the loop should work perfectly fine as-is, without any modification from you.

waiting2 = 0
loop
	{
	waiting2 ++
	sleep 33
	tooltip, counter = (%waiting2% * 33)`nCaret = %A_CaretX%
	if (A_CaretX <> "")
		{
		tooltip, CARET WAS FOUND
		break
		}
	if (waiting2 > 40)
		{
		tooltip, FAIL - no caret found. `nIf your cursor will not move`, hit the button to call the preset() function again.`nTo remove this tooltip`, refresh the script using its icon in the taskbar.`n`nIt's possible Premiere tried to AUTOSAVE at just the wrong moment!
		;Note to self, need much better way to debug this than screwing the user. As it stands, that tooltip will stay there forever.
		;USER: Running the function again, or reloading the script, will remove that tooltip.
		;sleep 200
		;tooltip,
		sleep 20
		GOTO theEnding
		}
	}
sleep 1
tooltip,
}
;The loop has now ended.
;yeah, I've seen this go all the way up to "8," which is 264 milliseconds

MouseMove, %A_CaretX%, %A_CaretY%, 0 ;this moves the cursor, instantly, to the position of the caret.
sleep 5 ;waiting while Windows does this. Just in case it takes longer than 0 milliseconds.
;;;and fortunately, AHK knows the exact X and Y position of this caret. So therefore, we can find the effects panel find box, no matter what monitor it is on, with 100% consistency!

;tooltip, 1 - mouse should be on the caret X= %A_CaretX% Y= %A_CaretY% now ;;this debugging line was super helpful in me solving this one! Connent this line in if you want to use it, but comment it out after you've gotten the whole function working.

;;;msgbox, caret X Y is %A_CaretX%, %A_CaretY%

MouseGetPos, , , Window, classNN
WinGetClass, class, ahk_id %Window%

;tooltip, 2 - ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%

;;;note to self, I think ControlGetPos is not affected by coordmode??  Or at least, it gave me the wrong coordinates if premiere is not fullscreened... IDK. https://autohotkey.com/docs/commands/ControlGetPos.htm

ControlGetPos, XX, YY, Width, Height, %classNN%, ahk_class %class%, SubWindow, SubWindow 

;note to self, I tried to exclude subwindows but I don't think it works...?
;;my results:  59, 1229, 252, 21,     Edit1,     ahk_class Premiere Pro
;tooltip, classNN = %classNN%

;;Now we have found a lot of useful information about this find box. Turns out, we don't need most of it...
;;we just need the X and Y coordinates of the "upper left" corner...

;;Comment in the following line to get a message box of your current variable values. The script will not advance until you dismiss a message box. (Use the enter key.)
;MsgBox, xx=%XX% yy=%YY%

;; https://www.autohotkey.com/docs/commands/MouseMove.htm

;MouseMove, XX-25, YY+10, 0 ;--------------------for 150% UI scaling, this moves the cursor onto the magnifying glass
MouseMove, XX-15, YY+8, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass

;msgbox, should be in the center of the magnifying glass now. ;;<--comment this in for help with debugging.

sleep 5

Sendinput, %item%
;This types in the text you wanted to search for, like "crop 50". We can do this because the entire find box (and any included text) was already selected.
;Premiere will now display your preset at the top of the list. There is no need to press "enter" to search.


sleep 5

;MouseMove, 62, 95, 0, R ;----------------------(for 150% UI.)
MouseMove, 41, 63, 0, R ;----------------------(for 100% UI)
;;relative to the position of the magnifying glass (established earlier,) this moves the cursor down and directly onto the preset's icon.

;;In my case, all of my presets are contained inside of folders, which themselves are inside the "presets" folder. Your preset's written name should be completely unique so that it is the first and only item.

;msgbox, The cursor should be directly on top of the preset's icon. `n If not, the script needs modification.

sleep 5


;;At this point in the function, I used to use the line "MouseClickDrag, Left, , , %xposP%, %yposP%, 0" to drag the preset back onto the clip on the timeline. HOWEVER, because of a Premiere bug (which may or may not still exist) involving the duplicated displaying of single presets (in the wrong positions) I have to click on the Effects panel AGAIN, which will "fix" it, bringing it back to normal.
;+++++++ If this bug is ever resolved, then the lines BELOW are no longer necessary.+++++
MouseGetPos, iconX, iconY, Window, classNN ;---now we have to figure out the ahk_class of the current panel we are on. It might be "DroverLord - Window Class14", but the number changes anytime you move panels around... so i must always obtain the information anew.
sleep 5
WinGetClass, class, ahk_id %Window% ;----------"ahk_id %Window%" is important for SOME REASON. if you delete it, this doesn't work.
;tooltip, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
;sleep 50
ControlGetPos, xxx, yyy, www, hhh, %classNN%, ahk_class %class%, SubWindow, SubWindow ;;-I tried to exclude subwindows but I don't think it works...?
MouseMove, www/4, hhh/2, 0, R ;-----------------moves to roughly the CENTER of the Effects panel. Clicking here will clear the displayed presets from any duplication errors. VERY important. Without this, the script fails 20% of the time. This is also where the script can go wrong, by trying to do this on the timeline, meaning it didn't get the Effects panel window information as it should have.
sleep 5
MouseClick, left, , , 1 ;-----------------------the actual click
sleep 5
MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the preset's icon
;tooltip, should be back on the preset's icon
sleep 5
;;+++++If this bug is ever resolved, then the lines ABOVE are no longer necessary.++++++


MouseClickDrag, Left, , , %xposP%, %yposP%, 0 ;---clicks the left button down, drags this effect to the cursor's pervious coordinates and releases the left mouse button, which should be above a clip, on the TIMELINE panel.
sleep 5
MouseClick, middle, , , 1 ;this returns focus to the panel the cursor is hovering above, WITHOUT selecting anything. great! And now timeline shortcuts like JKL will work.

blockinput, MouseMoveOff ;returning mouse movement ability
BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL ALT DELETE will still work if you get stuck!! Cool.

;;----remove the code below if it makes no sense to you.----
IfInString, item, CROP
	{
	if IsFunc("cropClick") ;This checks to see if you have a function named "cropClick"
		{
		Func := Func("cropClick")
		sleep 320 ;because it might take awhile to appear in Premiere,  and I'm not gonna do another loop think liek I did above...
		RetVal := Func.Call() 
		}
	;;If you don't have cropClick, then nothing happens. That's good!
	
	;;This code below is what I had used before, but it will complain that you haven't defined the function "cropClick", whereas, the code above will NOT!
	;sleep 320
	;cropClick()
	;;msgbox, that had "CROP" in it.
	}
;;----remove the code above if it makes no sense to you----
;The line below is where all those GOTOs are going to.
theEnding:
}
;END of preset(). The two lines above this one are super important.



;====================PRESET==================


preset_1(item)
{
keywait, %A_PriorHotKey% ;keywait is quite important.
;Let's pretend that you called this function using the following line:
;F4::preset("crop 50")
;In that case, F4 is the prior hotkey, and the script will WAIT until F4 has been physically RELEASED (up) before it will continue. 
;https://www.autohotkey.com/docs/commands/KeyWait.htm
;Using keywait is probably WAY cleaner than allowing the physical key UP event to just happen WHENEVER during the following function, which can disrupt commands like sendinput, and cause cross-talk with modifier keys.


;;---------You do not need the stuff BELOW this line.--------------

sendinput, {blind}{SC0EC} ;for debugging. YOU DO NOT NEED THIS.
;Keyshower(item,"preset") ;YOU DO NOT NEED THIS. -- it simply displays keystrokes on the screen for the sake of tutorials...
; if IsFunc("Keyshower")
	; {
	; Func := Func("Keyshower")
	; RetVal := Func.Call(item,"preset") 
	; }
ifWinNotActive ahk_exe Adobe Premiere Pro.exe ;the exe is more reliable than the class, since it will work even if you're not on the primary Premiere window.
	{
	goto theEnding_1 ;and this line is here just in case the function is called while not inside premiere. In my case, this is because of my secondary keyboards, which aren't usually using #ifwinactive in addition to #if getKeyState(whatever). Don't worry about it.
	}
;;---------You do not need the stuff ABOVE this line.--------------


;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
; https://www.autohotkey.com/docs/commands/CoordMode.htm
coordmode, pixel, Window
coordmode, mouse, Window
coordmode, Caret, Window

;This (temporarily) blocks the mouse and keyboard from sending any information, which could interfere with the funcitoning of the script.
BlockInput, SendAndMouse
BlockInput, MouseMove
BlockInput, On
;The mouse will be unfrozen at the end of this function. Note that if you do get stuck while debugging this or any other function, CTRL SHIFT ESC will allow you to regain control of the mouse. You can then end the AHK script from the Task Manager.

SetKeyDelay, 0 ;NO DELAY BETWEEN STUFF sent using the "send"command! I thought it might actually be best to put this at "1," but using "0" seems to work perfectly fine.
; https://www.autohotkey.com/docs/commands/SetKeyDelay.htm


Sendinput, ^!+k ;in Premiere's shortcuts panel, ASSIGN "shuttle stop" to CTRL ALT SHIFT K.
sleep 10
Sendinput, ^!+k ; another shortcut for Shuttle Stop. Sometimes, just one is not enough.
;so if the video is playing, this will stop it. Othewise, it can mess up the script.
sleep 5

;msgbox, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
;;This was my debugging to check if there are lingering variables from last time the script was run. You do not need that line.

MouseGetPos, xposP, yposP ;------------------stores the cursor's current coordinates at X%xposP% Y%yposP%
;KEEP IN MIND that this function should only be called when your cursor is hovering over a clip, or a group of selected clips, on the timeline. That's because the cursor will be returned to that exact location, carrying the desired preset, which it will drop there. MEANING, that this function won't work if you select clips, but don't have the cursor hovering over them.

sendinput, {mButton} ;this will MIDDLE CLICK to bring focus to the panel underneath the cursor (which must be the timeline). I forget exactly why, but if you create a nest, and immediately try to apply a preset to it, it doesn't work, because the timeline wasn't in focus...? Or something. IDK.
sleep 5

;prFocus("effects") ;Brings focus to the effects panel. You must find, then copy/paste the prFocus() function definition into your own .ahk script as well. ALTERNATIVELY, if you don't want to do that, you can delete this line, and "comment in" the 3 lines below:

;
Sendinput, ^+!7 ;CTRL SHIFT ALT 7 --- In Premiere's Keyboard Shortcuts panel, you nust find the "Effects" panel and assign the shortcut CTRL SHIFT ALT 7 to it. (The default shortcut is SHIFT 7. Because Premiere does allow multiple shortcuts per command, you can keep SHIFT 7 as well, or you can delete it. I have deleted it.)
;sleep 12
;Sendinput, ^!+7 ;you must send this shortcut again, because there are some edge cases where it may not have worked the first time.

sendinput, {blind}{SC0EC} ;for debugging. YOU DO NOT NEED THIS LINE.

sleep 15 ;"sleep" means the script will wait for 15 milliseconds before the next command. This is done to give Premiere some time to load its own things.

Sendinput, ^b ;CTRL B ------- set in premiere's shortcuts panel to "select find box"
sleep 5
;Alternatively, it also works to click on the magnifying glass if you wish to select the find box... but this is unnecessary and sloppy.

;The Effects panel's find box should now be activated.
;If there is text contained inside, it has now been highlighted. There is also a blinking vertical line at the end of any text, which is called the "text insertion point", or "caret".

if (A_CaretX = "")
{
;No Caret (blinking vertical line) can be found.

;The following loop is waiting until it sees the caret. THIS IS SUPER IMPORTANT, because Premiere is sometimes quite slow to actually select the find box, and if the function tries to proceed before that has happened, it will fail. This would happen to me about 10% of the time.
;Using the loop is also way better than just ALWAYS waiting 60 milliseconds like I was before. With the loop, this function can continue as soon as Premiere is ready.

;sleep 60 ;<—Use this line if you don't want to use the loop below. But the loop should work perfectly fine as-is, without any modification from you.

waiting2 = 0
loop
	{
	waiting2 ++
	sleep 33
	tooltip, counter = (%waiting2% * 33)`nCaret = %A_CaretX%
	if (A_CaretX <> "")
		{
		tooltip, CARET WAS FOUND
		break
		}
	if (waiting2 > 40)
		{
		tooltip, FAIL - no caret found. `nIf your cursor will not move`, hit the button to call the preset_1() function again.`nTo remove this tooltip`, refresh the script using its icon in the taskbar.`n`nIt's possible Premiere tried to AUTOSAVE at just the wrong moment!
		;Note to self, need much better way to debug this than screwing the user. As it stands, that tooltip will stay there forever.
		;USER: Running the function again, or reloading the script, will remove that tooltip.
		;sleep 200
		;tooltip,
		sleep 20
		GOTO theEnding_1
		}
	}
sleep 1
tooltip,
}
;The loop has now ended.
;yeah, I've seen this go all the way up to "8," which is 264 milliseconds

MouseMove, %A_CaretX%, %A_CaretY%, 0 ;this moves the cursor, instantly, to the position of the caret.
sleep 5 ;waiting while Windows does this. Just in case it takes longer than 0 milliseconds.
;;;and fortunately, AHK knows the exact X and Y position of this caret. So therefore, we can find the effects panel find box, no matter what monitor it is on, with 100% consistency!

;tooltip, 1 - mouse should be on the caret X= %A_CaretX% Y= %A_CaretY% now ;;this debugging line was super helpful in me solving this one! Connent this line in if you want to use it, but comment it out after you've gotten the whole function working.

;;;msgbox, caret X Y is %A_CaretX%, %A_CaretY%

MouseGetPos, , , Window, classNN
WinGetClass, class, ahk_id %Window%

;tooltip, 2 - ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%

;;;note to self, I think ControlGetPos is not affected by coordmode??  Or at least, it gave me the wrong coordinates if premiere is not fullscreened... IDK. https://autohotkey.com/docs/commands/ControlGetPos.htm

ControlGetPos, XX, YY, Width, Height, %classNN%, ahk_class %class%, SubWindow, SubWindow 

;note to self, I tried to exclude subwindows but I don't think it works...?
;;my results:  59, 1229, 252, 21,     Edit1,     ahk_class Premiere Pro
;tooltip, classNN = %classNN%

;;Now we have found a lot of useful information about this find box. Turns out, we don't need most of it...
;;we just need the X and Y coordinates of the "upper left" corner...

;;Comment in the following line to get a message box of your current variable values. The script will not advance until you dismiss a message box. (Use the enter key.)
;MsgBox, xx=%XX% yy=%YY%

;; https://www.autohotkey.com/docs/commands/MouseMove.htm

;MouseMove, XX-25, YY+10, 0 ;--------------------for 150% UI scaling, this moves the cursor onto the magnifying glass
MouseMove, XX-15, YY+8, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass

;msgbox, should be in the center of the magnifying glass now. ;;<--comment this in for help with debugging.

sleep 5

Sendinput, %item%
;This types in the text you wanted to search for, like "crop 50". We can do this because the entire find box (and any included text) was already selected.
;Premiere will now display your preset at the top of the list. There is no need to press "enter" to search.


sleep 5

;MouseMove, 62, 95, 0, R ;----------------------(for 150% UI.)
MouseMove, 41, 63, 0, R ;----------------------(for 100% UI)
;;relative to the position of the magnifying glass (established earlier,) this moves the cursor down and directly onto the preset's icon.

;;In my case, all of my presets are contained inside of folders, which themselves are inside the "presets" folder. Your preset's written name should be completely unique so that it is the first and only item.

;msgbox, The cursor should be directly on top of the preset's icon. `n If not, the script needs modification.

sleep 5


;;At this point in the function, I used to use the line "MouseClickDrag, Left, , , %xposP%, %yposP%, 0" to drag the preset back onto the clip on the timeline. HOWEVER, because of a Premiere bug (which may or may not still exist) involving the duplicated displaying of single presets (in the wrong positions) I have to click on the Effects panel AGAIN, which will "fix" it, bringing it back to normal.
;+++++++ If this bug is ever resolved, then the lines BELOW are no longer necessary.+++++
MouseGetPos, iconX, iconY, Window, classNN ;---now we have to figure out the ahk_class of the current panel we are on. It might be "DroverLord - Window Class14", but the number changes anytime you move panels around... so i must always obtain the information anew.
sleep 5
WinGetClass, class, ahk_id %Window% ;----------"ahk_id %Window%" is important for SOME REASON. if you delete it, this doesn't work.
;tooltip, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
;sleep 50
ControlGetPos, xxx, yyy, www, hhh, %classNN%, ahk_class %class%, SubWindow, SubWindow ;;-I tried to exclude subwindows but I don't think it works...?
MouseMove, www/4, hhh/2, 0, R ;-----------------moves to roughly the CENTER of the Effects panel. Clicking here will clear the displayed presets from any duplication errors. VERY important. Without this, the script fails 20% of the time. This is also where the script can go wrong, by trying to do this on the timeline, meaning it didn't get the Effects panel window information as it should have.
sleep 5
MouseClick, left, , , 1 ;-----------------------the actual click
sleep 5
MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the preset's icon
;tooltip, should be back on the preset's icon
sleep 5
;;+++++If this bug is ever resolved, then the lines ABOVE are no longer necessary.++++++

MouseClickDrag, Left, , , %xposP%, %yposP%, 0 ;---clicks the left button down, drags this effect to the cursor's pervious coordinates and releases the left mouse button, which should be above a clip, on the TIMELINE panel.
sleep 20
{
; The analyze script should be here
;SendInput, 5;CTRL SHIFT ALT 7 --- In Premiere's Keyboard Shortcuts panel,
MouseMove, 63, 105, 0
MouseClick, left, , , 1
; LIKE WTF THIS SINGLE LINE OF CODE SENDING I,O,M AND ONE OTHER KEY, GOOD GOD
sleep 1000

MouseMove, 300, 494, 0
sleep 1000

;MsgBox, where am i
MouseClick, Left, , , 1,
sleep 20
MouseMove, %xposP%, %yposP%, 0
;MsgBox, Should be on timeline
sleep 5
MouseClick, middle, , , 1 ;this returns focus to the panel the cursor is hovering above, WITHOUT selecting anything. great! And now timeline shortcuts like JKL will work.
SendInput, v
}
blockinput, MouseMoveOff ;returning mouse movement ability
BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL ALT DELETE will still work if you get stuck!! Cool.

;;----remove the code below if it makes no sense to you.----
IfInString, item, CROP
	{
	if IsFunc("cropClick") ;This checks to see if you have a function named "cropClick"
		{
		Func := Func("cropClick")
		sleep 320 ;because it might take awhile to appear in Premiere,  and I'm not gonna do another loop think liek I did above...
		RetVal := Func.Call() 
		}
	;;If you don't have cropClick, then nothing happens. That's good!
	
	;;This code below is what I had used before, but it will complain that you haven't defined the function "cropClick", whereas, the code above will NOT!
	;sleep 320
	;cropClick()
	;;msgbox, that had "CROP" in it.
	}
;;----remove the code above if it makes no sense to you----
;The line below is where all those GOTOs are going to.
theEnding_1:
}
;END of preset(). The two lines above this one are super important.




;PRESET SCRIPT FOR WARP STABILLIZER
;
;1 Effect Control - analyze - mouse back to og
