# Définition des chemins
$ahkPath = "C:\Program Files\AutoHotkey\AutoHotkey.exe"
$ahkInstaller = "$env:TEMP\AutoHotkey_Installer.exe"
$downloadUrl = "https://www.autohotkey.com/download/1.1/AutoHotkey112301_Install.exe"

# Vérifier si AutoHotkey est déjà installé
if (-Not (Test-Path $ahkPath)) {
    Write-Host "🔍 AutoHotkey non détecté, téléchargement en cours..." -ForegroundColor Yellow

    # Vérifier la connexion Internet
    try {
        $webCheck = Invoke-WebRequest -Uri "https://www.google.com" -UseBasicParsing -TimeoutSec 5
        if ($webCheck.StatusCode -ne 200) {
            Write-Host "❌ Erreur : Pas d'accès à Internet. Vérifie ta connexion." -ForegroundColor Red
            Exit
        }
    } catch {
        Write-Host "❌ Erreur : Impossible de se connecter à Internet." -ForegroundColor Red
        Exit
    }

    # Télécharger AutoHotkey v1.1
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $ahkInstaller -Verbose
        Write-Host "✅ AutoHotkey téléchargé avec succès." -ForegroundColor Green
    } catch {
        Write-Host "❌ Erreur : Impossible de télécharger AutoHotkey. Vérifie l'URL ou ta connexion." -ForegroundColor Red
        Exit
    }

    # Vérifier si le fichier est bien téléchargé
    if (-Not (Test-Path $ahkInstaller)) {
        Write-Host "❌ Erreur : Le fichier AutoHotkey n'a pas été trouvé après téléchargement." -ForegroundColor Red
        Exit
    }

    Write-Host "📥 Installation d'AutoHotkey en cours..." -ForegroundColor Yellow

    # Installer AutoHotkey v1.1 en mode silencieux
    try {
        Start-Process -FilePath $ahkInstaller -ArgumentList "/S" -Wait -NoNewWindow
        Write-Host "⏳ Vérification de l'installation..." -ForegroundColor Yellow
    } catch {
        Write-Host "❌ Erreur : L'installation d'AutoHotkey a échoué." -ForegroundColor Red
        Exit
    }

    # Vérifier si l'installation a réussi
    if (Test-Path $ahkPath) {
        Write-Host "✅ AutoHotkey installé avec succès !" -ForegroundColor Green
    } else {
        Write-Host "❌ Échec de l'installation d'AutoHotkey. Installe-le manuellement ici : https://www.autohotkey.com/" -ForegroundColor Red
        Exit
    }
}

Write-Host "🚀 Lancement du script de spam de clics..." -ForegroundColor Cyan

# Code AutoHotkey intégré dans PowerShell
$ahkCode = @"
#Persistent
Toggle := False

F6::
    Toggle := !Toggle
    If (Toggle) {
        SoundBeep, 1000, 150  ; Son activé (ton haut)
        TrayTip, Spam Clic, ACTIVÉ (Maintenez le clic gauche), 1
    } Else {
        SoundBeep, 400, 150  ; Son désactivé (ton bas)
        TrayTip, Spam Clic, DÉSACTIVÉ, 1
    }
return

~LButton::
    While (Toggle AND GetKeyState("LButton", "P")) {
        Click
        Sleep 5  ; Réduit à 5 ms pour plus de rapidité
    }
return
"@

# Créer un fichier temporaire
$tempFile = "$env:TEMP\spam_click.ahk"
$ahkCode | Out-File -Encoding UTF8 $tempFile
Write-Host "✅ Script AutoHotkey créé temporairement : $tempFile" -ForegroundColor Green

# Lancer AutoHotkey avec le script temporaire
try {
    Start-Process -FilePath $ahkPath -ArgumentList $tempFile -PassThru -NoNewWindow
    Write-Host "✅ AutoHotkey lancé avec succès !" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur : Impossible de lancer AutoHotkey." -ForegroundColor Red
    Exit
}

Write-Host "🎮 Appuyez sur `F6` pour activer/désactiver le spam de clics." -ForegroundColor Cyan
Write-Host "❌ Fermez PowerShell pour arrêter complètement." -ForegroundColor Red

# Attendre que l'utilisateur ferme AutoHotkey avant de supprimer les fichiers temporaires
Wait-Process -Name AutoHotkey

# Supprimer le fichier temporaire après exécution
Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
Remove-Item -Path $ahkInstaller -Force -ErrorAction SilentlyContinue
Write-Host "🧹 Nettoyage terminé. Tous les fichiers temporaires ont été supprimés." -ForegroundColor Green
