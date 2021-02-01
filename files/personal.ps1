

$pers_form = New-object System.Windows.Forms.Form
$pers_form.Text = "SetScanner"
$pers_form.Width = 600
$pers_form.Height = 400
$pers_form.AutoScale = $true
$pers_form.MaximizeBox = $false
$pers_form.StartPosition = 'CenterScreen'
$pers_form.FormBorderStyle = 'FixedDialog'
$warningBox = New-Object System.Windows.Forms.RichTextBox
$WarningBox.Location = New-Object System.Drawing.Point(10,9)
$warningBox.Enabled = $False
$warningBox.Height = 128
$warningBox.Width = 390
$warningBox.Font = 'Segoe UI, 12pt, style=Bold, Italic'
$warningBox.Text = "These variables are personal, specifically: 
-These can be used to identify you.  
-Do not share these with anyone.
-Use with caution, click the button to reveal.
-For most of the variables internet connection is required"
$pers_form.Controls.Add($warningBox)


$ErrorActionPreference = "SilentlyContinue"

if($machinebar.Text -like $null){
    $ipinfo = Invoke-RestMethod http://ipinfo.io/json
}
else 
{
    if ($credential -like $null)
    {
        $ipinfo = invoke-command -Computername $machinebar.Text ScriptBlock {Invoke-RestMethod http://ipinfo.io/json}
    }
    if ($credential -notlike $null)
    {
        $ipinfo = invoke-command -Computername $machinebar.Text -Credential $credential -ScriptBlock {Invoke-RestMethod http://ipinfo.io/json}
    }
}

$drawpoint2 = 160
$movesize2 = 25
function OnClick($Sender, $EventArgs){     
    if ($Sender.Text -like "?") {
    $numb = "perslabel$($Sender.Number)"
    $resultvar = get-variable -Name "$numb"
    $helpfunc = New-object System.Windows.Forms.Form
    $helpfunc.Text = "What is this?"
    $helpfunc.Width = 500
    $helpfunc.Height = 200
    $helpfunc.AutoScale = $true  
    $helpname = new-object System.Windows.Forms.RichTextBox
    $helpfunc.StartPosition = 'CenterScreen'
    $helpfunc.FormBorderStyle = 'FixedDialog'
    $helpfunc.MaximizeBox = $false
    $helpfunc.MinimizeBox = $false
    $helpname.height = 30
    $helpname.Width = 400
    $helpname.Location = New-Object System.Drawing.Point(10, 10)
    $oldFont = $helpname.Font
    $font = New-Object Drawing.Font($oldFont.FontFamily, $oldFont.Size, [Drawing.FontStyle]::Bold)
    $helpname.Font = $font
    $helpname.ReadOnly = $true
    $helpname.Text = "$($resultvar.Value.Text)"
    $helpdesc = new-object System.Windows.Forms.Label
    $helpdesc.height = 400
    $helpdesc.Width = 400
    $helpdesc.Location = New-Object System.Drawing.Point(10, 45)
    $helpdesc.Text = $P | where-Object func -like $helpname.Text | select-Object -ExpandProperty desc
    $helpfunc.Controls.Add($helpname)
    $helpfunc.Controls.Add($helpdesc)
    $helpfunc.ShowDialog()
    }
    else {
        $numb = "persfield$($Sender.Number)"
        $resultvar = get-variable -Name "$numb"
        Set-Clipboard -Value $resultvar.Value.Text
    }
}

for ($i = 1; $i -ne 9; $i = $i + 1)
{
    new-variable -name "persfield$i"
    new-variable -name "perslabel$i"
    new-variable -name "persquestion$i"
    new-variable -name "perscopier$i"
    $(get-variable -Name "persfield$i").Value = new-object System.Windows.Forms.TextBox
    $(get-variable -Name "persfield$i").Value.Height = 30
    $(get-variable -Name "persfield$i").Value.Width = 250
    $(get-variable -Name "persfield$i").Value.Location = New-Object System.Drawing.Point(150, $drawpoint2)
    $(get-variable -Name "persfield$i").Value.Enabled = $false
    $(get-variable -Name "persfield$i").Value.UseSystemPasswordChar = $true
    $(get-variable -Name "perslabel$i").Value = new-object System.Windows.Forms.Label
    $(get-variable -Name "perslabel$i").Value.Height = 20
    $(get-variable -Name "perslabel$i").Value.Width = 130
    $(get-variable -Name "perslabel$i").Value.Location = New-Object System.Drawing.Point(10, $drawpoint2)
    $(get-variable -Name "perslabel$i").Value.Text = "Hidden!"
    $(get-variable -Name "persquestion$i").Value = new-object System.Windows.Forms.Button
    $(get-variable -Name "persquestion$i").Value.Height = 20
    $(get-variable -Name "persquestion$i").Value.Width = 20
    $(get-variable -Name "persquestion$i").Value.Location = New-Object System.Drawing.Point(410, $drawpoint2)
    $(get-variable -Name "persquestion$i").Value.Text = "?"
    $(get-variable -Name "persquestion$i").Value.Enabled = $false
    $(get-variable -Name "persquestion$i").Value | Add-Member -NotePropertyName Number -NotePropertyValue $i
    $(get-variable -Name "persquestion$i").Value.add_click({OnClick $this $_})
    $(get-variable -Name "perscopier$i").Value = new-object System.Windows.Forms.Button
    $(get-variable -Name "perscopier$i").Value.Height = 20
    $(get-variable -Name "perscopier$i").Value.Width = 120
    $(get-variable -Name "perscopier$i").Value.Location = New-Object System.Drawing.Point(430, $drawpoint2)
    $(get-variable -Name "perscopier$i").Value.Text = "copy to clipboard"
    $(get-variable -Name "perscopier$i").Value.Enabled = $false
    $(get-variable -Name "perscopier$i").Value | Add-Member -NotePropertyName Number -NotePropertyValue $i
    $(get-variable -Name "perscopier$i").Value.add_click({OnClick $this $_})
    $pers_form.Controls.Add($(get-variable -Name "persfield$i").Value)
    $pers_form.Controls.Add($(get-variable -Name "perslabel$i").Value)
    $pers_form.Controls.Add($(get-variable -Name "persquestion$i").Value)
    $pers_form.Controls.Add($(get-variable -Name "perscopier$i").Value)
    $drawpoint2 = $drawpoint2 + $movesize2   
}
$perslabel1.Text = "Public IP"
    $persfield1.Text = $ipinfo.ip
    $perslabel2.Text = "Hostname"
    $persfield2.Text = $ipinfo.hostname
    $perslabel3.Text = "City"
    $persfield3.Text = $ipinfo.city
    $perslabel4.Text = "Region"
    $persfield4.Text = $ipinfo.region
    $perslabel5.Text = "Country"
    $persfield5.Text = $ipinfo.country

    $perslabel6.Text = "Internet Service Provider"
    $persfield6.Text = $ipinfo.org
    $perslabel7.Text = "ISP GPS Location"
    $persfield7.Text = $ipinfo.loc
    $perslabel8.Text = "Activated CD-Key"
    if($machinebar.Text -like $null){
      $cdkey = Get-Ciminstance -Class SoftwareLicensingService | select-Object -ExpandProperty OA3xOriginalProductKey
  }
  else 
  {
      if ($credential -like $null)
      {
          $cdkey = invoke-command -Computername $machinebar.Text ScriptBlock {Get-Ciminstance -Class SoftwareLicensingService | select-Object -ExpandProperty OA3xOriginalProductKey}
      }
      if ($credential -notlike $null)
      {
          $cdkey = invoke-command -Computername $machinebar.Text -Credential $credential -ScriptBlock {Get-Ciminstance -Class SoftwareLicensingService | select-Object -ExpandProperty OA3xOriginalProductKey}
      }
  }
    $persfield8.Text = $cdkey
$revealbutton = new-object System.Windows.Forms.Button
$revealbutton.Height = 128
$revealbutton.Width = 128
$revealbutton.Location = new-Object System.Drawing.Point (420,20)
$revealbutton.Text =  "Reveal variables"
$revealbutton.Add_Click{
    get-variable persfield* | foreach {
      
      $_.Value.UseSystemPasswordChar = $false
    }
    get-variable persquestion* | foreach {
      
        $_.Value.Enabled = $true
      }
      get-variable perscopier* | foreach {
      
        $_.Value.Enabled = $true
      }
      $revealbutton.Enabled = $false
}
$pers_form.Controls.Add($revealbutton)
$pers_form.ShowDialog()
# SIG # Begin signature block
# MIIFmAYJKoZIhvcNAQcCoIIFiTCCBYUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrhRIi8KBlV3dg2tE9fkDZ9I8
# jGWgggO6MIIDtjCCAx+gAwIBAgIQPwt5EwLdMplN7jLNRRIvfzANBgkqhkiG9w0B
# AQUFADAUMRIwEAYDVQQDDAlybmF3cm9ja2kwHhcNMjEwMTE5MTUyODI1WhcNMjIw
# MTE5MTU0ODI1WjAUMRIwEAYDVQQDDAlybmF3cm9ja2kwgZ8wDQYJKoZIhvcNAQEB
# BQADgY0AMIGJAoGBAMqQln8B+VY+apIk3J7zFn5koS32a8ryYOHznmton2axEP7Y
# 3l6SGomBhSifntKhvNER20ImhDLxbk68aFUeh4zrVENdcwp0EnQy0oZ/eOmMzAbA
# j3TRDkQvq8bmwcx+6plcKgi0dMagIci4hNS5RlxFZNAVo7ocxqeFLhx71DqVAgMB
# AAGjggIHMIICAzA8BgkrBgEEAYI3FQcELzAtBiUrBgEEAYI3FQiDgOoJgpPfU4O5
# jyGBwb09h+vMTgCGl5dQxqRpAgFkAgELMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMCQGA1Ud
# EQQdMBugGQYKKwYBBAGCNxQCA6ALDAlybmF3cm9ja2kwHQYDVR0OBBYEFMl47Rhi
# INK2ylGaKTKuZM1+FaMiMGYGCisGAQQBgjcKCxoEWP8dAwAUAAAAVwBBAEMAQQBJ
# AFMAUwBVAEkATgBHADEALgBxAGcALgBjAG8AbQAAABAAAABRAEcAIABXAEEAIABJ
# AHMAcwB1AGkAbgBnACAAMQAAAAAAAAAwgdMGCisGAQQBgjcKC1cEgcQAAAAAAAAA
# AAIAAAAAAAAAAgAAAGwAZABhAHAAOgAAAHsARgBDAEYARgAwADAARQBFAC0ANQBE
# ADYANQAtADQAQQAyAEEALQA5AEYARQA0AC0ARgAzADYAOABBADEANwA4ADEAOQA4
# AEEAfQAAAFcAQQBDAEEASQBTAFMAVQBJAE4ARwAxAC4AcQBnAC4AYwBvAG0AXABR
# AEcAIABXAEEAIABJAHMAcwB1AGkAbgBnACAAMQAAADIAMAA0ADIAOAA3AAAAMA0G
# CSqGSIb3DQEBBQUAA4GBAIUDPfW0NLcYbTMBs6m07yTjPFpEOgaEcc3nI8n2dxD5
# 2fc2XHoB8milKPGiIKJt5p//r/ruSDUtzvcjrVL9SWTHY8sfUBQ1YYbytxhxmOfO
# 16gsDjgl0dIAznmlzRSqT6bY/vQpXOS+ssqTV0PpjOy7JY1ropesET3QeE71nL20
# MYIBSDCCAUQCAQEwKDAUMRIwEAYDVQQDDAlybmF3cm9ja2kCED8LeRMC3TKZTe4y
# zUUSL38wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFLHomcaA53S+mUifkmrgpRNC+awJMA0GCSqG
# SIb3DQEBAQUABIGAvbhMA/mhuDt8Yjp69tO7k6EcbhK9J4QBHg/8tVgK2Oj7CYcv
# i2KNtb93lIIm7DWDrmzpWMGqO1WH13ulcv9hHDDM1MRA+RJKU4NviGXcmnsn/H2U
# V5mEhiJ8Cpg9wvPSdpBcUVQSLsELlIDm36Oi4TYFzIQbh8iUcYpPH9CICOI=
# SIG # End signature block
