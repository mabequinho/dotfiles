# Define function for 'l' command
function l {
    eza --group-directories-first --colour=auto --icons=auto --no-user --no-permissions --smart-group --git --git-ignore -F -l @args
}

# Define function for 'la' command
function la {
    eza --group-directories-first --colour=auto --icons=auto --no-user --no-permissions --smart-group --git --git-ignore -F -l -a @args
}

# Define function for 't' command
function t {
    eza --group-directories-first --colour=auto --icons=auto --no-user --no-permissions --smart-group --git --git-ignore -F -t modified -l -T -L 2 @args
}

# Define function for 'ta' command
function ta {
    eza --group-directories-first --colour=auto --icons=auto --no-user --no-permissions --smart-group --git --git-ignore -F -t modified -l -T -L 2 -a @args
}

# Aliases
# --- Git aliases ---
function g { git @args }
function gs { git status }
function gc { git commit -a }
function ga { git add -A }
function gp { git push }
function gd { git diff }

# --- General aliases ---
function s { sudo @args }
function .. { z .. }
function ... { z ../../ }

# --- Environment Variables ---
$env:BAT_PAGER = " "
$env:FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --preview 'bat --theme=ansi --color=always --style=header,grid --line-range :300 {}'"

# --- Other command aliases ---
function c { bat --theme=ansi @args }
function cc { bat --theme=ansi (fzf) }
function rm { Remove-Item @args -Force -Recurse; Remove-Item @args -Recycle }
function mkdir { New-Item -Path $args[0] -ItemType Directory -Force }

function o {
    Start-Process @args
}

function oo { Start-Process (fzf) }

# --- Editor aliases using $EDITOR ---
$env:EDITOR = "nvim"
function note { & $env:EDITOR ("$(Get-Date -Format 'ddd_MMM_dd-HH:mm:ss').txt") }
function e { & $env:EDITOR @args }
function ee { & $env:EDITOR (fzf) }

# --- Other command aliases ---
function x { exit }

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord Ctrl-f -Function ViForwardChar
Set-PSReadLineKeyHandler -Key Tab -Function Complete

Remove-Alias -Name gp -Force
Remove-Alias -Name gc -Force

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\lu\AppData\Local\miniforge3\Scripts\conda.exe") {
    (& "C:\Users\lu\AppData\Local\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion
conda activate basest
