$drivesToIndex = @("C:\", "D:\")
$indexPath = "$env:USERPROFILE\file_index.json"

$files = Get-ChildItem -Path $drivesToIndex -Recurse -File -Force -ErrorAction SilentlyContinue |
    Select-Object FullName, Name, Extension, LastWriteTime

$files | ConvertTo-Json -Depth 2 | Set-Content $indexPath -Encoding UTF8

Write-Output "Index written to $indexPath"
