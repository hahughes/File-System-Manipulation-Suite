$hash = @{}
$folder = 'A:\Recovery'


Get-ChildItem $folder -Recurse | where {! $_.PSIsContainer} | ForEach-Object{
    if(! $hash.Contains($_.Extension)){
        $hash.Add($_.Extension, 1)
    }
    else{
        $hash[$_.Extension]++
    }
}

$hash.getenumerator() | Sort-Object -Property Key