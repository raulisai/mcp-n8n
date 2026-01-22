@echo off
echo ============================================
echo   n8n MCP Manager - Instalacion Automatica
echo ============================================
echo.

REM 1. Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no esta instalado o no esta en el PATH
    echo Por favor instala Python desde https://python.org
    echo.
    pause
    exit /b 1
)

echo [OK] Python detectado
echo.

REM 2. Install Python dependencies
echo [INFO] Instalando dependencias de Python...
pip install --quiet requests python-dotenv
if errorlevel 1 (
    echo [ERROR] No se pudieron instalar las dependencias
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas
echo.

REM 3. Create .env file if it doesn't exist
if not exist ".env" (
    echo [INFO] Creando archivo .env...
    copy core\.env.example .env >nul
    echo [OK] Archivo .env creado
    echo.
    echo [IMPORTANTE] Edita el archivo .env con tu API Key de n8n
    echo            notepad .env
    echo.
) else (
    echo [OK] Archivo .env ya existe
    echo.
)

REM 4. Add to PATH (requires admin or manual)
echo [INFO] Para usar 'n8n' globalmente, agrega esta ruta al PATH:
echo        %CD%
echo.
echo Como agregar al PATH:
echo   1. Presiona Win + X ^> System ^> Advanced ^> Environment Variables
echo   2. Edita 'Path' en User variables
echo   3. Agrega: %CD%
echo   4. Reinicia CMD
echo.

REM 5. Test the command
echo [INFO] Probando el comando n8n...
echo.
call n8n.bat --help
if errorlevel 1 (
    echo [ERROR] El comando n8n no funciona correctamente
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Instalacion completada!
echo ============================================
echo.
echo Siguientes pasos:
echo   1. Edita .env con tu API Key: notepad .env
echo   2. Agrega %CD% al PATH del sistema
echo   3. Reinicia CMD y ejecuta: n8n list
echo.
echo Documentacion completa: README.md
echo.
pause
