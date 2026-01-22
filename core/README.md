# n8n MCP Core

Este directorio contiene el **motor completo del MCP (Model Context Protocol)** para la integración entre n8n y Google Antigravity.

## 📁 Contenido

### `n8n_manager.py`
**CLI principal** para gestión de workflows de n8n desde la línea de comandos.

**Uso:**
```bash
python n8n_manager.py list
python n8n_manager.py activate <id>
python n8n_manager.py run <id> --data '{"key": "value"}'
```

**Características:**
- ✅ Listar, crear, actualizar, eliminar workflows
- ✅ Activar/desactivar workflows
- ✅ Ejecutar workflows con datos personalizados
- ✅ Gestión de credenciales via `.env`

---

### `nantigravity_mcp_config.json`
**Configuración del servidor MCP** para Google Antigravity.

Este archivo debe copiarse a `~/.gemini/antigravity/mcp_config.json` para habilitar la integración.

**Configuración actual:**
- Servidor: `n8n-mcp`
- Endpoint: `https://n8n.neobyte.space/mcp-server/http`
- Autenticación: Bearer Token

---

### `n8n_mcp_server_workflow.json`
**Workflow de n8n** que actúa como servidor MCP.

Este workflow expone las siguientes herramientas via MCP:
- `search_workflows` - Buscar workflows
- `get_workflow_details` - Obtener detalles de un workflow
- `execute_workflow` - Ejecutar un workflow con inputs

**Instalación:**
1. Importa este JSON en tu instancia n8n
2. Configura las credenciales de la API
3. Activa el workflow

---

### `walkthrough.md`
**Guía técnica completa** de integración paso a paso.

Incluye:
- Configuración del servidor MCP en n8n
- Setup de Antigravity
- Ejemplos de prompts
- Troubleshooting

---

### `.env.example`
**Plantilla de configuración** con variables de entorno necesarias.

**Variables:**
- `N8N_API_KEY` - Tu clave API de n8n (requerida)
- `N8N_URL` - URL de tu instancia n8n (opcional)

**Uso:**
```bash
# Copiar a la raíz del proyecto
copy .env.example ..\.env

# Editar con tus credenciales
notepad ..\.env
```

---

## 🚀 Uso Independiente

Puedes usar este core de forma independiente sin los wrappers de conveniencia:

```bash
# Navegar al directorio core
cd core

# Usar directamente el manager
python n8n_manager.py --api-key YOUR_KEY --url https://n8n.example.com list
```

---

## 🔧 Dependencias

```bash
pip install requests python-dotenv
```

---

## 📚 Documentación Relacionada

- **[../README.md](../README.md)** - Documentación principal del proyecto
- **[../QUICK_START.md](../QUICK_START.md)** - Guía rápida de instalación
- **[walkthrough.md](walkthrough.md)** - Guía técnica completa

---

## 🔌 Integración con Antigravity

Para habilitar la integración MCP:

1. **Copia la configuración:**
   ```bash
   copy nantigravity_mcp_config.json %USERPROFILE%\.gemini\antigravity\mcp_config.json
   ```

2. **Importa el workflow en n8n:**
   - Abre n8n
   - Crea nuevo workflow
   - Importa `n8n_mcp_server_workflow.json`
   - Activa el workflow

3. **Reinicia Antigravity** para cargar los nuevos tools

---

## 🛠️ Desarrollo

Este core es modular y puede extenderse con:
- Nuevos comandos en `n8n_manager.py`
- Herramientas adicionales en el workflow MCP
- Integración con otros sistemas vía MCP

---

*Este motor MCP permite que Google Antigravity gestione tus workflows de n8n como si fueran parte de su conjunto de herramientas nativas.*
