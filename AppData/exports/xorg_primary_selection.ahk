#Requires AutoHotkey 2.0+
#SingleInstance Force
CoordMode "ToolTip"

~LButton & MButton::
{
    ; Display a tooltip with the starting message.
    Tooltip("Delayed click in 5...")

    ; Start the 5-second countdown.
    Loop 5
    {
        Sleep(1000) ; Sleep for 1 second.
        
        ; Remove the current number from 5.
        remainingTime := 5 - A_Index
        
        ; Update the tooltip with the new remaining time.
        Tooltip("Clicking in " remainingTime "...")
        
        ; This is a special case for the last second to display "1" before the click.
        if (remainingTime = 1)
        {
            Sleep(1000)
            break
        }
    }
    
    ; Clear the tooltip after the countdown is complete.
    Tooltip()
    
    ; Perform the left click.
    MouseClick("left")
    
    return
}

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
        ToolTip A_Clipboard, , , 1
        SetTimer () => ToolTip(, , , 1), -3000
        SetTimer ClearClipboard, -60000
    }
}

ClearClipboard()
{
    A_Clipboard := ""
    ToolTip "Clipboard cleared!", , , 2
    SetTimer () => ToolTip(, , , 2), -3000
}