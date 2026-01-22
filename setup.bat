@echo off
REM ===================================================================
REM   n8n MCP Manager - Instalador Completo para Windows
REM   Este script configura todo automáticamente
REM ===================================================================

echo.
echo ============================================
echo   n8n MCP Manager - Setup Automatico
echo ============================================
echo.

REM Verificar Python
echo [1/5] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no esta instalado
    echo.
    echo Descargalo desde: https://python.org
    echo IMPORTANTE: Marca "Add Python to PATH" durante la instalacion
    echo.
    pause
    exit /b 1
)
echo [OK] Python detectado
echo.

REM Instalar dependencias
echo [2/5] Instalando dependencias de Python...
pip install --quiet requests python-dotenv
if errorlevel 1 (
    echo [ADVERTENCIA] Hubo un problema instalando dependencias
    echo Intentando continuar...
)
echo [OK] Dependencias instaladas
echo.

REM Crear .env si no existe
echo [3/5] Configurando archivo .env...
if not exist ".env" (
    copy core\.env.example .env >nul
    echo [OK] Archivo .env creado
    echo.
    echo ============================================
    echo   IMPORTANTE: Configura tu API Key
    echo ============================================
    echo.
    echo 1. Obtener API Key:
    echo    - Abre n8n ^> Settings ^> API
    echo    - Click "Create an API Key"
    echo    - Copia la clave
    echo.
    echo 2. Presiona ENTER para abrir el archivo .env
    pause >nul
    notepad .env
    echo.
) else (
    echo [OK] Archivo .env ya existe
    echo.
)

REM Configurar PATH
echo [4/5] Configurando comando global...
powershell -ExecutionPolicy Bypass -Command "$path='%CD%'; $userPath=[Environment]::GetEnvironmentVariable('Path','User'); if($userPath -notlike \"*$path*\"){$newPath=$userPath+';'+$path; [Environment]::SetEnvironmentVariable('Path',$newPath,'User'); Write-Host '[OK] Ruta agregada al PATH' -ForegroundColor Green} else {Write-Host '[OK] Ya estaba en el PATH' -ForegroundColor Yellow}"
echo.

REM Probar instalación
echo [5/5] Verificando instalacion...
echo.
call n8n.bat --help >nul 2>&1
if errorlevel 1 (
    echo [ERROR] El comando n8n no funciona correctamente
    echo Revisa la configuracion
    pause
    exit /b 1
)

echo [OK] Comando n8n funciona correctamente
echo.
echo ============================================
echo   Instalacion Completada con Exito!
echo ============================================
echo.
echo Siguientes pasos:
echo.
echo 1. Reinicia CMD (cierra esta ventana y abre una nueva)
echo 2. Ejecuta desde cualquier directorio:
echo.
echo    n8n list
echo.
echo 3. Ver ayuda:
echo.
echo    n8n --help
echo.
echo ============================================
echo   Como usar:
echo ============================================
echo.
echo n8n list                    # Listar workflows
echo n8n get ^<id^>                # Ver detalles
echo n8n activate ^<id^>          # Activar workflow
echo n8n run ^<id^>               # Ejecutar workflow
echo.
echo Documentacion: README.md
echo.
pause
