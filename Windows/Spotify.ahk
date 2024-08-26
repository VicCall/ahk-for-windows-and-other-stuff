#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#NoEnv

SendMode Input

;Ctrl & Numpad 4: Previous Track
!a::Media_Prev

;Ctrl & Numpad 6: Next Track
!d::Media_Next

;Ctrl & Numpad 8: Volume Up
!w::SoundSet +3

;Ctrl & Numpad 2: Volume Down
!x::SoundSet -3

;Ctrl & Numpad 5: Play/Pause Track
!s::Media_Play_Pause