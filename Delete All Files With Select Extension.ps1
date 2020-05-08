#___________________Recursively deletes all files of select extension. Also deletes all image files under a KB size limit (image files are jpg, png, and gif)____________________________


$deletedCount = 0;

$folder = Read-Host -Prompt 'Enter a file path to scan through (this is recursive)'
$fileExtension = ((Read-Host -Prompt 'Enter non-image file extensions seperated by spaces') -replace '\s+', ' ').Trim() -split " ";
foreach($i in $fileExtension){
    $fileExtension[$fileExtension.IndexOf($i)] = $i.Trim();
    if($i[0] -ne  '.'){ 
        $fileExtension[$fileExtension.IndexOf($i)] = '.' + $i 
    }
}
$deleteFileSizeInBytes = [int](Read-Host -Prompt 'Delete all jpg, png, webp, and gif image files under this size in KB (leave blank if N/A)') 
$deleteFileSizeInBytes *= 1000 #convert KB to Bytes

$topLevelFolders =  Get-ChildItem $folder

for($i = 0; $i -lt $topLevelFolders.Count; $i++){
    Get-ChildItem $topLevelFolders[$i].Fullname  -Recurse | select FullName, Length, Extension | Foreach-Object {
        if($fileExtension.Contains($_.Extension) -or ($_.Length -lt $deleteFileSizeInBytes -and ($_.Extension -eq '.jpg' -or $_.Extension -eq '.png' -or $_.Extension -eq '.gif'))){ 
            Remove-Item -literalPath $_.FullName
            Write-Host $_
            $deletedCount++
        }
    }
}

Write-Host 'Deleted ' $deletedCount ' files.' -f Red;