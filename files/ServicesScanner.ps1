$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(800,900)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please make a selection from the list below:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListView
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(460,20)
$listBox.View = 'LargeIcon'
$listBox.MultiSelect = $false
$svcname = new-object System.Windows.Forms.RichTextBox
$svcname.height = 30
$svcname.Width = 300
$svcname.Location = New-Object System.Drawing.Point(480, 10)
$oldFont2 = $svcname.Font
$font2 = New-Object Drawing.Font($oldFont2.FontFamily, $oldFont2.Size, [Drawing.FontStyle]::Bold)
$svcname.Font = $font2
$svcname.ReadOnly = $true
$svcstatus = new-object System.Windows.Forms.RichTextBox
$svcstatus.height = 30
$svcstatus.Width = 300
$svcstatus.ReadOnly = $true
$svcstatus.Location = New-Object System.Drawing.Point(480, 45)
$svclongname = new-object System.Windows.Forms.RichTextBox
$svclongname.height = 60
$svclongname.Width = 300
$svclongname.ReadOnly = $true
$svclongname.Location = New-Object System.Drawing.Point(480, 80)
$svcdetails = new-object System.Windows.Forms.RichTextBox
$svcdetails.height = 300
$svcdetails.Width = 300
$svcdetails.ReadOnly = $true
$svcdetails.Location = New-Object System.Drawing.Point(480, 145)
$form.Controls.Add($svcname)
$form.Controls.Add($svcstatus)
$form.Controls.Add($svclongname)
$form.Controls.Add($svcdetails)
$listview1_ItemSelectionChanged=[System.Windows.Forms.ListViewItemSelectionChangedEventHandler]{
    if($($_.IsSelected) -like $true)
    {   
        $import = get-service
        $svcclicked = $($_.Item.Text)
        $svcname.Text = $($svcclicked)
        $svcstatus.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Status
        $svclongname.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty DisplayName
        $svcdetails.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Description
        
        if($svcstatus.Text -notlike "Running")
        {
            $resetButton.Enabled = $False
        }
        else
        {
            $resetButton.Enabled = $True
        }
        if($svcstatus.Text -like "Running")
        {
            $powerButton.Text = "Disable Service"
        }
        elseif ($svcstatus.Text -like "Stopped") 
        {      
            $powerButton.Text = "Enable Service"
        }
    }
}
$listBox.Add_ItemSelectionChanged($listview1_ItemSelectionChanged)

$image1 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\gear_on256.png")
$image2 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\gear_off256.png")
$imageList = New-Object System.Windows.Forms.ImageList
$ImageList.Images.Add($image1)
$ImageList.Images.Add($image2)
$listBox.LargeImageList = $imageList
$import = get-service
ForEach($array in $import){
    $item = New-Object System.Windows.Forms.ListviewItem($array.Name)
    
        if($array.Status -like "Running"){
            $item.ImageIndex = 0
        }
        else 
        {
            $item.ImageIndex = 1
        }
    $listBox.Items.Add($item)
}

$listBox.Height = 780
$form.Controls.Add($listBox)
$form.Topmost = $true

#Reset button

