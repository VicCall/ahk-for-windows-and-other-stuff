Menu, Tray, Icon, shell32.dll, 283 ;tray icon is now a little keyboard, or piece of paper or something

;script reloader, but it only worKs on this one :(
#ifwinactive ahk_class Chrome_WidgetWin_1
^r::
send ^s
sleep 10
Soundbeep, 1000, 500
Reload
Return

;Buttons Functions
;F1 Ripple delet clip at playhead
;f2 Cut at cursor
;F4 Preset
;F3 Delet single clip at cursor

;#####Ripple delete clip at playhead
#IfWinActive ahk_exe Adobe Premiere Pro.exe
;Ripple delete clip at playhead!! This was the first AHK script I ever wrote, I think!

RDCAP(){
Send ^!s ;ctrl alt s  is assigned to [select clip at playhead]
sleep 1
Send ^+!z ;ctrl alt shift z  is [ripple delete]
sleep 1
return	
}


;##### instant cut at cursor (UPON KEY RELEASE) 
;#IfWinActive ahk_exe Adobe Premiere Pro.exe
;; instant cut at cursor (UPON KEY RELEASE) -- super useful! even respects snapping!
;note to self, move this to premiere_functions already
;this is NOT suposed to stop the video playing when you use it, but now it does for some reason....
CAC(){
send, b ;This is my Premiere shortcut for the RAZOR tool. You can use another shortcut if you like, but you have to use that shortcut here.
send, {shift down} ;makes the blade tool affect all (unlocked) tracks
keywait, Ins ;waits for the key to go UP.
send, {lbutton} ;makes a CUT
send, {shift up}
sleep 10
send, v ;This is my Premiere shortcut for the SELECTION tool. again, you can use whatever shortcut you like.
return
}
;;the code below turned out to not be necessary.
; F2 Up::
; ;tooltip, 
; send, {lbutton}
; send, {shift up}
; sleep 10
; send, v ;selection tool
; return


;#####DELETE SINGLE CLIP AT CURSOR
SCAC(){
prFocus("timeline") ;This will bring focus to the timeline. ; you can't just send ^+!3 because it'll change the sequence if you alkready have the timeline in focus. You have to go to the effect controls first. That is what this function does.


send, ^!d ;ctrl alt d is my Premiere shortcut for DESELECT. This shortcut only works if the timeline is in focus, which is why we did that on the previous line!! And you need to deselect all the timeline clips becuase otherwise, those clips will also get deleted later. I think.
send, v ;This is my Premiere shortcut for the SELECTION tool.
send, {alt down}
send, {lbutton}
send, {alt up}
send, c ;I have C assigned to "CLEAR" in Premiere's shortcuts panel.
return
}
prFocus(panel)
{
;READ ALL THE COMMENTS BELOW OR SUFFER THE CONSEQUENCES.

;PrFocus() allows you to have ONE place where you define your personal shortcuts to "focus" panels in Premiere. It also ensures that panels actually get into focus, and don't rotate through the sequences or anything like that.

; THERE IS A FULL VIDEO TUTORIAL THAT TEACHES YOU HOW TO USE THIS, STEP BY STEP.
; [[[[[LINK TBD, IT'S NOT FINISHED JUST YET.]]]]]

;For this function to work, you MUST Go to Premiere's Keyboard Shortcuts panel, and add the following keyboard shortcuts to the following commands:

; KEYBOARD SHORTCUT     PREMIERE COMMAND
; ctrl alt shift 3 .....Application > Window > Timeline (The default is shift 3)
; ctrl alt shift 1 .....Application > Window > Project  (Sets the focus onto a BIN.) (the default is SHIFT 1)
; ctrl alt shift 4 .....Application > Window > Program Monitor (Default is SHIFT 4)
; ctrl alt shift 5 .....Application > Window > Effect Controls (Default is SHIFT 5)
; ctrl alt shift 7 .....Application > Window > Effects  (NOT the Effect Controls panel!) (Default is SHIFT 7)

;(Note that ALL_MULTIPLE_KEYBOARD_ASSIGNMENTS.ahk has the FULL list of keyboard shortcuts that you need to assign in order for my other functions to work.)


;EXPLANATION: In Premiere, panel focus is very important. Many shortucts will only work if a specific panel is in focus. That is why those panels must be put into focus FIRST, which is what I built PrFocus() to do. (It's not always as simple as sending just the one keyboard shortcut to activate that panel.)

;Right now, we do NOT know which panel is in focus, (or "active.") and AHK has no way to tell (that I know of.)
;If a panel is ALREADY in focus, and you send the shortcut to bring it into focus again, that panel might then switch to a different sequence in the case of the timeline or program monitor,, or a different item in the case of the Source panel. IT's a nightmare!

;Therefore, we must start with a clean slate. For that, I chose the EFFECTS panel. Sending its focus shortcut multiple times, has no ill effects.

Sendinput, ^!+7 ;bring focus to the effects panel... OR, if any panel had been maximized (using the `~ key by default) this will unmaximize that panel, but sadly, that panel will still be the one in focus.
;Note that if the effects panel is ALREADY maximized, then sending the shortcut to switch to it will NOT un-maximize it. This is OK, though, because I never maximize the Effects Panel. If you do, then you might want to switch to the Effect Controls panel first, and THEN the Effects panel after this line.
;note that sometimes I use ^+! instead... it makes no difference compared to ^!+

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



