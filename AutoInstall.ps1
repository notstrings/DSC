## ############################################################################
# 管理者権限セッションでの実行を要求する
function isInAdmin {
    $UID = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $UID.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (-not (isInAdmin)) {
    Start-Process powershell.exe -ArgumentList "-NoExit -File ""$($MyInvocation.MyCommand.Path)""" -Verb RunAs
    exit 0
}

## WinGet #####################################################################

# Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# Find-Module -Name NetworkingDSC -Repository PSGallery | Install-Module
Write-Output 'Y' | winget configure --file "$($PSScriptRoot)\Environment.dsc.yaml"
Write-Output "Y" | winget configure --file "$($PSScriptRoot)\Packages.dsc.yaml"

## Scoop ######################################################################

if ((Get-Command scoop -ErrorAction SilentlyContinue) -eq $false) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}
scoop bucket add extras
scoop install 7zip
scoop install imagemagick
scoop install ghostscript
scoop install qpdf

## RoboCopy ###################################################################

# robocopy "Source" "Destination" /MIR /FFT /DCOPY:DAT /R:3 /W:5 /NFL /NP /XJ 
# robocopy "Source" "Destination" /MIR /FFT /DCOPY:DAT /R:3 /W:5 /NFL /NP /XJ 
