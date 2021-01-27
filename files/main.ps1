#Disable erroraction to prevent unnecessary breakouts
$ErrorActionPreference = "SilentlyContinue"

#Add necessary types
Add-Type -assembly System.Windows.Forms

#Set Debug window to hidden (Comment from line 7 to 15 to enable debug window)
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

#Create main form
$main_form = New-object System.Windows.Forms.Form
$icon = "$PSScriptRoot\icon.ico"
$main_form.Icon = $icon
$main_form.Text = "SetScanner"
$main_form.Width = 1260
$main_form.Height = 700
$main_form.StartPosition = 'CenterScreen'
$main_form.AutoScale = $true
#$main_form.MaximizeBox = $false
$main_form.FormBorderStyle = 'FixedDialog'
$varscounter = 1
if($machinebar.Text -like $null){
    $vars = get-childitem Env:
    $main_form.Text = "SetScanner - $($vars | where-object name -like COMPUTERNAME | select -expandproperty Value)"
}
else 
{
    if ($credential -like $null)
    {
        $vars = invoke-command -Computername $machinebar.Text ScriptBlock {get-childitem Env:}
        $main_form.Text = "SetScanner - $($vars | where-object name -like COMPUTERNAME | select -expandproperty Value)"
    }
    if ($credential -notlike $null)
    {
        $vars = invoke-command -Computername $machinebar.Text -Credential $credential -ScriptBlock {get-childitem Env:}
        $main_form.Text = "SetScanner - $($vars | where-object name -like COMPUTERNAME | select -expandproperty Value)"
    }
}
$vars | foreach-object -process {$_ | Add-member -NotePropertyName Number -NotePropertyValue $varscounter; $varscounter++} 

#Set amount of text fields, set the starting point and how far each one will move
$breaks = [math]::Round(($main_form.Height / 25))
$drawpoint = 40
$movesize = 25

$P = Import-Csv -Path .\Environmentals_desc.csv 
$image = [System.Drawing.Image]::Fromfile("$PSScriptRoot\softlogo.png")
$pic = New-Object System.Windows.Forms.PictureBox
$pic.Width = 128
$pic.Height = 128
$pic.Location = new-object System.Drawing.Point(1110,10)
$pic.Image=$image
$main_form.Controls.Add($pic)
#Copy to clipboard button Function
function OnClick($Sender, $EventArgs){     
    $line = $Sender | Select-Object  -expandproperty Number
    if($Sender.varname -like $null)
    {
    $lineToCopy = $vars | where-object Number -eq $line | Select-object -ExpandProperty Value
    Set-Clipboard -Value $lineToCopy
    }
    if($Sender.varname -notlike $null)
    {
        $lineToCopy = $Sender.varname
        $textToCopy = $P | where-Object func -like $lineToCopy | select-Object -ExpandProperty desc
        $helpfunc = New-object System.Windows.Forms.Form
        $helpfunc.Text = "What is this?"
        $helpfunc.MaximizeBox = $false
        $helpfunc.MinimizeBox = $false
        $helpfunc.StartPosition = 'CenterScreen'
        $helpfunc.FormBorderStyle = 'FixedDialog'
        $helpfunc.Width = 500
        $helpfunc.Height = 200
        $helpfunc.AutoScale = $true  
        $helpname = new-object System.Windows.Forms.RichTextBox
        $helpname.height = 30
        $helpname.Width = 400
        $helpname.Location = New-Object System.Drawing.Point(10, 10)
        $oldFont = $helpname.Font
        $font = New-Object Drawing.Font($oldFont.FontFamily, $oldFont.Size, [Drawing.FontStyle]::Bold)
        $helpname.Font = $font
        $helpname.ReadOnly = $true
        $helpname.Text = "$lineToCopy"
        $helpdesc = new-object System.Windows.Forms.Label
        $helpdesc.height = 400
        $helpdesc.Width = 400
        $helpdesc.Location = New-Object System.Drawing.Point(10, 40)
        $helpdesc.Text = "$textToCopy"
        $helpfunc.Controls.Add($helpname)
        $helpfunc.Controls.Add($helpdesc)
        $helpfunc.ShowDialog()
    }
   
}
#main loop creating and filling fields.
for ($i = 1; $i -ne ($breaks - 3); $i = $i + 1)
{
    $nameWriteout = $vars | where-object Number -eq $i | Select-Object -ExpandProperty Name
    $valueWriteout = $vars | where-object Number -eq $i | Select-object -ExpandProperty Value
    new-variable -name "field$i"
    new-variable -name "label$i"
    new-variable -name "question$i"
    new-variable -name "copier$i"
    new-variable -name "value$i"
    $(get-variable -Name "field$i").Value = new-object System.Windows.Forms.TextBox
    $(get-variable -Name "field$i").Value.Height = 30
    $(get-variable -Name "field$i").Value.Width = 700
    $(get-variable -Name "field$i").Value.Location = New-Object System.Drawing.Point(250, $drawpoint)
    $(get-variable -Name "field$i").Value.ReadOnly = $true
    $(get-variable -Name "field$i").Value.Text = "$valueWriteout"
    $(get-variable -Name "label$i").Value = new-object System.Windows.Forms.Label
    $(get-variable -Name "label$i").Value.Height = 20
    $(get-variable -Name "label$i").Value.Width = 350
    $(get-variable -Name "label$i").Value.Location = New-Object System.Drawing.Point(10, $drawpoint)
    $(get-variable -Name "label$i").Value.Text = "$nameWriteout"
    $(get-variable -Name "question$i").Value = new-object System.Windows.Forms.Button
    $(get-variable -Name "question$i").Value.Height = 20
    $(get-variable -Name "question$i").Value.Width = 20
    $(get-variable -Name "question$i").Value.Location = New-Object System.Drawing.Point(960, $drawpoint)
    $(get-variable -Name "question$i").Value.Text = "?"
    $(get-variable -Name "question$i").Value | Add-Member -NotePropertyName varname -NotePropertyValue $nameWriteout
    $(get-variable -Name "question$i").Value.add_click({OnClick $this $_})
    $(get-variable -Name "copier$i").Value = new-object System.Windows.Forms.Button
    $(get-variable -Name "copier$i").Value.Height = 20
    $(get-variable -Name "copier$i").Value.Width = 120
    $(get-variable -Name "copier$i").Value.Location = New-Object System.Drawing.Point(980, $drawpoint)
    $(get-variable -Name "copier$i").Value.Text = "copy to clipboard"
    $(get-variable -Name "copier$i").Value | Add-Member -NotePropertyName Number -NotePropertyValue $i
    $(get-variable -Name "copier$i").Value.add_click({OnClick $this $_})

    
    $main_form.Controls.Add($(get-variable -Name "field$i").Value)
    $main_form.Controls.Add($(get-variable -Name "label$i").Value)
    $main_form.Controls.Add($(get-variable -Name "question$i").Value)
    $main_form.Controls.Add($(get-variable -Name "copier$i").Value)
    $drawpoint = $drawpoint + $movesize
}
$global:j = 0
$step = $i
write-host $j
$goup = new-object System.Windows.Forms.Button
$goup.Text = "Next Page"
$goup.Width = 128
$goup.height = 50
$goup.Location =  new-Object System.Drawing.Point(1110, 542)
$goup.Add_Click({
    
    if ($global:j+$step -le ($vars | measure).count){

        $global:j=$global:j+$step
        
        for ($i = 1;$i -ne ($breaks - 3); $i = $i + 1)
        
        {
            $nameWriteout2 = $vars | where-object Number -eq ($global:j+$i) | Select-Object -ExpandProperty Name
            $valueWriteout2 = $vars | where-object Number -eq ($global:j+$i) | Select-object -ExpandProperty Value
            $(get-variable -Name "label$i").Value.Text = "$nameWriteout2"
            $(get-variable -Name "field$i").Value.Text = "$valueWriteout2"
            $(get-variable -Name "question$i").Value.varname = $nameWriteout2
            $(get-variable -Name "copier$i").Value.Number = ($global:j+$i)
        }
    }
})
$godown = new-object System.Windows.Forms.Button
$godown.Text = "Previous Page"
$godown.Width = 128
$godown.height = 50
$godown.Location =  new-Object System.Drawing.Point(1110, 592)
$godown.Add_Click(
    {
    if (($global:j-$step) -ge 0) { 
    
        $global:j=$j-$step
    
        for ($i = 1; $i -ne ($breaks - 3); $i = $i + 1)
        {
            $nameWriteout2 = $vars | where-object Number -eq ($global:j+$i) | Select-Object -ExpandProperty Name
            $valueWriteout2 = $vars | where-object Number -eq ($global:j+$i) | Select-object -ExpandProperty Value
            $(get-variable -Name "label$i").Value.Text = "$nameWriteout2"
            $(get-variable -Name "field$i").Value.Text = "$valueWriteout2"
            $(get-variable -Name "question$i").Value.varname = $nameWriteout2
            $(get-variable -Name "copier$i").Value.Number = ($global:j+$i)
        }
    }

    }
    )

