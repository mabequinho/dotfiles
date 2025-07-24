;;;;;	AHK Xorg PRIMARY Selection
;;;;;	https://www.autohotkey.com/boards/viewtopic.php?p=570700#p570700

#Requires AutoHotkey 2.0+        ;Needs AHK v2
#SingleInstance Force            ;Run only one instance

~*LButton::ClickCopy(1)          ;Pass '1' to ClickCopy()
~*LButton Up::ClickCopy(-1)      ;Pass '-1' to ClickCopy()

ClickCopy(Option:=0){            ;Main Func (Default='0')
  Static Clicked:=0              ;  Remember 'Clicked' value
  Static Release:=0              ;  Remember 'Release' value
  If (Option=1){                 ;  If '1' was passed 
    Release:=0                   ;    Set 'Release' to '0'
    Clicked++                    ;    Add '1' to 'Clicked'
  }                              ;  End If block
  If (Option=-1){                ;  If '-1' was passed
    Release:=1                   ;    Set 'Release' to '1'
    SetTimer(%A_ThisFunc%,-150)  ;    Loop Func in 150ms
  }                              ;  End If block
  If !Option                     ;  If 'Option' is '0' (Loop)
  && Release{                    ;    AND 'Release' is '1'
    Clicked:=0                   ;    Clear 'Clicked'
    Release:=0                   ;    Clear 'Release'
  }                              ;  End If block
  If (Clicked=2)                 ;  If 'Clicked' twice
  || (Clicked=3)                 ;  OR 'Clicked' thrice
    SendInput '^{Insert}'        ;    Send the Copy hotkey

;;;;;;;;;;;;;;;                  ;  block for selection by mouse dragging
else{
 Static minDist := 10
 MouseGetPos &x1, &y1
 KeyWait 'LButton'
 MouseGetPos &x2, &y2
 If Abs(x2 - x1) >= minDist || Abs(y2 - y1) >= minDist
    SendInput '^{Insert}'
}
;;;;;;;;;;;;;;;                  ;  end of block mouse dragging

}                                ;  End Func block


~MButton::                       ;  Middle click function
{
	Send "^{v}"                  ;  Send the Paste hotkey
}