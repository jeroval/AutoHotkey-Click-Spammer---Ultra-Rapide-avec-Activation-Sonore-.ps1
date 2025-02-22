# Vérifier si AutoHotkey est installé
$ahkPath1 = "C:\Program Files\AutoHotkey\AutoHotkey.exe"
$ahkPath2 = "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"

if (-Not (Test-Path $ahkPath1) -and -Not (Test-Path $ahkPath2)) {
    Write-Host "✅ AutoHotkey n'est pas installé sur ce système." -ForegroundColor Green
    Exit
}

Write-Host "🛑 Désinstallation d'AutoHotkey en cours..." -ForegroundColor Yellow

# Trouver la clé de désinstallation dans le registre
$uninstallKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$ahkUninstall = Get-ItemProperty -Path "$uninstallKey\*" | Where-Object { $_.DisplayName -match "AutoHotkey" }

if ($ahkUninstall) {
    $uninstallString = $ahkUninstall.UninstallString
    if ($uninstallString) {
        Write-Host "🚀 Lancement du programme de désinstallation..." -ForegroundColor Cyan
        Start-Process -FilePath $uninstallString -ArgumentList "/S" -Wait -NoNewWindow
    }
}

# Vérifier si la désinstallation a réussi
Start-Sleep -Seconds 5  # Attendre quelques secondes pour éviter un faux positif
if (-Not (Test-Path $ahkPath1) -and -Not (Test-Path $ahkPath2)) {
    Write-Host "✅ AutoHotkey a été désinstallé avec succès !" -ForegroundColor Green
} else {
    Write-Host "❌ Échec de la désinstallation. Essaie de le désinstaller manuellement depuis le Panneau de configuration." -ForegroundColor Red
}

# Supprimer les fichiers restants
Write-Host "🧹 Nettoyage des fichiers résiduels..." -ForegroundColor Yellow
Remove-Item -Path "C:\Program Files\AutoHotkey" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\AutoHotkey" -Recurse -Force -ErrorAction SilentlyContinue

# Supprimer les entrées du registre
Write-Host "🗑 Suppression des entrées du registre..." -ForegroundColor Yellow
Remove-Item -Path "$uninstallKey\AutoHotkey" -Force -ErrorAction SilentlyContinue

Write-Host "🧹 Nettoyage terminé ! AutoHotkey est complètement supprimé." -ForegroundColor Green
