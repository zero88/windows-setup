$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# thanks to https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
# improved tabbing for autocompletion
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

function doGrep {
  $input | out-string -stream | Select-String -Pattern $args[0]
}
New-Alias grep doGrep
New-Alias which Get-Command

## https://ohmyposh.dev/
Import-Module oh-my-posh
Set-PoshPrompt -Theme ~/.ohmyposh.material.json

## https://github.com/devblackops/Terminal-Icons
Import-Module -Name Terminal-Icons

## https://github.com/dahlbyk/posh-git
Import-Module posh-git
# $GitPromptSettings.WindowTitle = "~ "

## AWS auto complete
Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
      $env:COMP_LINE=$wordToComplete
      $env:COMP_POINT=$cursorPosition
      aws_completer.exe | ForEach-Object {
          [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
      }
      Remove-Item Env:\COMP_LINE     
      Remove-Item Env:\COMP_POINT  
}

## Kubectl auto complete
### Need to install module: 
#### Install-Module -Name PSKubectlCompletion
Import-Module PSKubectlCompletion

## Helm auto complete
helm completion powershell | Out-String | Invoke-Expression