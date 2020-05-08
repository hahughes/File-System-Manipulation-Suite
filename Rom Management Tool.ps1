#____________________Delete Duplicates Between Folders_________________________
#
function getFileInformation{
    $keepFolderPath   = Read-Host -Prompt 'Select a source folder (none of these files will be deleted)' #none of these are deleted
    isValidFolderPath($keepFolderPath);

    $forignFolderPath = Read-Host -Prompt 'Look for duplicate files in this folder' #delete/scan these files
    isValidFolderPath($forignFolderPath);

    $fileAction = Read-Host -Prompt 'What do you want to do with the dulpicate files? List Duplicates[0], Compare and Delete[1], Move Duplicates[2], Blind Delete Exact Match[5], Blind Delete Based on Title[10]'
    if($fileAction.trim() -eq ''){ $fileAction = 0;}
    
    if($fileAction -eq 2){
        $moveToFolderPath = Read-Host -Prompt 'Enter a path to move duplicate files to'
        isValidFolderPath($moveToFolderPath);
    }
}

function isValidFolderPath($_){
    if(!(Test-Path $_)){
        throw 'Invalid folder path.'
    }
    if(($forignFoldrePath -eq $keepFolderPath) -or ($moveToFolderPath -eq $keepFolderPath)){
        throw 'Source and destination folders cannot be the same.'
    }
}

if($keepFolderPath -ne $forignFolderPath){
    
#get file names and trim out any extra rom name data
    [array]$fullFileNames = (Get-ChildItem -Name $keepFolderPath);
    [array]$fullFilePaths = (Get-ChildItem $keepFolderPath);
    $keepFiles = New-Object System.Collections.Generic.List[System.Object];

    $temp = '';
    for($i=0; $i -lt $fullFileNames.Count; $i++){
        if($fullFileNames[$i].Contains('(')){
            $temp = $fullFileNames[$i].Substring(0, $fullFileNames[$i].IndexOf("(")).trim();
            if($temp.Contains('[')){
                $temp = $temp.Substring(0, $temp.IndexOf("[")).trim();
            }
        }
        elseif($fullFileNames[$i].Contains('[')){
            $temp = $fullFileNames[$i].Substring(0, $fullFileNames[$i].IndexOf("[")).trim();
        }
        $temp = $temp.Replace(' 2','II');
        $temp = $temp.Replace(' 3','III');
        $temp = $temp.Replace(' 4','IV');
        $temp = $temp.Replace(' 5','V');
        $temp = $temp.Replace(' ','');
        $temp = $temp.Replace('-','');
        $temp = $temp.Replace('+','');
        $temp = $temp.Replace('.','');
        $temp = $temp.Replace("'","");
        $keepFiles.Add($temp);
    }
        
    [array]$fullForignFile = Get-ChildItem $forignFolderPath;
    [array]$forignFileNames = $fullForignFile.Name;
    [array]$forignFilePath = $fullForignFile.FullName;
    $forignFiles = New-Object System.Collections.Generic.List[System.Object];
    
    $temp = ''
    for($i=0; $i -lt $forignFileNames.Count; $i++){
        if($forignFileNames[$i].Contains('(')){
            $temp = $forignFileNames[$i].Substring(0, $forignFileNames[$i].IndexOf("(")).trim();
            if($temp.Contains('[')){
                $temp = $temp.Substring(0, $temp.IndexOf("[")).trim();
            }
        }
        elseif($forignFileNames[$i].Contains('[')){
            $temp = $forignFileNames[$i].Substring(0, $forignFileNames[$i].IndexOf("[")).trim();
        }
        $temp = $temp.Replace(' 2','II');
        $temp = $temp.Replace(' 3','III');
        $temp = $temp.Replace(' 4','IV');
        $temp = $temp.Replace(' 5','V');
        $temp = $temp.Replace(' ','');
        $temp = $temp.Replace('-','');
        $temp = $temp.Replace('+','');
        $temp = $temp.Replace('.','');
        $temp = $temp.Replace("'","");
        $forignFiles.Add($temp);
    }

#remove duplicates
    $duplicateCounts = 0;
    for($i=0; $i -lt $forignFiles.Count; $i++){
        if($keepFiles -contains $forignFiles[$i]){
            for($j=0; $j -lt $fullFileNames.Count; $j++){
                if($forignFiles[$i] -eq $keepFiles[$j]){
                    $duplicateCounts++;
                    
                    Write-Host 'Files to keep: ' -f White  -nonewline; Write-Host $fullFilePaths[$j].Name -f Cyan;
                    Write-host 'Deleted files: ' -f Yellow -nonewline; Write-Host $forignFileNames[$i] -f red;
                    
                    if(($fileAction -eq 1) -and (Read-Host -Prompt 'Delete the duplicate file? (y/N)') -eq 'y'){
                        Remove-Item -literalPath $forignFilePath[$i] -Force;
                        Write-Host 'Deleted the file.' -f darkred;
                        break;
                    }
                    elseif($fileAction -eq 2){
                        Move-Item -LiteralPath $forignFilePath[$i] -Destination $moveToFolderPath;
                        Write-Host 'Moved the file.' -f darkred;
                        break;
                    }
                    elseif(($fileAction -eq 5) -and ($forignFileNames[$i] -eq $fullFilePaths[$j].Name)){
                        Remove-Item -literalPath $forignFilePath[$i] -Force;
                        Write-Host 'Deleted the file.' -f darkred;
                        break;
                    }
                    elseif($fileAction -eq 10){
                        Remove-Item -literalPath $forignFilePath[$i] -Force;
                        Write-Host 'Deleted the file.' -f darkred;
                        break;
                    }
                }
            }
        }
    }
    Write-Host 'Discovered' $duplicateCounts 'duplicate files.' -f Red
}