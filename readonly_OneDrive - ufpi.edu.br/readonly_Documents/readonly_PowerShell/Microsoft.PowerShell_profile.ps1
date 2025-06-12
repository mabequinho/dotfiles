#
# Define a helper function for eza with common arguments
function Invoke-Eza {
    param (
        [string[]]$ExtraArgs,
        [string[]]$Paths
    )
    eza --long --colour=auto --icons=auto --group-directories-first --no-user --no-permissions --total-size --git --git-ignore --time modified --sort modified --header -F @ExtraArgs @Paths
}

# Define function for 'l' command
function l {
    param (
        [string[]]$Paths = @('.')
    )
    Invoke-Eza -ExtraArgs @() -Paths $Paths
}

# Define function for 'la' command
function la {
    param (
        [string[]]$Paths = @('.')
    )
    Invoke-Eza -ExtraArgs @('--all') -Paths $Paths
}

# Define function for 't' command
function t {
    param (
        [string[]]$Paths = @('.')
    )
    Invoke-Eza -ExtraArgs @('--tree', '--level=3') -Paths $Paths
}

# Define function for 'ta' command
function ta {
    param (
        [string[]]$Paths = @('.')
    )
    Invoke-Eza -ExtraArgs @('--tree', '--level=3', '--all') -Paths $Paths
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
$env:EDITOR = "vi"
function note { & $env:EDITOR ("$(Get-Date -Format 'ddd_MMM_dd-HH:mm:ss').txt") }
function e { & $env:EDITOR @args }
function ee { & $env:EDITOR (fzf) }

# --- Other command aliases ---

function x { exit }

Remove-Alias -Name gp -Force
Remove-Alias -Name gc -Force

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -ViMode Insert -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl-f -Function ViForwardChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -Function ViCommandMode -ViMode Insert

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#Carapace
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\lu\miniforge3\Scripts\conda.exe") {
    (& "C:\Users\lu\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