#Buttons to show the additional options
$servicesScanner = new-object System.Windows.Forms.Button
$servicesScanner.Text = "Scan Services"
$servicesScanner.Width = 128
$servicesScanner.height = 50
$servicesScanner.Location =  new-Object System.Drawing.Point(1110, 142)
$servicesScanner.Add_Click(
    {.\ServicesScanner.ps1}
)

$portScanner = new-object System.Windows.Forms.Button
$portScanner.Text = "Scan Ports"
$portScanner.Width = 128
$portScanner.height = 50
$portScanner.Location =  new-Object System.Drawing.Point(1110, 192)
$portScanner.Add_Click(
    {.\Portscanner.ps1}
)

$personalbutton = new-object System.Windows.Forms.Button
$personalbutton.Text = "Personal Variables"
$personalbutton.Width = 128
$personalbutton.height = 50
$personalbutton.Location =  new-Object System.Drawing.Point(1110, 242)
$personalbutton.Add_Click(
    {.\personal.ps1}
)

$searchbutton = new-object System.Windows.Forms.Button
$searchbutton.Text = "Search Variables"
$searchbutton.Width = 250
$searchbutton.height = 20
$searchbutton.Location =  new-Object System.Drawing.Point(850, 10)
$searchbutton.Add_Click(
    {
        .\searchlist.ps1
    }
)
$searchbar = new-object System.Windows.Forms.textbox
$searchbar.Width = 595
$searchbar.height = 50
$searchbar.Location =  new-Object System.Drawing.Point(250, 11)


$main_form.Controls.Add($searchbar)
$main_form.Controls.Add($searchbutton)
$main_form.Controls.Add($servicesScanner)
$main_form.Controls.Add($portScanner)
$main_form.Controls.Add($personalbutton)
$main_form.Controls.Add($extrasButton)
$main_form.Controls.Add($goup)
$main_form.Controls.Add($godown)
# Show the main form
$main_form.ShowDialog()