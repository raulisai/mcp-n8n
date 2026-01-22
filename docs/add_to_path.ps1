# Script para agregar n8n al PATH del sistema automáticamente
# Ejecutar como: powershell -ExecutionPolicy Bypass -File add_to_path.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Agregando n8n al PATH del sistema" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Obtener la ruta actual del script
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$n8nPath = $scriptPath

Write-Host "[INFO] Ruta a agregar: $n8nPath" -ForegroundColor Yellow
Write-Host ""

# Obtener el PATH actual del usuario
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Verificar si ya está en el PATH
if ($userPath -like "*$n8nPath*") {
    Write-Host "[OK] La ruta ya está en el PATH del usuario" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "[INFO] Agregando al PATH del usuario..." -ForegroundColor Yellow
    
    # Agregar al PATH
    $newPath = $userPath + ";" + $n8nPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    
    Write-Host "[OK] Ruta agregada exitosamente al PATH!" -ForegroundColor Green
    Write-Host ""
}

# Actualizar el PATH en la sesión actual de PowerShell
$env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Configuración Completada!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Cierra y abre una NUEVA ventana de CMD/PowerShell" -ForegroundColor White
Write-Host "  2. Ejecuta: n8n list" -ForegroundColor White
Write-Host "  3. Verifica que funcione desde cualquier directorio" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
