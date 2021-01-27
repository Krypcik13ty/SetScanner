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


$func_form = New-object System.Windows.Forms.Form
$func_form.Text = ""
$func_form.Width = 320
$func_form.Height = 320
$func_form.AutoScale = $true
$func_form.MaximizeBox = $false
$func_form.MinimizeBox = $false
$func_form.StartPosition = 'CenterScreen'
$func_form.FormBorderStyle = 'FixedDialog'

$labelmachine = New-Object System.Windows.Forms.Label
$labelmachine.Location = New-Object System.Drawing.Point(30,60)
$labelmachine.Size = New-Object System.Drawing.Size(100,20)
$labelmachine.Text = 'Connect to:'
$func_form.Controls.Add($labelmachine)

$machinebar = new-object System.Windows.Forms.textbox
$machinebar.Width = 150
$machinebar.height = 50
$machinebar.Location =  new-Object System.Drawing.Point(130, 60)
$func_form.Controls.Add($machinebar)

$labeluser = New-Object System.Windows.Forms.Label
$labeluser.Location = New-Object System.Drawing.Point(30,11)
$labeluser.Size = New-Object System.Drawing.Size(100,20)
$labeluser.Text = 'Username:'
$func_form.Controls.Add($labeluser)

$labelpassword = New-Object System.Windows.Forms.Label
$labelpassword.Location = New-Object System.Drawing.Point(30,35)
$labelpassword.Size = New-Object System.Drawing.Size(100,20)
$labelpassword.Text = 'Password:'
$func_form.Controls.Add($labelpassword)

$usernamebar = new-object System.Windows.Forms.textbox
$usernamebar.Width = 150
$usernamebar.height = 50
$usernamebar.Location =  new-Object System.Drawing.Point(130, 11)
$func_form.Controls.Add($usernamebar)

$passwordbar = new-object System.Windows.Forms.textbox
$passwordbar.Width = 150
$passwordbar.height = 50
$passwordbar.UseSystemPasswordChar = $true
$passwordbar.Location =  new-Object System.Drawing.Point(130, 35)
$func_form.Controls.Add($passwordbar)

$func1button = new-object System.Windows.Forms.Button
$func1button.Text = "Connect"
$func1button.Width = 100
$func1button.height = 50
$func1button.Location =  new-Object System.Drawing.Point(130, 100)
$func1button.Add_Click(
{
    if($usernamebar.Text -notlike $null){
    $username = $usernamebar.Text
    [SecureString]$secureString = $passwordbar.Text | ConvertTo-SecureString -AsPlainText -Force 
    [PSCredential]$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureString
    }
    if ($machinebar.Text){
        if ((test-connection -Computername $machinebar.Text -Quiet) -like $true){
            if ($credential) {
            if ((invoke-command -ErrorAction SilentlyContinue -ComputerName $machinebar.Text -Credential $credential -ScriptBlock {hostname}) -like $machinebar.Text) {
                .\main.ps1
            }
            else
            {
                write-host "Incorrect Credentials"
            }
        }
        else 
        {
            if ((invoke-command -ErrorAction SilentlyContinue -ComputerName $machinebar.Text -ScriptBlock {hostname}) -like $machinebar.Text) {
                .\main.ps1
            }
            else
            {
                write-host "Incorrect Credentials"
            }
        }
    }
    else
    {
        write-host "Could not resolve the remote machine."
    }
    }
    else
    {
        .\main.ps1
    }
}
)
$func_form.Controls.Add($func1button)




$func_form.ShowDialog()