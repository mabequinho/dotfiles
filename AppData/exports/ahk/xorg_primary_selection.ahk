#Requires AutoHotkey 2.0+
#SingleInstance Ignore
TraySetIcon(A_ScriptDir "\xorg_primary_selection.ico")
CoordMode "ToolTip"

~*LButton::
{
    ; Check if the active window is the ShareX capture window.
    if WinActive("ahk_class WindowsForms10.Window.8.app.0.bd0a2_r6_ad1") ;; Disable on ShareX Drag Capture
    {
        return  ; Do nothing if ShareX is active.
    }

    if (A_ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 500)
        CopyAndShow()
    else
    {
        static dragThreshold := 100
        MouseGetPos &startX, &startY
        KeyWait "LButton"
        MouseGetPos &endX, &endY
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
    
    ; Try to access the clipboard. If it fails (e.g., screen locked), stop the function.
    try
    {
        temp_clipboard := A_Clipboard
        A_Clipboard := ""
    }
    catch
    {
        return ; Abort if clipboard is inaccessible
    }

    SendInput '^{Insert}'
    
    if ClipWait(0.2)
    {
        ; --- New Logic: Truncate ToolTip Text ---
        displayText := A_Clipboard
        maxLength := 600  ; Max characters to allow before truncating
        
        if (StrLen(displayText) > maxLength)
        {
            ; Show first 300 chars ... last 300 chars
            displayText := SubStr(displayText, 1, 300) . "`n`n... [Content Truncated] ...`n`n" . SubStr(displayText, -300)
        }
        ; ----------------------------------------

        ToolTip displayText, , , 1
        SetTimer () => ToolTip(, , , 1), -2000
        SetTimer ClearClipboard, -60000
    }
    else
    {
        ; Restore previous clipboard if copy failed
        try A_Clipboard := temp_clipboard 
    }
}

ClearClipboard()
{
    try A_Clipboard := ""
    catch
    {
        ; Sometimes it throws an error while returning from suspension, not sure if this fixit.
    }
    
    ToolTip "Clipboard cleared!", , , 2
    SetTimer () => ToolTip(, , , 2), -2000
}