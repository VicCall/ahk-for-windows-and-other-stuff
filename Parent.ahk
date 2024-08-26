#SingleInstance, Force
SendMode Input
SetWorkingDir, C:\AHK\2nd-keyboard\support_files

;#ifwinactive ahk_class Chrome_WidgetWin_1
;^r::
;send ^s
;sleep 10
;Soundbeep, 1000, 500
;Reload
;Return


F1::switchToExplorer()
F2::switchToEdge()
F3::switchToPremiere()
F4::switchToGom()
+F1::switchToNotion()
+F2::switchToOneNote()
+F3::switchToPureRef()
+F4::switchToSpotify()
+F5::switchToVSCode()

+F9::openWrk()
+F10::openDownload()

!1::switchToPS()
!2::switchToAE()
!3::switchToLR()
!4::switchToAI()

#IfWinActive ahk_exe Adobe Premiere Pro.exe
{
F9::preset_1("WSDetail")
F10::preset("LC-1")
F11::preset("LC-2")
F12::preset("LC-3")
=::audioMonoMaker("right")
-::addGain(amount := 7)
End::RDCAP()  ;Ripple delete clip at playhead
XButton2::CAC()      ; Cut at cutsor
PgUp::SCAC()    ; delete single clip at playhead
; normal version
;F6::RDCAP()
;F5::CAC() 
;F7::SCAC()
F7::
global VFXkey = "F7"
instantVFX("scale")
return  

F8::
global VFXkey = "F8" ;the VFXkey variable has to be defined NOW. IDK why.
instantVFX("rotation")
return

F5::
global VFXkey = "F5"
instantVFX("position")
return

F6::
global VFXkey = "F6"
instantVFX("position_vertical")
return
}


#Include C:\AHK\2nd-keyboard\Hot_text_PP_Fix.ahk
#Include C:\AHK\2nd-keyboard\AHK_PP.ahk
#Include C:\AHK\2nd-keyboard\AudioMonoMaker.ahk
#Include C:\AHK\2nd-keyboard\Windows\Application_switcher.ahk
#Include C:\AHK\2nd-keyboard\presets_pp.ahk
#Include C:\AHK\2nd-keyboard\Windows\Spotify.ahk
;#Include C:\AHK\2nd-keyboard\Both_Accelerated_Scrolling_1.3_AND_Cursor_click_visualizer-100UI.ahk
;#Include C:\AHK\2nd-keyboard\PREMIERE_MOD_Right_click_timeline_to_move_playhead.ahk
;#Include C:\AHK\2nd-keyboard\YES_DELETE_EXISTING_KEYFRAMES.ahk