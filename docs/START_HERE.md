<!-- Proyecto: n8n MCP Manager - Versión Simplificada -->

# 🚀 n8n MCP Manager

**Gestión de workflows de n8n desde CMD + Integración MCP para Google Antigravity**

---

## ⚡ INSTALACIÓN (1 comando)

```bash
setup.bat
```

Después: **Reinicia CMD** y usa `n8n` desde cualquier directorio.

---

## 📖 Documentación

### Para Empezar
- **[README.md](README.md)** - Guía completa (instalación, uso, troubleshooting)
- **[INDEX.md](INDEX.md)** - Navegación rápida

### Referencia Técnica
- **[core/README.md](core/README.md)** - Docs del motor MCP
- **[core/walkthrough.md](core/walkthrough.md)** - Integración con Antigravity

### Histórico
- **[docs/](docs/)** - Documentación de versiones anteriores
- **[SIMPLIFICATION.md](SIMPLIFICATION.md)** - Resumen de simplificación

---

## 💡 Uso Rápido

```bash
n8n list                   # Listar workflows
n8n activate <id>          # Activar workflow
n8n run <id>               # Ejecutar workflow
n8n --help                 # Ver ayuda completa
```

---

## 🔌 Integración MCP

```bash
# Copiar config a Antigravity
copy core\nantigravity_mcp_config.json %USERPROFILE%\.gemini\antigravity\mcp_config.json

# Importar workflow en n8n
# (ver README.md para detalles)
```

---

## 📂 Estructura

```
n8n/
├── setup.bat          # Instalador único
├── n8n.bat            # Comando global
├── README.md          # Guía principal
├── INDEX.md           # Índice
├── .env               #Config local
│
├── core/              # Motor MCP
│   ├── n8n_manager.py
│   ├── README.md
│   └── ...
│
├── docs/              # Referencias
└── workflow/          # Tus workflows
```

---

## ❓ Ayuda

- **Instalación**: Ver [README.md](README.md#instalación-rápida)
- **Problemas**: Ver [README.md](README.md#solución-de-problemas)
- **MCP**: Ver [core/walkthrough.md](core/walkthrough.md)

---

**Todo lo que necesitas está en [README.md](README.md)**

🚀 **Setup en 1 comando:** `setup.bat`
