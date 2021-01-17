. $PSScriptRoot\functions.ps1

$form = New-Object System.Windows.Forms.Form
$form.Text = 'PortScanner'
$form.Size = New-Object System.Drawing.Size(657,840)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$listBox = New-Object System.Windows.Forms.ListView
$listBox.Location = New-Object System.Drawing.Point(10,10)
$listBox.Size = New-Object System.Drawing.Size(622,20)
$listBox.View = 'Details'
$listBox.MultiSelect = $false

$listviewApplications_ColumnClick=[System.Windows.Forms.ColumnClickEventHandler]{
    #Event Argument: $_ = [System.Windows.Forms.ColumnClickEventArgs]
        Sort-ListViewColumn $this $_.Column
    }
$listBox.Add_ColumnClick($listviewApplications_ColumnClick)
$image1 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\bound_state.png")
$image2 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\close_wait.png")
$image3 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\established_state.png")
$image4 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\Listen_state.png")
$image5 = [System.Drawing.Image]::Fromfile("$PSScriptRoot\time_wait.png")
$imageList = New-Object System.Windows.Forms.ImageList
$ImageList.Images.Add($image1)
$ImageList.Images.Add($image2)
$ImageList.Images.Add($image3)
$ImageList.Images.Add($image4)
$ImageList.Images.Add($image5)
$listBox.SmallImageList = $imageList

[Void]$listBox.Columns.Add("LocalPort", 70)
[Void]$listBox.Columns.Add("State", 70, [System.Windows.Forms.HorizontalAlignment] "Center")
[Void]$listBox.Columns.Add("Local IP", 100, [System.Windows.Forms.HorizontalAlignment] "Center")
[Void]$listBox.Columns.Add("Outbound IP", 100, [System.Windows.Forms.HorizontalAlignment] "Center")
[Void]$listBox.Columns.Add("External?", 100, [System.Windows.Forms.HorizontalAlignment] "Center")
[Void]$listBox.Columns.Add("Used by", 160, [System.Windows.Forms.HorizontalAlignment] "Center")

$import = Get-NetTCPConnection
ForEach($array in $import){
    if ($array.AppliedSetting -like "Internet") {
        $external = "Yes"
    }
    else 
    {
        $external = "No"
    }
    $item = New-Object System.Windows.Forms.ListviewItem($array.LocalPort)
    $item.SubItems.Add("$($array.State)")
    $item.SubItems.Add("$($array.LocalAddress)")
    $item.SubItems.Add("$($array.RemoteAddress)")
    $item.SubItems.Add($external)
    $item.SubItems.Add("$(get-process -Id $array.OwningProcess | Select-Object -ExpandProperty ProcessName)")
        if($array.State -like "Bound"){
            $item.ImageIndex = 0
        }
        elseif ($array.State -like "CloseWait")
        {
            $item.ImageIndex = 1
        }
        elseif ($array.State -like "Established")
        {
            $item.ImageIndex = 2
        }
        elseif ($array.State -like "Listen")
        {
            $item.ImageIndex = 3
        }
        elseif ($array.State -like "TimeWait")
        {
            $item.ImageIndex = 4
        }
    $listBox.Items.Add($item)
}

$listBox.Height = 780
$form.Controls.Add($listBox)
$form.Topmost = $true

$form.ShowDialog()