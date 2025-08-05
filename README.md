# macOS Animation Manager

Un script avanzado para gestionar y optimizar las animaciones del sistema en macOS, diseñado para mejorar el rendimiento eliminando efectos visuales innecesarios.

## 🚀 Características

- **Modo Extremo**: Desactiva completamente todas las animaciones del sistema
- **Backup Automático**: Crea copias de seguridad antes de realizar cambios
- **Configuración Dock**: Optimiza y configura aplicaciones predeterminadas
- **Limpieza Sistema**: Elimina caches y archivos temporales
- **Restauración**: Restaura configuraciones originales cuando sea necesario
- **Estado Detallado**: Muestra el estado actual de todas las configuraciones

## 📋 Funcionalidades

1. **Desactivar animaciones extremo**: Elimina todas las animaciones del sistema para máximo rendimiento
2. **Restaurar animaciones**: Vuelve a la configuración por defecto
3. **Estado del sistema**: Muestra configuraciones actuales
4. **Backup de configuraciones**: Guarda configuraciones antes de cambios
5. **Limpieza del sistema**: Elimina caches y logs
6. **Reiniciar servicios**: Reinicia Dock, Finder y otros servicios
7. **Configurar Dock**: Establece aplicaciones predeterminadas

## 🛠️ Instalación

1. Descarga el archivo `gestionar_animaciones_mejorado.command`
2. Dale permisos de ejecución:
   ```bash
   chmod +x gestionar_animaciones_mejorado.command
   ```
3. Ejecuta el script:
   ```bash
   ./gestionar_animaciones_mejorado.command
   ```

## ⚠️ Advertencias

- Este script modifica configuraciones profundas del sistema macOS
- Siempre se crean backups automáticamente antes de realizar cambios
- Se recomienda reiniciar el sistema después de aplicar cambios
- Testado en macOS Sequoia, pero compatible con versiones anteriores

## 🔧 Aplicaciones incluidas en configuración Dock

- Google Chrome
- Firefox  
- Slack
- Terminal
- ChatGPT
- Cursor

## 📝 Notas

- El script incluye validación de entrada y manejo de errores
- Interfaz interactiva con menús claros
- Funciona de manera no destructiva (con backups)
- Optimizado para desarrolladores y usuarios avanzados

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue primero para discutir los cambios propuestos.

## 📄 Licencia

Este proyecto es de uso libre. Úsalo bajo tu propia responsabilidad.
