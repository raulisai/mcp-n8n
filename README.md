# n8n MCP Manager

Gestor de workflows de **n8n** desde la línea de comandos con integración MCP para **Google Antigravity**.

---

## ⚡ Instalación Rápida

### Un Solo Comando (Automático)
Elige el comando según tu sistema para configurar todo al instante:

**Windows (CMD/PowerShell):**
```bash
deploy.bat
```

**Linux / macOS / iOS (Terminal):**
```bash
chmod +x deploy.sh && ./deploy.sh
```

**Eso es todo.** El script detectará tu sistema y automáticamente:
- ✅ Instalará dependencias de Python
- ✅ Configurará tu `.env`
- ✅ Creará el comando global `n8n`
- ✅ Agregará (o indicará cómo agregar) `n8n` al PATH del sistema
- ✅ Verificará que todo funcione

**Después**: Reinicia tu terminal y usa `n8n` desde cualquier directorio.

---

## 📋 Requisitos Previos

- **Python 3.8+** ([Descargar](https://python.org))
- **n8n instance** (local o remota)
- **API Key de n8n** ([Cómo obtenerla](#obtener-api-key))

---

## 🚀 Uso

Una vez instalado, usa `n8n` desde cualquier directorio:

```bash
# Listar workflows
n8n list

# Ver detalles de un workflow
n8n get <workflow_id>

# Activar un workflow
n8n activate <workflow_id>

# Desactivar un workflow
n8n deactivate <workflow_id>

# Ejecutar un workflow
n8n run <workflow_id>

# Ejecutar con datos
n8n run <workflow_id> --data '{"user": "raul", "action": "test"}'

# Crear workflow desde JSON
n8n create workflow.json

# Actualizar workflow
n8n update <workflow_id> workflow.json
```

---

## 🔑 Obtener API Key

1. Abre tu instancia n8n
2. Ve a **Settings** → **API**
3. Haz clic en **"Create an API Key"**
4. Copia la clave generada
5. Pégala en el archivo `.env`:
   ```env
   N8N_API_KEY=tu_clave_aqui
   N8N_URL=http://localhost:5678
   ```

---

## 📂 Estructura del Proyecto

```
n8n/
├── core/                       # Motor MCP (auto-contenido)
│   ├── n8n_manager.py         # CLI principal
│   ├── requirements.txt       # Dependencias Python
│   ├── nantigravity_mcp_config.json
│   ├── n8n_mcp_server_workflow.json
│   ├── walkthrough.md
│   └── .env.example
│
├── workflow/                   # Tus workflows
├── .agent/skills/n8n-manager/ # Skill de Antigravity
│
├── setup.bat                   # Instalador único
├── n8n.bat                    # Comando global
└── .env                       # Tu configuración
```

---

## 🤖 Integración con Google Antigravity

### Configurar MCP Server

```bash
# 1. Copiar configuración
copy core\nantigravity_mcp_config.json %USERPROFILE%\.gemini\antigravity\mcp_config.json

# 2. Importar workflow en n8n
# - Abre n8n
# - Importa: core/n8n_mcp_server_workflow.json
# - Activa el workflow

# 3. Reiniciar Antigravity
```

### Ejemplos de Uso con Antigravity

Una vez configurado, puedes pedirle a Antigravity:

- *"Lista todos mis workflows de n8n inactivos"*
- *"Activa el workflow de LinkedIn Gmail"*
- *"Crea un workflow que monitoree Gmail y envíe notificaciones a Telegram"*
- *"Ejecuta el workflow Ab12Cd34"*

Ver documentación completa: [core/walkthrough.md](core/walkthrough.md)

---

## 🆘 Solución de Problemas

### ❌ "n8n no se reconoce como comando"

**Causa**: El PATH no se actualizó o no reiniciaste CMD.

**Solución**:
```bash
# 1. Cerrar TODAS las ventanas de CMD
# 2. Abrir NUEVA ventana
# 3. Probar:
n8n --help

# Si sigue sin funcionar:
setup.bat
```

### ❌ "Error: N8N_API_KEY is required"

**Causa**: El archivo `.env` no existe o está vacío.

**Solución**:
```bash
# Crear .env desde plantilla
copy core\.env.example .env

# Editar con tu API Key
notepad .env

# Agregar:
# N8N_API_KEY=tu_clave_aqui
# N8N_URL=http://localhost:5678
```

### ❌ "python no se reconoce como comando"

**Causa**: Python no está instalado o no está en el PATH.

**Solución**:
1. Descarga Python desde [python.org](https://python.org)
2. Durante instalación, **marca "Add Python to PATH"**
3. Reinicia CMD
4. Ejecuta `setup.bat` de nuevo

### ❌ "HTTP Error 401"

**Causa**: Tu API Key es incorrecta o ha expirado.

**Solución**:
1. Genera una nueva API Key en n8n
2. Actualiza `.env` con la nueva clave
3. Prueba: `n8n list`

---

## 🔧 Configuración Manual

Si prefieres configurar manualmente:

### 1. Instalar Dependencias
```bash
# Opción A: Desde requirements.txt (recomendado)
pip install -r core\requirements.txt

# Opción B: Manual
pip install requests python-dotenv
```

### 2. Crear .env
```bash
copy core\.env.example .env
notepad .env
```

### 3. Agregar al PATH
1. Presiona `Win + X` → **System**
2. **Advanced system settings** → **Environment Variables**
3. Edita **Path** → Agrega: `C:\Users\raul_\Documents\code\n8n`
4. **OK** → Reinicia CMD

---

## 📚 Documentación Adicional

- **[core/README.md](core/README.md)** - Documentación técnica del motor
- **[core/walkthrough.md](core/walkthrough.md)** - Integración MCP completa
- **[INDEX.md](INDEX.md)** - Índice de toda la documentación

---

## 🎯 Ejemplos Prácticos

### Ejemplo 1: Activar un Workflow
```bash
# Listar workflows para obtener el ID
n8n list

# Salida:
# ID         | Active  | Name
# Ab12Cd34   | False   | Gmail Search Telegram

# Activar
n8n activate Ab12Cd34
```

### Ejemplo 2: Ejecutar con Datos
```bash
n8n run Ab12Cd34 --data "{\"query\": \"meetings\", \"limit\": 5}"
```

### Ejemplo 3: Crear desde Archivo
```bash
# Crear workflow desde JSON local
n8n create workflow\my_workflow.json
```

---

## 🔐 Seguridad

⚠️ **IMPORTANTE**:

- **Nunca** subas el archivo `.env` a repositorios públicos
- Rota tu API Key periódicamente
- El `.env` contiene credenciales sensibles

---

## ✨ Características

- ✅ **Comando global** - Usa `n8n` desde cualquier directorio
- ✅ **Gestión completa** - Lista, crea, actualiza, ejecuta workflows
- ✅ **Integración MCP** - Control desde Google Antigravity
- ✅ **Setup automático** - Instalación en un solo comando
- ✅ **Motor portable** - Todo el core en `core/` para fácil distribución

---

## 📞 Recursos

- **[n8n Documentation](https://docs.n8n.io/)** - Documentación oficial
- **[n8n API Reference](https://docs.n8n.io/api/)** - API REST
- **[n8n Community](https://community.n8n.io/)** - Foro de la comunidad

---

## 📝 Licencia

Proyecto de código abierto. Úsalo libremente para gestionar tus workflows de n8n.

---

**¿Listo para empezar?**

```bash
setup.bat
```

🚀 **¡Disfruta gestionando tus workflows!**
