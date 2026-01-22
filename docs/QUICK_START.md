# 🚀 Guía Rápida de Instalación

## Instalación en 3 pasos

### 1️⃣ Ejecuta el instalador automático

```bash
cd C:\Users\raul_\Documents\code\n8n
install.bat
```

Esto instalará automáticamente:
- ✅ Dependencias de Python (`requests`, `python-dotenv`)
- ✅ Archivo `.env` desde la plantilla
- ✅ Verificación del comando `n8n`

---

### 2️⃣ Configura tu API Key

```bash
notepad .env
```

Edita estas líneas:
```env
N8N_API_KEY=tu_clave_api_aqui
N8N_URL=http://localhost:5678
```

**¿Dónde obtener tu API Key?**
1. Abre n8n → Settings → API
2. Click en "Create an API Key"
3. Copia y pega en `.env`

---

### 3️⃣ Configura el comando global

**Opción A: Agregar al PATH (Recomendado)**

1. Presiona `Win + X` → **System**
2. **Advanced system settings** → **Environment Variables**
3. En **User variables**, selecciona **Path** → **Edit**
4. Click **New** y agrega:
   ```
   C:\Users\raul_\Documents\code\n8n
   ```
5. **OK** → **OK** → **Reinicia CMD**

**Opción B: Uso local (sin PATH)**

```bash
# Desde el directorio del proyecto
.\n8n list
```

---

## ✅ Verificar Instalación

```bash
# Probar comando
n8n list

# Si funciona, verás la lista de tus workflows
```

---

## 📚 Documentación Completa

- **[README.md](README.md)**: Guía completa de instalación y uso
- **[core/walkthrough.md](core/walkthrough.md)**: Integración con Google Antigravity
- **[core/.env.example](core/.env.example)**: Ejemplo de configuración
- **[core/README.md](core/README.md)**: Documentación técnica del motor MCP

---

## 🆘 Problemas Comunes

### "python no se reconoce como comando"
**Solución**: Instala Python desde [python.org](https://python.org) y marca "Add to PATH"

### "N8N_API_KEY is required"
**Solución**: Verifica que `.env` existe y contiene tu API Key

### "n8n no se reconoce como comando"
**Solución**: 
- Verifica que agregaste la ruta al PATH
- Reinicia CMD
- O usa `.\n8n` desde el directorio del proyecto

---

## 🎯 Uso Básico

```bash
# Listar workflows
n8n list

# Ver detalles de un workflow
n8n get <workflow_id>

# Activar workflow
n8n activate <workflow_id>

# Ejecutar workflow
n8n run <workflow_id> --data '{"key": "value"}'
```

---

¡Listo! Ahora tienes acceso completo a la gestión de n8n desde la línea de comandos 🎉
