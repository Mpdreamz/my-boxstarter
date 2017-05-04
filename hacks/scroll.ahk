#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

   wheelingSensitivity := 100 ; sensitivity to mouse movement (higher is more sensitive)
   wheelingPeriod := 10 ; timer period
return


~Capslock & r:: GoSub StartWheeling
~*r Up:: 		GoSub StopWheeling

WatchCursor:
	MouseGetPos, wheelingNewMouseX, wheelingNewMouseY
	
	taps := Round((wheelingNewMouseX - wheelingMouseX)/wheelingSensitivity)
	clicks := Round((wheelingNewMouseY - wheelingMouseY)/wheelingSensitivity)
	
	MouseMove wheelingMouseX, wheelingMouseY

	if clicks > 0
		MouseClick WheelDown,,,abs(clicks)
	else if clicks < 0
		MouseClick WheelUp,,,abs(clicks)
		
	if taps > 0
		SendInput % "{Right "abs(taps)"}"
	else if taps < 0
		SendInput % "{Left "abs(taps)"}"
return

StartWheeling:
	SystemCursor("OFF")
	MouseGetPos, wheelingMouseX, wheelingMouseY
	SetTimer WatchCursor, %wheelingPeriod%
return

StopWheeling:
	SetTimer WatchCursor, Off
	SystemCursor("ON")
return
;===============================================================================================================================================================
; from the AHK documentation...
SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
    {
        $ = h                                          ; active default cursors
        VarSetCapacity( h_cursor,4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
            h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
            b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0
                , "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )
        }
    }
    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ = b  ; use blank cursors
    else
        $ = h  ; use the saved cursors

    Loop %c0%
    {
        h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
        DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
    }
}
;===============================================================================================================================================================
