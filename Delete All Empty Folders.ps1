
$folder = Read-Host -Prompt 'Delete all empty folders (Recursive)'

do {
  $dirs = gci $folder -directory -recurse | Where { (gci $_.fullName).count -eq 0 } | select -expandproperty FullName
  $dirs | Foreach-Object { Remove-Item $_ }
} while ($dirs.count -gt 0)