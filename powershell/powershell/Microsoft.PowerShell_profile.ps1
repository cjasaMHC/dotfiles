$exTime = Measure-Command {

  Set-PsFzfOption -TabExpansion
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
  Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
  Set-PSReadlineOption -MaximumHistoryCount 1000 -HistoryNoDuplicates

  function touch { New-Item -ItemType file -Path $args } #EZPZ Linux-feeling touch
  function newLS { eza  --color=auto --icons=auto } #LS using eza, colors + icons are nice :)
  function lt { eza -T --level=2 --color=auto --icons=auto } #LS - Tree View 2 layers deep
  function la { eza -la --color=auto --icons=auto } #LS - All info
  function ll { eza -l --color=auto --icons=auto } #LS - informational
  function lm { eza -1rl --sort=modified --color=auto --icons=auto } #LS - Last Modified sorted
  function l1 { eza -1 --color=auto --icons=auto } #LS 1-line

#MG-Graph connect stuff
  $clientId = "d39b1c6a-1000-4c84-9a7a-f86b4a050a9f"
  $tenantId = "33a5ff56-b967-4b28-81bb-c0054ea395a5"
  $scopeInfo = "User.ReadWrite.All, Organization.Read.All"

  function graph {
    Connect-MGGraph -ClientId $clientId -TenantId $tenantId -Scopes $scopeInfo -NoWelcome    #Report Connection to MS Graph
    $Details = Get-MgContext
    $Scopes = $Details | Select-Object -ExpandProperty Scopes
    $Scopes = $Scopes -Join ", "
    $OrgName = (Get-MgOrganization).DisplayName

    Write-Host "Microsoft Graph Connection Information" -ForegroundColor Green
    Write-Host "--------------------------------------" -ForegroundColor Green
    Write-Host " "
    Write-Host ("Connected to Tenant {0} ({1}) as account {2}" -f $Details.TenantId, $OrgName, $Details.Account) -ForegroundColor Green
    Write-Host "+-------------------------------------------------------------------------------------------------------------------+" -ForegroundColor Green
    Write-Host ("The following permission scope is defined: {1}" -f $ProfileName, $Scopes) -ForegroundColor Green
    Write-Host ""
  }

# Shortcut for NeoVim
  function v {
    param (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [string]$file4Edit
    )
    nvim $file4Edit
  }

  Set-Alias -Name cg -Value graph
  Set-Alias -Name dg -Value Disconnect-MGGraph

  Set-Alias -Name pd -Value PushD
  Set-Alias -Name ppd -Value PopD
  Set-Alias -Name wf -Value WinFetch
  Set-Alias -Name ff -Value FastFetch
  Set-Alias -Name nf -Value NeoFetch
  Set-Alias -Name ls -Value newLS -Option AllScope
  Set-Alias -Name cl -Value Clear-Host
  Set-Alias -Name cat -Value bat -Option AllScope
  function nvp { nvim 'C:\Users\cjasa\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1' }

  oh-my-posh init powershell --config "$env:POSH_THEMES_PATH\hunk.omp.json" | Invoke-Expression
  Invoke-Expression (& { (zoxide init powershell | Out-String) })

}

$exTime = [Math]::Round($exTime.TotalSeconds,2)
Write-Host "Startup: $($exTime)s"
