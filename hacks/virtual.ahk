SetCapsLockState, alwaysoff

; Globals
DesktopCount = 2        ; Windows starts with 2 desktops at boot
CurrentDesktop = 1      ; Desktop count is 1-indexed (Microsoft numbers them this way)

;
; This function examines the registry to build an accurate list of the current virtual desktops and which one we're currently on.
; Current desktop UUID appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops
; List of desktops appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops
;
mapDesktopsFromRegistry() {
    global CurrentDesktop, DesktopCount

    ; Get the current desktop UUID. Length should be 32 always, but there's no guarantee this couldn't change in a later Windows release so we check.
    IdLength := 32
    SessionId := getSessionId()
    if (SessionId) {
        RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
        if (CurrentDesktopId) {
            IdLength := StrLen(CurrentDesktopId)
        }
    }

    ; Get a list of the UUIDs for all virtual desktops on the system
    RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        DesktopCount := DesktopListLength / IdLength
    }
    else {
        DesktopCount := 1
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (CurrentDesktopId and i < DesktopCount) {
        StartPos := (i * IdLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.

        ; Break out if we find a match in the list. If we didn't find anything, keep the
        ; old guess and pray we're still correct :-D.
        if (DesktopIter = CurrentDesktopId) {
            CurrentDesktop := i + 1
            OutputDebug, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter%.
            break
        }
        i++
    }
}

;
; This functions finds out ID of current session.
;
getSessionId()
{
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    if ErrorLevel {
        OutputDebug, Error getting current process id: %ErrorLevel%
        return
    }
    OutputDebug, Current Process Id: %ProcessId%

    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
    if ErrorLevel {
        OutputDebug, Error getting session id: %ErrorLevel%
        return
    }
    OutputDebug, Current Session Id: %SessionId%
    return SessionId
}

;
; This function switches to the desktop number provided.
;
switchDesktopByNumber(targetDesktop)
{
    global CurrentDesktop, DesktopCount, capslockAction
   capslockAction := 1

    ; Re-generate the list of desktops and where we fit in that. We do this because
    ; the user may have switched desktops via some other means than the script.
    mapDesktopsFromRegistry()

    if (targetDesktop > DesktopCount) {
	targetDesktop := 1
    }
    if (targetDesktop < 1) {
	targetDesktop := DesktopCount
    }

    ; Don't attempt to switch to an invalid desktop
    if (targetDesktop > DesktopCount || targetDesktop < 1) {
        OutputDebug, [invalid] target: %targetDesktop% current: %CurrentDesktop%
        return
    }


    ; Go right until we reach the desktop we want
    while(CurrentDesktop < targetDesktop) {
        Send ^#{Right}
        CurrentDesktop++
	OSD(CurrentDesktop)
        OutputDebug, [right] target: %targetDesktop% current: %CurrentDesktop%
    }

    ; Go left until we reach the desktop we want
    while(CurrentDesktop > targetDesktop) {
        Send ^#{Left}
        CurrentDesktop--
        OSD(CurrentDesktop)
        OutputDebug, [left] target: %targetDesktop% current: %CurrentDesktop%
    }
}

;
; This function creates a new virtual desktop and switches to it
;
createVirtualDesktop()
{
    global CurrentDesktop, DesktopCount
    Send, #^d
    DesktopCount++
    CurrentDesktop = %DesktopCount%
    OSD(CurrentDesktop)
    OutputDebug, [create] desktops: %DesktopCount% current: %CurrentDesktop%
}

;
; This function deletes the current virtual desktop
;
deleteVirtualDesktop()
{
    global CurrentDesktop, DesktopCount
    Send, #^{F4}
    DesktopCount--
    CurrentDesktop--
    OSD(CurrentDesktop)
    OutputDebug, [delete] desktops: %DesktopCount% current: %CurrentDesktop%
}

OSD(text)
{
	IfWinActive, ahk_class VirtualConsoleClass
        {
	    Send !{ESC}
	}
	;WinActivate, Program Manager
	Return

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	Progress, Off
	return
}
; Main
SetKeyDelay, 75
mapDesktopsFromRegistry()
OutputDebug, [loading] desktops: %DesktopCount% current: %CurrentDesktop%

; User config!
; This section binds the key combo to the switch/create/delete actions

CapsLock & 1::switchDesktopByNumber(1)
CapsLock & 2::switchDesktopByNumber(2)
CapsLock & 3::switchDesktopByNumber(3)
CapsLock & 4::switchDesktopByNumber(4)
CapsLock & 5::switchDesktopByNumber(5)
CapsLock & 6::switchDesktopByNumber(6)
CapsLock & 7::switchDesktopByNumber(7)
CapsLock & 8::switchDesktopByNumber(8)
CapsLock & 9::switchDesktopByNumber(9)
CapsLock & l::switchDesktopByNumber(CurrentDesktop + 1)
CapsLock & h::switchDesktopByNumber(CurrentDesktop - 1)

; Alternate keys for this config. Adding these because DragonFly (python) doesn't send CapsLock correctly.
^#n::switchDesktopByNumber(CurrentDesktop + 1)
^#p::switchDesktopByNumber(CurrentDesktop - 1)
^#l::switchDesktopByNumber(CurrentDesktop + 1)
^#h::switchDesktopByNumber(CurrentDesktop - 1)
^#c::createVirtualDesktop()
^#d::deleteVirtualDesktop()

capslockAction := 0
capslockState :=0
caps_start := A_TickCount
caps_time := A_TickCount
recording_time :=0

~lwin up::return
~CapsLock:: 
{
   if (recording_time = 0) 
   {
       caps_start := A_TickCount
       recording_time := 1
   }
}
return

CapsLock Up::
{
   caps_time := A_TickCount - caps_start
   recording_time := 0
   if (capslockAction = 1)
   {
      capslockAction := 0
      return
   } 
   if (caps_time > 200)
   {
	return
   }
   Send {esc}
}
return

~capslock & r::
{
   capslockAction := 1
   SetCapsLockState, alwaysOff
}
return

; Mouse hotkeys
; ---------------------------------------
~CapsLock & d::
{
   capslockAction := 1
   sendinput, {lbutton down}
   keywait, d
   sendinput, {lbutton up}
}
return

~CapsLock & s::
{
   capslockAction := 1
   sendinput, {rbutton down}
   keywait, f
   sendinput, {rbutton up}
}
return

~CapsLock & a::
{
   	capslockAction := 1
	MouseClick, Middle
	keywait, s
	MouseClick, Middle	
}
return

; Window hotkeys
; ---------------------------------------
~CapsLock & w::
{
   capslockAction := 1
   Send !{ESC}
}
return

~CapsLock & o::
{
   capslockAction := 1
   Send !{Space}
   SetCapsLockState, alwaysoff
}
return

~CapsLock & p::
{
   capslockAction := 1
   Send ^{Space}
   SetCapsLockState, alwaysoff
}
return
; Edit hotkeys
; ---------------------------------------
~CapsLock & j::
{
   capslockAction := 1
   Send #{Left}
}
return
~CapsLock & k::
{
   capslockAction := 1
   Send #{Right}
}
return
~CapsLock & m::
{
    WinGet MX, MinMax, A
    If MX
          WinRestore A
    Else WinMaximize A
}
return
~CapsLock & x::
{
    WinClose A
}
return
~CapsLock & q::
{
    WinKill A
}
return
~CapsLock & b::
{
   capslockAction := 1
   Send {PgUp}
}
return

~CapsLock & f::
{
   capslockAction := 1
   Send {PgDown}
}
return

Escape::` 
LShift & Escape::Send {~} 
RShift & Escape::Send {~}
LALT & Escape::Send {Escape} 
RALT & Escape::Send {Escape}
