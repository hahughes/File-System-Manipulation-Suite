#____________________Delete Duplicates Between Folders_________________________
#
$keepFolderPath   = Read-Host -Prompt 'Keep files in this folder'
$forignFolderPath = Read-Host -Prompt 'Delete/move files in this folder' #can also count files w/o deleting/moving
if(($keepFolderPath -eq '') -or ($forignFolderPath -eq '')){
    throw 'Folder path left blank. Applicaiton terminated.'
}
$deleteFiles = Read-Host -Prompt 'What to do? Read[0], Delete(1), Move(2), Blind Delete Exact Dups(10), Blind Delete Simalar Dups(15)'
if($deleteFiles -eq ''){
    $deleteFiles = 0;
}
elseif($deleteFiles -eq 2){
    $deletedFolderPath = Read-Host -Prompt 'Enter a path to move duplicate files to'
    if($deletedFolderPath -eq ''){
        throw 'Folder path left blank. Application terminated.'
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
                    
                    if(($deleteFiles -eq 1) -and (Read-Host -Prompt 'Delete the duplicate file? (y/N)') -eq 'y'){
                        Remove-Item -literalPath $forignFilePath[$i] -Force;
                        Write-Host 'Deleted the file.' -f darkred;
                        break;
                    }
                    elseif($deleteFiles -eq 2){
                        Move-Item -LiteralPath $forignFilePath[$i] -Destination $deletedFolderPath;
                        Write-Host 'Moved the file.' -f darkred;
                        break;
                    }
                    elseif(($deleteFiles -eq 10) -and ($forignFileNames[$i] -eq $fullFilePaths[$j].Name)){
                        Remove-Item -literalPath $forignFilePath[$i] -Force;
                        Write-Host 'Deleted the file.' -f darkred;
                        break;
                    }
                    elseif($deleteFiles -eq 15){
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