# Karkain Application SDK - build entry point (Windows PowerShell 5.1).
$ErrorActionPreference = "Stop"

$karkain = "F:\Codes\Git\Karkain\karkain.exe"
& $karkain --engine go build "src/app.kark" -o "build/app.exe"

Write-Output "Karkain Application SDK build succeeded: build/app.exe"
