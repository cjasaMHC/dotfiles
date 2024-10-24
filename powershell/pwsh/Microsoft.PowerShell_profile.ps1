$exTime = Measure-Command {

  Set-PsFzfOption -TabExpansion
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
  Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
  Set-PSReadlineOption -MaximumHistoryCount 1000 -HistoryNoDuplicates

  # EZPZ Linux-feel touch
  function touch { New-Item -ItemType File -Path $args }

  # LS using eza w/colors + icons
  function newLS { eza -1 --hyperlink --color=always --icons=auto }

  # LS - Tree view
  function lt { eza -laT --level=2 --color=always --hyperlink --no-permissions --icons=auto }

  # LS - All (Includes hidden files)
  function la { eza -lam --hyperlink --color=always --icons=auto --no-permissions --time-style='+%Y/%m/%d %l:%M %p' }

  # LS - List/Long
  function ll { eza -la --color=always --icons=auto --no-permissions }

  # LS - Last Modified
  function lm { eza -1arl --sort=modified --hyperlink --color=always --icons=auto --no-permissions }

  # Gping function w/Coloring
  function gpinger { gping $args --clear --color='magenta' }

  # Neovim - Powershell $PROFILE
  function nvp { nvim 'C:\Users\cjasa\Documents\PowerShell\Microsoft.PowerShell_profile.ps1' }

  # Neovim - .wezterm.lua
  function nvw { nvim 'C:\Users\cjasa\.wezterm.lua' }

  # Neovim - oh-my-posh custom prompt
  function nvo { nvim 'C:\Users\cjasa\custom.omp.json' }

  # Neovim - Obsidian Notes
  function nvob { nvim 'P:\Obsidian Vault\SecondaryVault' }

  # Neovim - NeoVim config folder
  function nvn { nvim 'C:\Users\cjasa\AppData\Local\nvim' }

  # Neovim - WinFetch config file
  function nvf { nvim 'C:\Users\cjasa\.config\winfetch\config.ps1' }

  # Bat w/Options for color highlighting n LESS as the pager
  function batOpts { bat $args --color=always }

  # Open Windows Powershell quickly
  function wp { powershell -NoLogo }

  # Decompress .zip folder quickly
  function od { ouch decompress $args }

  # Kill all gits
  function killGit { Get-Process git | ForEach-Object { Stop-Process -Id $_.Id -Force } }

  # Shortened Git Status
  function gs { git status }


  # ---= Fancy Pants functions w/parameters =--- #


  # Shortcut for NeoVim
  function v {
    param (
      [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
      [string]$file4Edit = "."
    )
    nvim $file4Edit
  }


  # Shortcut for File Explorer
  function e {
    param (
      [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
      [string]$explorerPath = ".\."
    )
    explorer $explorerPath
  }

  function c {
    param (
      [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
      [string]$codePath = ".\."
    )
    code $codePath
  }
  
  # Enter-PsSession shortcut
  function eps { 
    param (
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [string]$computerName
    )
    Enter-PsSession -ComputerName $computerName
  }
  
  # Shell wrapper for Yazi
  function yy {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
      Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
  }


  # ---= Aliases to make life just a lil better =--- #
  
  Set-Alias -Name pd -Value PushD
  Set-Alias -Name ppd -Value PopD
  Set-Alias -Name wf -Value WinFetch
  Set-Alias -Name ff -Value FastFetch
  Set-Alias -Name nf -Value NeoFetch
  Set-Alias -Name cat -Value batOpts
  Set-Alias -Name ls -Value newLS
  Set-Alias -Name cl -Value Clear-Host
  Set-Alias -Name p -Value gpinger

  # Git aliases
  Set-Alias -Name g -Value git

  # Import the Chocolatey Profile 
  # See https://ch0.co/tab-completion for details.
  # $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  # if (Test-Path($ChocolateyProfile)) {
  #   Import-Module "$ChocolateyProfile"
  # }
  # End Chocolatey stuff

  # These stay at the bottom, in this order preferrably
  oh-my-posh init pwsh --config "C:\users\cjasa\custom.omp.json" | Invoke-Expression
  Invoke-Expression (& { (zoxide init powershell | Out-String) })

}

$exTime = [Math]::Round($exTime.TotalSeconds,2)
Write-Host "Startup: $($exTime)s"
