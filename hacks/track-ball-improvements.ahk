
capslockAction := 0
capslockState :=0
CapsLock Up::
{
   if (capslockAction = 1)
   {
      capslockAction := 0
      return
   } 
   Send {esc}
}
return

~CapsLock & d::
{
   capslockAction := 1
   sendinput, {lbutton down}
   keywait, d
   sendinput, {lbutton up}
}
return

~CapsLock & f::
{
   capslockAction := 1
   sendinput, {rbutton down}
   keywait, f
   sendinput, {rbutton up}
}
return

~lwin up::return

~capslock & p::
{
 	if (capslockState = 0)
 	{
		SetCapsLockState, on
		capslockState := 1
	}
	else if (capslockState = 1)
	{
		SetCapsLockState, off
		capslockState := 0
	}
}
return

~CapsLock & s::
{
   	capslockAction := 1
	MouseClick, Middle
	keywait, s
	MouseClick, Middle	
}
return
