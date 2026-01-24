#!/bin/bash
# ===================================================================
#   n8n MCP Manager - Despliegue Automatizado (Multi-plataforma)
#   Detecta el sistema y ejecuta la configuración robusta
# ===================================================================

OS_TYPE="$(uname)"

if [[ "$OS_TYPE" == "Linux" || "$OS_TYPE" == "Darwin" ]]; then
    echo "--- Detectado sistema Unix ($OS_TYPE) ---"
    chmod +x setup.sh
    ./setup.sh
elif [[ "$OS_TYPE" == *"NT"* || "$OS_TYPE" == "MINGW"* || "$OS_TYPE" == "CYGWIN"* ]]; then
    echo "--- Detectado sistema Windows (Unix-like environment) ---"
    ./setup.bat
else
    # Fallback for pure Windows if run from something that isn't bash but somehow executes this
    echo "Sistema no reconocido directamente por este script shell."
    echo "Si estás en Windows, ejecuta: setup.bat"
    echo "Si estás en Linux/macOS, ejecuta: bash setup.sh"
fi
