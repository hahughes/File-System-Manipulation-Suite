$hash = @{}

$folder = Read-Host -Prompt 'Enter a file path to sort files through (this is recursive)'


Get-ChildItem $folder -Recurse | Select Extension, FullName, Name | where {! $_.PSIsContainer} | ForEach-Object{
    if($hash.Contains($_.Extension)){
        Move-Item -Path -LiteralPath $_ -Destination ($folder + '\' + $_.Extension + '\' + $_.Name)
    }
    else{
        $hash.Add($_.Extension, 1)
        New-Item -type Directory -Path ($folder + '\' + $_.Extension)
        Move-Item -Path $_ -Destination ($folder + '\' + $_.Extension + '\' + $_.Name)
    }
}
