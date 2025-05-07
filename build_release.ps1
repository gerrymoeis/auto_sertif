# Script untuk build release Auto Sertif
# Untuk Windows PowerShell

Write-Host "=== Auto Sertif Release Build Script ===" -ForegroundColor Cyan
Write-Host ""

$choice = Read-Host "Pilih platform untuk build (1: Android, 2: Windows, 3: Kedua-duanya)"

if ($choice -eq "1" -or $choice -eq "3") {
    Write-Host "Building Android APK release..." -ForegroundColor Yellow
    flutter build apk --release
    
    # Buat direktori releases jika belum ada
    if (-not (Test-Path -Path ".\releases")) {
        New-Item -ItemType Directory -Path ".\releases"
    }
    
    # Salin APK ke direktori releases
    Copy-Item -Path ".\build\app\outputs\flutter-apk\app-release.apk" -Destination ".\releases\auto_sertif_v1.0.0.apk"
    Write-Host "Android APK release build selesai!" -ForegroundColor Green
    Write-Host "File tersimpan di: .\releases\auto_sertif_v1.0.0.apk" -ForegroundColor Green
}

if ($choice -eq "2" -or $choice -eq "3") {
    Write-Host "Building Windows release..." -ForegroundColor Yellow
    flutter build windows --release
    
    # Buat direktori releases jika belum ada
    if (-not (Test-Path -Path ".\releases")) {
        New-Item -ItemType Directory -Path ".\releases"
    }
    
    # Buat direktori untuk Windows release
    $windowsReleaseDir = ".\releases\auto_sertif_windows_v1.0.0"
    if (-not (Test-Path -Path $windowsReleaseDir)) {
        New-Item -ItemType Directory -Path $windowsReleaseDir
    }
    
    # Salin file Windows build ke direktori releases
    Copy-Item -Path ".\build\windows\runner\Release\*" -Destination $windowsReleaseDir -Recurse
    
    # Buat file ZIP untuk Windows release
    Compress-Archive -Path $windowsReleaseDir -DestinationPath ".\releases\auto_sertif_windows_v1.0.0.zip" -Force
    
    Write-Host "Windows release build selesai!" -ForegroundColor Green
    Write-Host "File tersimpan di: .\releases\auto_sertif_windows_v1.0.0.zip" -ForegroundColor Green
}

Write-Host ""
Write-Host "Build release selesai!" -ForegroundColor Cyan
Write-Host "Semua file release tersimpan di folder 'releases'" -ForegroundColor Cyan
