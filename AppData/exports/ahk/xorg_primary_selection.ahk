#Requires AutoHotkey 2.0+
#SingleInstance Ignore
TraySetIcon(A_ScriptDir "\xorg_primary_selection.ico")
CoordMode "ToolTip"
; FIX 1: Ensure mouse coordinates are always absolute to the screen, 
; preventing calculation errors when switching windows.
CoordMode "Mouse", "Screen" 

~*LButton::
{
    ; FIX 2: Focus Guard. 
    ; Check if the window under the mouse is ALREADY active.
    ; If not, you are just clicking to focus it. We should stop here.
    MouseGetPos , , &hoverHwnd
    if (hoverHwnd != WinActive("A"))
        return

    ; Check if the active window is the ShareX capture window.
    if WinActive("ahk_exe ShareX.exe")
    {
        return 
    }

    if (A_ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 500)
        CopyAndShow()
    else
    {
        static dragThreshold := 100
        MouseGetPos &startX, &startY
        KeyWait "LButton"
        MouseGetPos &endX, &endY
        
        ; Because CoordMode is Screen, this calculation is now safe
        if (Abs(endX - startX) > dragThreshold || Abs(endY - startY) > dragThreshold)
            CopyAndShow()
    }
}

~MButton::
{
    if A_Clipboard != ""
    {
        SendInput '^{v}'
        sleep 50
        ClearClipboard()
    }
}

CopyAndShow()
{
    local temp_clipboard := ""
    
    try
    {
        temp_clipboard := A_Clipboard
        A_Clipboard := ""
    }
    catch
    {
        return 
    }

    SendInput '^{Insert}'
    
    if ClipWait(0.2)
    {
        displayText := A_Clipboard
        maxLength := 600 
        
        if (StrLen(displayText) > maxLength)
        {
            displayText := SubStr(displayText, 1, 300) . "`n`n... [Content Truncated] ...`n`n" . SubStr(displayText, -300)
        }

        ToolTip displayText, , , 1
        SetTimer () => ToolTip(, , , 1), -2000
        SetTimer ClearClipboard, -60000
    }
    else
    {
        try A_Clipboard := temp_clipboard 
    }
}

ClearClipboard()
{
    try A_Clipboard := ""
    catch
    {
    }
    
    ToolTip "Clipboard cleared!", , , 2
    SetTimer () => ToolTip(, , , 2), -2000
}