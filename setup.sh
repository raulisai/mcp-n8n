#!/bin/bash
# ===================================================================
#   n8n MCP Manager - Instalador Completo para Linux/macOS
#   Este script configura todo automáticamente
# ===================================================================

echo ""
echo "============================================"
echo "  n8n MCP Manager - Setup Automático"
echo "============================================"
echo ""

# Verificar Python
echo "[1/5] Verificando Python..."
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] python3 no está instalado"
    echo "Instálalo usando tu gestor de paquetes (apt, brew, etc.)"
    exit 1
fi
echo "[OK] Python detectado: $(python3 --version)"
echo ""

# Instalar dependencias
echo "[2/5] Instalando dependencias de Python..."
if [ -f "core/requirements.txt" ]; then
    python3 -m pip install -q -r core/requirements.txt
    if [ $? -ne 0 ]; then
        echo "[ADVERTENCIA] Hubo un problema instalando dependencias"
        echo "Intentando instalar manualmente..."
        python3 -m pip install -q requests python-dotenv
    else
        echo "[OK] Dependencias instaladas desde requirements.txt"
    fi
else
    echo "[ADVERTENCIA] No se encontró core/requirements.txt"
    python3 -m pip install -q requests python-dotenv
fi
echo ""

# Crear .env si no existe
echo "[3/5] Configurando archivo .env..."
if [ ! -f ".env" ]; then
    cp core/.env.example .env
    echo "[OK] Archivo .env creado"
    echo ""
    echo "============================================"
    echo "  IMPORTANTE: Configura tu API Key"
    echo "============================================"
    echo ""
    echo "1. Obtener API Key en n8n: Settings > API"
    echo "2. Edita el archivo .env con tu clave y URL"
    echo ""
else
    echo "[OK] Archivo .env ya existe"
fi
echo ""

# Hacer ejecutable el comando
echo "[4/5] Configurando permisos..."
chmod +x n8n
echo "[OK] Comando 'n8n' es ahora ejecutable"
echo ""

# Verificando instalación
echo "[5/5] Verificando instalación..."
./n8n --help > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "[ERROR] El comando n8n no funciona correctamente"
    exit 1
fi
echo "[OK] El comando n8n funciona correctamente"
echo ""

echo "============================================"
echo "  Instalación Completada con Éxito!"
echo "============================================"
echo ""
echo "Para usar 'n8n' desde cualquier lugar, agrega esta carpeta a tu PATH:"
echo ""
echo "Ejecuta este comando (o agrégalo a tu ~/.bashrc o ~/.zshrc):"
echo "export PATH=\"\$PATH:$(pwd)\""
echo ""
echo "Ejemplos de uso:"
echo "  ./n8n list"
echo "  ./n8n --help"
echo ""
echo "============================================"
