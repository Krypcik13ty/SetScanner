$ErrorActionPreference = "SilentlyContinue"

Add-Type -assembly System.Windows.Forms

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

$main_form = New-object System.Windows.Forms.Form
$main_form.Text = "SetScanner"
$main_form.Width = 1480
$main_form.Height = 480
$main_form.AutoScale = $true

$breaks = $main_form.Height / 20
$drawpoint = 20
$movesize = 20
for ($i = 1; $i -ne ($breaks - 3); $i = $i + 1)
{
    new-variable -name "field$i"
    new-variable -name "label$i"
    $(get-variable -Name "field$i").Value = new-object System.Windows.Forms.TextBox
    $(get-variable -Name "field$i").Value.Height = 30
    $(get-variable -Name "field$i").Value.Width = 700
    $(get-variable -Name "field$i").Value.Location = New-Object System.Drawing.Point(60, $drawpoint)
    $(get-variable -Name "label$i").Value = new-object System.Windows.Forms.Label
    $(get-variable -Name "label$i").Value.Height = 20
    $(get-variable -Name "label$i").Value.Width = 70
    $(get-variable -Name "label$i").Value.Location = New-Object System.Drawing.Point(10, $drawpoint)
    $(get-variable -Name "label$i").Value.Text = "field$i"

    $main_form.Controls.Add($(get-variable -Name "field$i").Value)
    $main_form.Controls.Add($(get-variable -Name "label$i").Value)
    $drawpoint = $drawpoint + $movesize
}

$functionsbutton = new-object System.Windows.Forms.Button
$functionsbutton.Text = "Functions Panel"
$functionsbutton.Width = 100
$functionsbutton.height = 50
$functionsbutton.Location =  new-Object System.Drawing.Point(300, 100)


$personalbutton = new-object System.Windows.Forms.Button
$personalbutton.Text = "Personal Variables"
$personalbutton.Width = 100
$personalbutton.height = 50
$personalbutton.Location =  new-Object System.Drawing.Point(300, 150)


$functionsbutton.Add_Click(
    {.\launcher.ps1}
)

$personalbutton.Add_Click(
    {.\personal.ps1}
)

$main_form.Controls.Add($functionsbutton)
$main_form.Controls.Add($personalbutton)

$main_form.ShowDialog()