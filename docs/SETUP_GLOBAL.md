# 🌍 Configurar n8n como Comando Global

Esta guía te muestra cómo hacer que el comando `n8n` funcione desde **cualquier directorio** en tu sistema Windows.

---

## ⚡ Método Rápido (Recomendado)

### Opción 1: Script Automático PowerShell

Este es el método más rápido y confiable:

```powershell
# Desde el directorio del proyecto, ejecuta:
powershell -ExecutionPolicy Bypass -File add_to_path.ps1
```

**Pasos:**
1. Abre CMD o PowerShell en `C:\Users\raul_\Documents\code\n8n`
2. Ejecuta el comando de arriba
3. Espera a que termine (te dirá que cierre y abra nueva consola)
4. **Cierra y abre una NUEVA ventana de CMD**
5. Prueba: `n8n list` (desde cualquier directorio)

✅ **¡Listo!** Ahora puedes usar `n8n` desde cualquier parte.

---

## 🔧 Método Manual (Alternativo)

Si prefieres hacerlo manualmente:

### Paso 1: Copiar la Ruta
```
C:\Users\raul_\Documents\code\n8n
```

### Paso 2: Abrir Configuración del Sistema
1. Presiona `Win + X`
2. Selecciona **System**
3. Click en **Advanced system settings** (lado derecho)
4. Click en **Environment Variables** (botón abajo)

### Paso 3: Editar el PATH
1. En la sección **User variables**, busca **Path**
2. Selecciónalo y click **Edit**
3. Click **New**
4. Pega: `C:\Users\raul_\Documents\code\n8n`
5. Click **OK** en todos los diálogos

### Paso 4: Reiniciar CMD
1. **Cierra TODAS las ventanas de CMD/PowerShell**
2. Abre una NUEVA ventana
3. Prueba: `n8n list`

---

## ✅ Verificar que Funciona

### Prueba 1: Desde el escritorio
```bash
cd C:\Users\raul_\Desktop
n8n list
```

### Prueba 2: Desde cualquier directorio
```bash
cd C:\
n8n list
```

### Prueba 3: Ver la versión
```bash
n8n --help
```

**Si ves la lista de comandos, ¡funciona! 🎉**

---

## ❓ Solución de Problemas

### "n8n no se reconoce como comando"

**Causa**: El PATH no se actualizó correctamente o no reiniciaste CMD.

**Solución**:
```bash
# 1. Verificar que la ruta está en el PATH
echo %PATH%
# Busca: C:\Users\raul_\Documents\code\n8n

# 2. Si no está, ejecuta el script PowerShell de nuevo
powershell -ExecutionPolicy Bypass -File add_to_path.ps1

# 3. Cierra y abre NUEVA ventana de CMD
```

### Verificar PATH Actual

**En CMD:**
```cmd
echo %PATH%
```

**En PowerShell:**
```powershell
$env:Path -split ';' | Select-String "n8n"
```

Si ves `C:\Users\raul_\Documents\code\n8n`, está configurado correctamente.

---

## 🔄 Actualizar PATH en Sesión Actual (Temporal)

Si no quieres reiniciar CMD, puedes actualizar el PATH temporalmente:

**CMD:**
```cmd
set PATH=%PATH%;C:\Users\raul_\Documents\code\n8n
n8n list
```

**PowerShell:**
```powershell
$env:Path += ";C:\Users\raul_\Documents\code\n8n"
n8n list
```

⚠️ **Nota**: Esto solo funciona en la sesión actual. Al cerrar CMD, se pierde.

---

## 🎯 Resumen

1. **Ejecuta**: `powershell -ExecutionPolicy Bypass -File add_to_path.ps1`
2. **Reinicia CMD**
3. **Prueba**: `n8n list` desde cualquier directorio

---

## 📚 Siguiente Paso

Una vez que `n8n` funcione globalmente:

1. **Configura tu API Key** en `.env`
2. **Lee la documentación**: [README.md](README.md)
3. **Empieza a usar**: `n8n list`, `n8n activate <id>`, etc.

---

**¿Necesitas ayuda?** Verifica [QUICK_START.md](QUICK_START.md) o [README.md](README.md)
