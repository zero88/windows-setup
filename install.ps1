Update-Help -Module PowerShellGet

## Install choco
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

## Install softwares
choco install -y `
    skype telegram discord teamviewer GoogleChrome powertoys `
    git gpg4win 7zip `
    curl telnet wireshark `
    microsoft-windows-terminal Cmder powershell-core `
    intellijidea-ultimate vscode `
    docker-cli docker-compose podman-cli `
    kubernetes-cli kubernetes-helm k9s `
    openjdk8 openjdk11 gralde maven `
    nodejs-lts yarn python `
    vagrant virtualbox rsync

mkdir ~/projects

## Install fonts
Set-Location ~/projects
git clone --filter=blob:none --depth 1 --sparse git@github.com:ryanoasis/nerd-fonts
Set-Location ./nerd-fonts
git sparse-checkout add patched-fonts/Hack
git sparse-checkout add patched-fonts/FiraCode
git sparse-checkout add patched-fonts/SourceCodePro
./install.ps1 FiraCode, SourceCodePro, Hack
Set-Location -

## Install modules
Install-Module oh-my-posh -Scope CurrentUser
Install-Module Terminal-Icons -Scope CurrentUser
Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force

## Optimize profile
#### Powershell profile
if (-not $(Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType file –Force
}
curl https://raw.githubusercontent.com/zero88/windows-setup/main/profile.ps1 | Set-Content -Path $PROFILE

#### Terminal setting
$sf = "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
if (-not $(Test-Path $sf)) {
    New-Item -Path $sf -ItemType file –Force
}
curl https://raw.githubusercontent.com/zero88/windows-setup/main/terminal-settings.json | Set-Content -Path $sf

#### ohmyposh config
curl https://raw.githubusercontent.com/zero88/windows-setup/main/.ohmyposh.material.json > $HOME/.ohmyposh.material.json
