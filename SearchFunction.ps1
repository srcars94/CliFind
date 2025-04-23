param([string]$Query)

$indexPath = "$env:USERPROFILE\file_index.json"
$recentScanPaths = @("C:\", "D:\")
$recentWindowHours = 24

# Load index from JSON
$indexed = @()
if (Test-Path $indexPath) {
    $indexed = Get-Content $indexPath | ConvertFrom-Json |
        Where-Object { $_.Name -like "*$Query*" }
}

# Get recent matching files
$recent = Get-ChildItem -Path $recentScanPaths -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
        $_.LastWriteTime -gt (Get-Date).AddHours(-$recentWindowHours) -and
        $_.Name -like "*$Query*"
    } |
    Select-Object @{n="FullName";e={$_.FullName}}, @{n="LastWriteTime";e={$_.LastWriteTime}}

# Combine and deduplicate
$results = ($indexed + $recent) |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Unique FullName, LastWriteTime

# Display results
if ($results.Count -eq 0) {
    Write-Host "No results found for '$Query'."
} else {
    $results | Out-GridView -Title "Search results for '$Query'" -PassThru
}
