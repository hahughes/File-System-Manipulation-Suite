#___________________Delete Files with Duplicate Checksum MD5____________________________
#

$folder = Read-Host -Prompt 'Enter a folder path'
$deleteFiles = Read-Host -Prompt 'Delete duplicate files? (Y/N)'

$hash = @{}
$dupCount = 0;

Get-ChildItem $folder -Recurse | where {! $_.PSIsContainer} | ForEach-Object{
    $tempMD5 = (Get-FileHash -LiteralPath $_.FullName -Algorithm MD5).Hash;
    if(! $hash.Contains($tempMD5)){
        $hash.Add($tempMD5,$_.FullName) #add hash, path
    }
    else{
        Write-Host '_______________________________________________________________' -f DarkGray;
        Write-Host 'Original  file : ' $hash[$tempMD5] -f White;
        Write-Host 'Duplicate file : ' $_.FullName -f red;
        $dupCount++;
        if($deleteFiles -eq 'Y'){
            Remove-Item -literalPath $_.fullname;
        } 
        else{
            Remove-Item -LiteralPath $_.FullName -WhatIf;
        }
    }
}

Write-Host 'Number of duplicate files:' $dupCount -f Red;