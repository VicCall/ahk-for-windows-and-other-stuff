#SingleInstance, Force
SendMode Input
SetWorkingDir, C:\AHK\2nd-keyboard\support_files


;= audio mono maker

;Plan
;Buttons Functions
;F1 File Explorer    v
;f2 Edge    v
;F3 Premiere Pro    v
;F4 GOM             v

;F5 preset() v
;F6 preset() v
;F7 Preset v
;F8 Preset v

;F9
;F10
;F11
;F12 

;- 
;= audio mono maker V

;Ins/1 Cut at cursor
;End/2 Ripple delete clip at playhead
;PgUp/3 Delete single clip at cursor
;PgDn/4

F1::switchToExplorer()
F2::switchToEdge()
F3::switchToPremiere()
F4::switchToGom()

#IfWinActive ahk_exe Adobe Premiere Pro.exe
F5::preset_1("WS-basic")
F6::preset("LC-1")
F7::preset("LC-2")
F8::preset("LC-3")
=::audioMonoMaker("right")
End::RDCAP()    ;Ripple delete clip at playhead
Ins::CAC()      ; Cut at cutsor
PgUp::SCAC()    ; delete single clip at playhead

#Include C:\AHK\2nd-keyboard\AHK_PP.ahk
#Include C:\AHK\2nd-keyboard\Both_Accelerated_Scrolling_1.3_AND_Cursor_click_visualizer-100UI.ahk
#Include C:\AHK\2nd-keyboard\PREMIERE_MOD_Right_click_timeline_to_move_playhead.ahk
#Include C:\AHK\2nd-keyboard\YES_DELETE_EXISTING_KEYFRAMES.ahk
#Include C:\AHK\2nd-keyboard\AudioMonoMaker.ahk
#Include C:\AHK\2nd-keyboard\Application_switcher.ahk
#Include C:\AHK\2nd-keyboard\presets_pp.ahk

