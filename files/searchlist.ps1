$SearchView_ItemSelectionChanged=[System.Windows.Forms.ListViewItemSelectionChangedEventHandler]{
    if($($_.IsSelected) -like $true)
    {   
        $copybar.Text = $($_.Item.Text)
        $copyvariablebar.Text = $vars | where-object Name -Like $copybar.Text | Select-Object -ExpandProperty Value
        $infobar.Text = $P | where-Object func -like $copybar.Text | select-Object -ExpandProperty desc
    }
}
    $SearchForm = New-object System.Windows.Forms.Form
    $SearchForm.Icon = $icon
    $SearchForm.Text = "Search"
    $SearchForm.Width = 966
    $SearchForm.Height = 540
    $SearchForm.AutoScale = $true
    $SearchForm.MaximizeBox = $false
    $SearchForm.FormBorderStyle = 'FixedDialog'
    $SearchForm.StartPosition = 'CenterScreen'
    $Search = $vars | where-object Name -Match $searchbar.Text | Select-Object Name, Value
    $SearchList = New-Object System.Windows.Forms.ListView
    $Searchlist.FullRowSelect = $true
    $SearchList.Location = New-Object System.Drawing.Point(10,10)
    $SearchList.Size = New-Object System.Drawing.Size(622,480)
    $SearchList.View = 'Details'
    $SearchList.MultiSelect = $false
    [Void]$SearchList.Columns.Add("Name", 300, [System.Windows.Forms.HorizontalAlignment] "Center")
    [Void]$SearchList.Columns.Add("Value", 300, [System.Windows.Forms.HorizontalAlignment] "Center")
    ForEach($array in $Search){
        $item = New-Object System.Windows.Forms.ListviewItem($array.Name)
        $item.SubItems.Add("$($array.Value)")
        $SearchList.Items.Add($item)
    }
    $copybar = new-object System.Windows.Forms.textbox
    $copybar.Width = 300
    $copybar.height = 50
    $copybar.ReadOnly = $true
    $copybar.Location =  new-Object System.Drawing.Point(640, 10)
    $copyvariablebar = new-object System.Windows.Forms.richtextbox
    $copyvariablebar.Width = 300
    $copyvariablebar.height = 200
    $copyvariablebar.ReadOnly = $true
    $copyvariablebar.Location =  new-Object System.Drawing.Point(640, 30)
    $infobar = new-object System.Windows.Forms.richtextbox
    $infobar.Width = 300
    $infobar.height = 200
    $infobar.ReadOnly = $true
    $infobar.Location =  new-Object System.Drawing.Point(640, 230)
    $SearchList.Add_ItemSelectionChanged($SearchView_ItemSelectionChanged)
    $SearchForm.Controls.Add($infobar)
    $SearchForm.Controls.Add($copybar)
    $SearchForm.Controls.Add($copyvariablebar)
    $SearchForm.Controls.Add($SearchList)
    $SearchForm.ShowDialog()