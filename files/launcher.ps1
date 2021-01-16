$func_form = New-object System.Windows.Forms.Form
$func_form.Text = "SetScanner"
$func_form.Width = 320
$func_form.Height = 320
$func_form.AutoScale = $true

$func1button = new-object System.Windows.Forms.Button
$func1button.Text = "Super hyper function 1"
$func1button.Width = 100
$func1button.height = 50
$func1button.Location =  new-Object System.Drawing.Point(100, 100)
$func1button.Add_Click(
    {write-host "I'm gonna do some naughty stuff >:)"}
)
$func_form.Controls.Add($func1button)

$func2button = new-object System.Windows.Forms.Button
$func2button.Text = "Super hyper function 2"
$func2button.Width = 100
$func2button.height = 50
$func2button.Location =  new-Object System.Drawing.Point(100, 150)
$func2button.Add_Click(
    {write-host "I'm gonna do some naughty stuff >:)"}
)
$func_form.Controls.Add($func2button)


$func_form.ShowDialog()