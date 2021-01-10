$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(800,900)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
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
$svcstatus = new-object System.Windows.Forms.RichTextBox
$svcstatus.height = 30
$svcstatus.Width = 300
$svcstatus.Location = New-Object System.Drawing.Point(480, 45)
$svclongname = new-object System.Windows.Forms.RichTextBox
$svclongname.height = 60
$svclongname.Width = 300
$svclongname.Location = New-Object System.Drawing.Point(480, 80)
$svcdetails = new-object System.Windows.Forms.RichTextBox
$svcdetails.height = 300
$svcdetails.Width = 300
$svcdetails.Location = New-Object System.Drawing.Point(480, 145)
$form.Controls.Add($svcname)
$form.Controls.Add($svcstatus)
$form.Controls.Add($svclongname)
$form.Controls.Add($svcdetails)
$listview1_ItemSelectionChanged=[System.Windows.Forms.ListViewItemSelectionChangedEventHandler]{
    #Event Argument: $_ = [System.Windows.Forms.ListViewItemSelectionChangedEventArgs]
    if($($_.IsSelected) -like $true)
    {
        $svcclicked = $($_.Item.Text)
        $svcname.Text = $($svcclicked)
        $svcstatus.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Status
        $svclongname.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty DisplayName
        $svcdetails.Text = $import | where-object Name -like "$($svcclicked)" | select-object -ExpandProperty Description
        
    }
}
$listBox.Add_ItemSelectionChanged($listview1_ItemSelectionChanged)

$import = get-service
$image1 = [System.Drawing.Image]::Fromfile('.\gear_on256.png')
$image2 = [System.Drawing.Image]::Fromfile('.\gear_off256.png')
$imageList = New-Object System.Windows.Forms.ImageList
$ImageList.Images.Add($image1)
$ImageList.Images.Add($image2)
$listBox.LargeImageList = $imageList

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




$form.ShowDialog()