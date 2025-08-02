#Requires AutoHotkey 2.0+
#SingleInstance Force
CoordMode "ToolTip"

~*LButton::
{
    if (A_ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 400)
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
        Sleep 50
        ClearClipboard()
    }
}

CopyAndShow()
{
    A_Clipboard := ""
    SendInput '^{Insert}'
    ClipWait 1
    if A_Clipboard != ""
    {
        ToolTip A_Clipboard, 0, A_ScreenHeight, 1
        SetTimer ClearClipboard, -60000
    }
}

ClearClipboard()
{
    A_Clipboard := ""
    ToolTip "Clipboard cleared!", , , 2
    SetTimer () => ToolTip(, , , 2), -3000
}