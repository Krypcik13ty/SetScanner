function set-shortcut {
    param ( $SourceLnk, $DestinationPath, $Parameters, $workdir, $icoloc )
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($SourceLnk)
        $Shortcut.TargetPath = $DestinationPath
        $Shortcut.Arguments = $Parameters
        $Shortcut.WorkingDirectory = $workdir
        $Shortcut.IconLocation = $icoloc
        $Shortcut.Save()
        }
Set-Location -LiteralPath $PSScriptRoot


New-Item -Path "$env:HOMEDRIVE$env:HOMEPATH\SetScanner" -ItemType Directory
copy-item .\files\* $env:HOMEDRIVE$env:HOMEPATH\SetScanner -Force -Recurse


set-shortcut "$env:HOMEPATH\Desktop\SetScanner.lnk" "powershell.exe" "-File $env:HOMEDRIVE$env:HOMEPATH\SetScanner\main.ps1" "$env:HOMEDRIVE$env:HOMEPATH\SetScanner" "$env:HOMEDRIVE$env:HOMEPATH\SetScanner\icon.ico"