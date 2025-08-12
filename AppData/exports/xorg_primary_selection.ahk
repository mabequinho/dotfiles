#Requires AutoHotkey 2.0+
#SingleInstance Ignore
TraySetIcon("C:\Users\lu\AppData\exports\mousetrapmouse_mouse_4603.ico")
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
        static dragThreshold := 10
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
    local temp_clipboard := A_Clipboard
    A_Clipboard := ""
    SendInput '^{Insert}'
    if ClipWait(0.2)
    {
        ToolTip A_Clipboard, , , 1
        SetTimer () => ToolTip(, , , 1), -2000
        SetTimer ClearClipboard, -60000
    }
    else
    {
        A_Clipboard := temp_clipboard
    }
}

ClearClipboard()
{
    A_Clipboard := ""
    ToolTip "Clipboard cleared!", , , 2
    SetTimer () => ToolTip(, , , 2), -2000
}