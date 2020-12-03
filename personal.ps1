$pers_form = New-object System.Windows.Forms.Form
$pers_form.Text = "SetScanner"
$pers_form.Width = 640
$pers_form.Height = 640
$pers_form.AutoScale = $true

$ErrorActionPreference = "SilentlyContinue"

$breaks2 = $pers_form.Height / 20
$drawpoint2 = 0
$movesize2 = 20
for ($i = 1; $i -ne $breaks2; $i = $i + 1)
{
    new-variable -name "persfield$i"
    new-variable -name "perslabel$i"
    $(get-variable -Name "persfield$i").Value = new-object System.Windows.Forms.TextBox
    $(get-variable -Name "persfield$i").Value.Height = 30
    $(get-variable -Name "persfield$i").Value.Width = 70
    $(get-variable -Name "persfield$i").Value.Location = New-Object System.Drawing.Point(80, $drawpoint2)
    $(get-variable -Name "perslabel$i").Value = new-object System.Windows.Forms.Label
    $(get-variable -Name "perslabel$i").Value.Height = 20
    $(get-variable -Name "perslabel$i").Value.Width = 70
    $(get-variable -Name "perslabel$i").Value.Location = New-Object System.Drawing.Point(10, $drawpoint2)
    $(get-variable -Name "perslabel$i").Value.Text = "persfield$i"

    $pers_form.Controls.Add($(get-variable -Name "persfield$i").Value)
    $pers_form.Controls.Add($(get-variable -Name "perslabel$i").Value)
    $drawpoint2 = $drawpoint2 + $movesize2   
}

$pers_form.ShowDialog()