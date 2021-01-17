function Sort-ListViewColumn 
{
    <#
    .SYNOPSIS
        Sort the ListView's item using the specified column.

    .DESCRIPTION
        Sort the ListView's item using the specified column.
        This function uses Add-Type to define a class that sort the items.
        The ListView's Tag property is used to keep track of the sorting.

    .PARAMETER ListView
        The ListView control to sort.

    .PARAMETER ColumnIndex
        The index of the column to use for sorting.
        
    .PARAMETER  SortOrder
        The direction to sort the items. If not specified or set to None, it will toggle.
    
    .EXAMPLE
        Sort-ListViewColumn -ListView $listview1 -ColumnIndex 0
#>
    param(    
            [ValidateNotNull()]
            [Parameter(Mandatory=$true)]
            [System.Windows.Forms.ListView]$ListView,
            [Parameter(Mandatory=$true)]
            [int]$ColumnIndex,
            [System.Windows.Forms.SortOrder]$SortOrder = 'None')
    
    if(($ListView.Items.Count -eq 0) -or ($ColumnIndex -lt 0) -or ($ColumnIndex -ge $ListView.Columns.Count))
    {
        return;
    }
    
    #region Define ListViewItemComparer
        try{
        $local:type = [ListViewItemComparer]
    }
    catch{
    Add-Type -ReferencedAssemblies ('System.Windows.Forms') -TypeDefinition  @" 
    using System;
    using System.Windows.Forms;
    using System.Collections;
    public class ListViewItemComparer : IComparer
    {
        public int column;
        public SortOrder sortOrder;
        public ListViewItemComparer()
        {
            column = 0;
            sortOrder = SortOrder.Ascending;
        }
        public ListViewItemComparer(int column, SortOrder sort)
        {
            this.column = column;
            sortOrder = sort;
        }
        public int Compare(object x, object y)
        {
            if(column >= ((ListViewItem)x).ListView.Columns.Count ||
                column >= ((ListViewItem)x).SubItems.Count ||
                column >= ((ListViewItem)y).SubItems.Count)
                column = 0;
        
            if(sortOrder == SortOrder.Ascending)
                return String.Compare(((ListViewItem)x).SubItems[column].Text,`
 ((ListViewItem)y).SubItems[column].Text);
            else
                return String.Compare(((ListViewItem)y).SubItems[column].Text,`
 ((ListViewItem)x).SubItems[column].Text);
        }
    }
"@  | Out-Null
    }
    #endregion
    
    if($ListView.Tag -is [ListViewItemComparer])
    {
        #Toggle the Sort Order
        if($SortOrder -eq [System.Windows.Forms.SortOrder]::None)
        {
            if($ListView.Tag.column -eq $ColumnIndex -and $ListView.Tag.sortOrder -eq 'Ascending')
            {
                $ListView.Tag.sortOrder = 'Descending'
            }
            else
            {
                $ListView.Tag.sortOrder = 'Ascending'
            }
        }
        else
        {
            $ListView.Tag.sortOrder = $SortOrder
        }
        
        $ListView.Tag.column = $ColumnIndex
        $ListView.Sort()#Sort the items
    }
    else
    {
        if($Sort -eq [System.Windows.Forms.SortOrder]::None)
        {
            $Sort = [System.Windows.Forms.SortOrder]::Ascending    
        }
        
        #Set to Tag because for some reason in PowerShell ListViewItemSorter prop returns null
        $ListView.Tag = New-Object ListViewItemComparer ($ColumnIndex, $SortOrder) 
        $ListView.ListViewItemSorter = $ListView.Tag #Automatically sorts
    }
}

function Get-WindowsKey {
    ## function to retrieve the Windows Product Key from any PC
        param ($targets = ".")
    $hklm = 2147483650
    $regPath = "Software\Microsoft\Windows NT\CurrentVersion"
    $regValue = "DigitalProductId64"
    Foreach ($target in $targets) {
        $productKey = $null
        $win32os = $null
        $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
        $data = $wmi.GetBinaryValue($hklm,$regPath,$regValue)
        $binArray = ($data.uValue)[52..66]
        $charsArray = "B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9"
        ## decrypt base24 encoded binary data
        For ($i = 24; $i -ge 0; $i--) {
            $k = 0
            For ($j = 14; $j -ge 0; $j--) {
                $k = $k * 256 -bxor $binArray[$j]
                $binArray[$j] = [math]::truncate($k / 24)
                $k = $k % 24
            }
            $productKey = $charsArray[$k] + $productKey
            If (($i % 5 -eq 0) -and ($i -ne 0)) {
                $productKey = "-" + $productKey
            }
        }
        $win32os = Get-WmiObject Win32_OperatingSystem -computer $target
        $obj = New-Object Object
        $obj | Add-Member Noteproperty Computer -value $target
        $obj | Add-Member Noteproperty Caption -value $win32os.Caption
        $obj | Add-Member Noteproperty CSDVersion -value $win32os.CSDVersion
        $obj | Add-Member Noteproperty OSArch -value $win32os.OSArchitecture
        $obj | Add-Member Noteproperty BuildNumber -value $win32os.BuildNumber
        $obj | Add-Member Noteproperty RegisteredTo -value $win32os.RegisteredUser
        $obj | Add-Member Noteproperty ProductID -value $win32os.SerialNumber
        $obj | Add-Member Noteproperty ProductKey -value $productkey
        $obj
    }
}