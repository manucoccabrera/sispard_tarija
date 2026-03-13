# Script para validar manifiestos de Kubernetes localmente
Write-Host "Iniciando validación de manifiestos YAML en k8s/..." -ForegroundColor Cyan

$k8sFolder = "k8s"
if (-Not (Test-Path $k8sFolder)) {
    Write-Host "Error: No se encontró la carpeta '$k8sFolder'" -ForegroundColor Red
    exit 1
}

$files = Get-ChildItem -Path $k8sFolder -Filter "*.yaml"
if ($files.Count -eq 0) {
    Write-Host "No se encontraron archivos YAML en '$k8sFolder'." -ForegroundColor Yellow
    exit 0
}

$anyError = $false

foreach ($file in $files) {
    Write-Host "Validando $($file.Name)..." -NoNewline
    
    # Intentar parsear el YAML usando Python (similar al CI)
    $filePath = $file.FullName
    $result = python -c "import yaml; list(yaml.safe_load_all(open(r'$filePath')))" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
    } else {
        Write-Host " [ERROR]" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        $anyError = $true
    }
}

if ($anyError) {
    Write-Host "Validación fallida." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Todos los archivos son válidos." -ForegroundColor Green
    exit 0
}
