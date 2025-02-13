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
winget configure --file "$($PSScriptRoot)\Environment.dsc.yaml" --accept-configuration-agreements
winget configure --file "$($PSScriptRoot)\Packages.dsc.yaml" --accept-configuration-agreements

## Scoop ######################################################################

if ((Get-Command scoop -ErrorAction SilentlyContinue) -eq $false) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}
scoop bucket add extras
scoop install 7zip
scoop install imagemagick
scoop install ghostscript
scoop install qpdf

## ファイル #######################################################################

# robocopy "Source" "Destination" /MIR /FFT /DCOPY:DAT /R:3 /W:5 /NFL /NP /XJ 
# robocopy "Source" "Destination" /MIR /FFT /DCOPY:DAT /R:3 /W:5 /NFL /NP /XJ 

# 追加インストール
# ## GoogleChrome
# $SetupPath = "$($env:TEMP)\chrome_installer.exe"
# Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $SetupPath
# Start-Process -FilePath $SetupPath -Args "/silent /install" -Wait
# Remove-Item $SetupPath
# ## Zoom
# $SetupPath = "$($env:TEMP)\zoom_installer.exe"
# Invoke-WebRequest "https://zoom.us/client/latest/ZoomInstallerFull.exe?archType=x64" -OutFile $SetupPath
# Start-Process -FilePath $SetupPath -Args "/silent /install" -Wait
# Remove-Item $SetupPath