$resetButton = new-object System.Windows.Forms.Button
$resetButton.Text = "Restart Service"
$resetButton.Width = 128
$resetButton.height = 50
$resetButton.Location =  new-Object System.Drawing.Point(608, 450)
$resetButton.Add_Click(
    {
        $resetButton.Enabled = $False
        $selectedservice = $svcname.Text
        $resetButton.Text = "please wait"
        $import = get-service
        $form.Enabled = $false
        $ErrorActionPreference = "Stop"
        try
        {
            write-host "started try from Resetbutton"
            Restart-Service -Name $selectedservice
            write-host "finished try from Resetbutton"
            $resetButton.Text = "Service Restarted!"
            start-sleep -Seconds 2 
            $resetButton.Text = "Restart Service"
        }
        catch [Microsoft.PowerShell.Commands.ServiceCommandException]
        {          
            write-host "started first catch from Resetbutton"
            Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList "-command Restart-Service -Name $selectedservice"     
            write-host "finished first catch from Resetbutton"
            $resetButton.Text = "Service Restarted!"
            start-sleep -Seconds 2 
            $resetButton.Text = "Restart Service"
        }
        catch
        {
            write-host "started second catch from Resetbutton"
            $resetButton.Text = "Could not restart service!"
            start-sleep -Seconds 2 
            $resetButton.Text = "Restart Service"
            write-host "finished second catch from Resetbutton"
        }
        write-host "starting post..."
        $import = get-service
        $svcclicked = $($_.Item.Text)
        $svcname.Text = $($svcclicked)
        $svcstatus.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Status
        $svclongname.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty DisplayName
        $svcdetails.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Description
        if($svcstatus.Text -notlike "Running")
        {
            $resetButton.Enabled = $False
        }
        else
        {
            $resetButton.Enabled = $True
        }
        $form.Enabled = $true
        $ErrorActionPreference = "SilentlyContinue"
}
)
$powerButton = new-object System.Windows.Forms.Button
$powerButton.Width = 128
$powerButton.height = 50
$powerButton.Location =  new-Object System.Drawing.Point(480, 450)
$powerButton.Add_Click(
    {
            $powerButton.Enabled = $False
            $selectedservice = $svcname.Text
            $powerButton.Text = "please wait"
            $import = get-service
            $form.Enabled = $false
            $ErrorActionPreference = "Stop"
            try
            {  
                write-host "started try from Powerbutton"             
                if(($import | where-object Name -like "$selectedservice" | select-object -ExpandProperty Status) -like "Running")
                {
                    Stop-Service -Name $selectedservice
                    $($listbox.Items | Where-object Text -Like $selectedservice).ImageIndex = 1
                    $powerButton.Text = "Service Stopped!"
                    start-sleep -Seconds 2 
                    $powerButton.Text = "Enable Service"
                }
                else
                {
                    Start-Service -Name $selectedservice
                    $($listbox.Items | Where-object Text -Like $selectedservice).ImageIndex = 0
                    $powerButton.Text = "Service Started!"
                    start-sleep -Seconds 2 
                    $powerButton.Text = "Disable Service"
                }         
                write-host "finished try from Powerbutton"        
            }
            catch [Microsoft.PowerShell.Commands.ServiceCommandException]
            {               
                write-host "started catch from Powerbutton"  
                $powerButton.Text = "elevating..."
                if(($import | where-object Name -like "$selectedservice" | select-object -ExpandProperty Status) -like "Running")
                {
                    Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList "-command Stop-Service -Name $selectedservice"
                    $($listbox.Items | Where-object Text -Like $selectedservice).ImageIndex = 1
                    $powerButton.Text = "Service Stopped!"
                    start-sleep -Seconds 2 
                    $powerButton.Text = "Enable Service"
                }
                else
                {
                    Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList "-command Start-Service -Name $selectedservice"
                    $($listbox.Items | Where-object Text -Like $selectedservice).ImageIndex = 0
                    $powerButton.Text = "Service Started!"
                    start-sleep -Seconds 2 
                    $powerButton.Text = "Disable Service"
                   
                }          
                write-host "finished catch from Powerbutton"      
            }
            catch
            {
                write-host "started finally from Powerbutton"  
                $powerButton.Text = "Could turn off/on service!"
                start-sleep -Seconds 2 
                $powerButton.Text = ""
                write-host "finished finally from Powerbutton" 
            }
            $form.Enabled = $true
            $powerButton.Enabled = $true 
            $import = get-service
            $svcclicked = $($_.Item.Text)
            $svcname.Text = $($svcclicked)
            $svcstatus.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Status
            $svclongname.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty DisplayName
            $svcdetails.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Description
            $form.Enabled = $true
            $powerButton.Enabled = $true 
            if($svcstatus.Text -notlike "Running")
            {
                $resetButton.Enabled = $False
            }
            else
            {
                $resetButton.Enabled = $True
            }
            $ErrorActionPreference = "SilentlyContinue"
    }
)
$form.Controls.Add($resetButton)
$form.Controls.Add($powerButton)

$form.ShowDialog()