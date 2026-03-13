# Script para instalar todas las dependencias necesarias localmente
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configurando entorno de desarrollo..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Instalar Node.js (vía winget)
if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Node.js (LTS)..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    Write-Host "Node.js instalado. (Nota: Es posible que necesites reiniciar la terminal)" -ForegroundColor Green
} else {
    Write-Host "Node.js ya está instalado." -ForegroundColor Green
}

# 2. Instalar Python (vía winget)
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Python 3.12..." -ForegroundColor Yellow
    winget install --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    Write-Host "Python instalado." -ForegroundColor Green
} else {
    Write-Host "Python ya está instalado." -ForegroundColor Green
}

# 3. Instalar PyYAML (para validación de k8s)
Write-Host "Instalando PyYAML..." -ForegroundColor Yellow
python -m pip install pyyaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "PyYAML instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "Error instalando PyYAML. Asegúrate de que Python esté en el PATH." -ForegroundColor Red
}

Write-Host "`nEntorno configurado. Ahora puedes correr los tests con: .\run_tests.ps1" -ForegroundColor Cyan
