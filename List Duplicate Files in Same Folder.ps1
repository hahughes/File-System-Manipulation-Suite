#___________________List Duplicates in a Folder____________________________
#
$translationFolder = Read-Host -Prompt 'Enter a file path'
$deleteFiles = Read-Host -Prompt 'Delete files? (y/N)'

$fullFiles = Get-ChildItem $translationFolder -Recurse | where {! $_.PSIsContainer};
$fullFileNames = $fullFiles.Name;
$fileNames = New-Object System.Collections.Generic.List[System.Object];
$temp = '';
    
#get file names and trim out any extra rom name data
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
    elseif($fullFileNames[$i] -match ".*\....$"){
        $temp = $fullFileNames[$i].Substring(0, $fullFileNames[$i].LastIndexOf(".")).trim();
    }
    $temp = $temp.Replace('2','II');
    $temp = $temp.Replace('3','III');
    $temp = $temp.Replace('4','IV');
    $temp = $temp.Replace('5','V');
    $temp = $temp.Replace(' ','');
    $temp = $temp.Replace('-','');
    $temp = $temp.Replace('+','');
    $temp = $temp.Replace('.','');
    $temp = $temp.Replace("'","");
    
    $fileNames.Add($temp);
}

if($deleteFiles -eq 'y'){$deletedFileCount = 0}

#list duplicates
$duplicateCount = 0;
for($i=0; $i -lt $fileNames.Count-1; $i++){
    for($j=$i+1; $j -lt $fileNames.Count; $j++){
        if($fileNames[$i] -eq $fileNames[$j]){
            $duplicateCount++;
            if($deleteFiles -eq 'y'){
                Write-Host 'File 1: ' $fullFileNames[$i] -f White;
                Write-Host 'File 2: ' $fullFileNames[$j] -f Yellow;
                $deleteYN = Read-Host -Prompt 'Delete which file? (1/2/[Neither])'
                if($deleteYN -eq '1'){
                    Remove-Item -literalPath $fullFiles[$i].fullname;
                    Write-Host 'Deleted the file.' -f darkred;
                    $deletedFileCount +=1;
                    break;
                }
                elseif($deleteYN -eq '2'){
                    Remove-Item -literalPath $fullFiles[$j].fullname;
                    Write-Host 'Deleted the file.' -f darkred;
                    $i++;
                    $deletedFileCount +=1;
                }
                else{
                    Write-Host 'No deleted files.' -f Green
                }
            }
            else{
                Write-Host $fullFileNames[$i] -f White;
                Write-Host $fullFileNames[$j] -f Yellow;
            }
        }
    }
}
Write-Host 'Total number of duplicates:' $duplicateCount -f Red;
if($deleteFiles -eq 'y'){
    Write-Host 'Total number of deleted Files:' $deletedFileCount -f Red;
 }
