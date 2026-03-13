# Script unificado para correr todos los tests localmente
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Iniciando todos los tests locales..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$anyError = $false

# 1. Backend Tests
Write-Host "`n[1/2] Ejecutando tests del Backend..." -ForegroundColor Yellow
Push-Location backend
npm test
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error en los tests del Backend." -ForegroundColor Red
    $anyError = $true
}
Pop-Location

# 2. K8s Validation
Write-Host "`n[2/2] Ejecutando validación de Kubernetes..." -ForegroundColor Yellow
if (Test-Path ".\validate_k8s.ps1") {
    powershell -ExecutionPolicy Bypass -File .\validate_k8s.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error en la validación de Kubernetes." -ForegroundColor Red
        $anyError = $true
    }
} else {
    Write-Host "Error: No se encontró validate_k8s.ps1" -ForegroundColor Red
    $anyError = $true
}

Write-Host "`n========================================" -ForegroundColor Cyan
if ($anyError) {
    Write-Host "Resultados: ALGUNOS TESTS FALLARON." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Resultados: TODOS LOS TESTS PASARON." -ForegroundColor Green
    exit 0
}
