#!/bin/bash

# Script mejorado para gestionar animaciones en macOS
# Versión optimizada con máxima desactivación de efectos
# Autor: Sistema de gestión de animaciones avanzado
# Fecha: $(date)

# Función para crear backup de configuraciones
crear_backup() {
    echo "💾 Creando backup de configuraciones..."
    
    local backup_dir="$HOME/animaciones_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup de configuraciones principales
    defaults read com.apple.dock > "$backup_dir/dock_backup.plist" 2>/dev/null || true
    defaults read NSGlobalDomain > "$backup_dir/global_backup.plist" 2>/dev/null || true
    defaults read com.apple.finder > "$backup_dir/finder_backup.plist" 2>/dev/null || true
    defaults read com.apple.universalaccess > "$backup_dir/accessibility_backup.plist" 2>/dev/null || true
    
    echo "✅ Backup creado en: $backup_dir"
    echo "🔄 Presiona cualquier tecla para continuar..."
    read -n 1 -s
}

# Función para desactivar TODAS las animaciones (modo extremo)
desactivar_animaciones_extremo() {
    echo "🚀 DESACTIVANDO TODAS LAS ANIMACIONES - MODO EXTREMO"
    echo "=================================================="
    
    # === DOCK ===
    echo "🔧 Configurando Dock..."
    
    # MÉTODO ALTERNATIVO: Usar "suck" con configuraciones especiales
    # El efecto "suck" es el más rápido cuando se combina con estas configuraciones
    defaults write com.apple.dock mineffect -string "suck"
    defaults write com.apple.dock minimize-to-application -bool YES
    
    # Configuración crítica: Establecer duración de animación a 0
    defaults write com.apple.dock expose-animation-duration -float 0.0
    defaults write com.apple.dock springboard-page-duration -float 0.0
    defaults write com.apple.dock springboard-show-duration -float 0.0
    defaults write com.apple.dock springboard-hide-duration -float 0.0
    
    # Desactivar todas las animaciones relacionadas
    defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES
    defaults write com.apple.dock workspaces-edge-delay -float 0.0
    
    # Configuración adicional para hacer el Dock más rápido
    defaults write com.apple.Dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0
    defaults write com.apple.dock tilesize -int 48
    
    # Importante: Desactivar indicadores de aplicaciones para mayor velocidad
    defaults write com.apple.dock static-only -bool YES
    defaults write com.apple.dock show-process-indicators -bool NO
    
    # Intentar desactivar completamente las animaciones de minimizar
    defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool false
    defaults write com.apple.dock mouse-over-hilite-stack -bool false
    defaults write com.apple.dock static-only -bool true
    
    # Desactivar animaciones del Dock
    defaults write com.apple.dock launchanim -bool false
    defaults write com.apple.dock expose-animation-duration -float 0.0
    defaults write com.apple.dock springboard-show-duration -float 0.0
    defaults write com.apple.dock springboard-hide-duration -float 0.0
    defaults write com.apple.dock springboard-page-duration -float 0.0
    
    # Desactivar efectos de zoom y magnificación
    defaults write com.apple.dock magnification -bool false
    defaults write com.apple.dock largesize -float 16
    
    # Desactivar animación de rebote en Dock
    defaults write com.apple.dock no-bouncing -bool true
    
    # Acelerar auto-hide del Dock
    defaults write com.apple.dock autohide-delay -float 0.0
    defaults write com.apple.dock autohide-time-modifier -float 0.0
    
    # === CONFIGURAR APLICACIONES POR DEFECTO EN EL DOCK ===
    echo "🔧 Configurando aplicaciones por defecto en el Dock..."
    
    # Función auxiliar para agregar aplicación al Dock
    agregar_app_al_dock() {
        local app_path="$1"
        if [ -e "$app_path" ]; then
            defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
            echo "   ✓ Agregada: $(basename "$app_path")"
        else
            echo "   ✗ No encontrada: $(basename "$app_path")"
        fi
    }
    
    # Primero, limpiar el Dock actual
    defaults write com.apple.dock persistent-apps -array
    
    # Agregar las aplicaciones en orden
    agregar_app_al_dock "/Applications/Google Chrome.app"
    agregar_app_al_dock "/Applications/Firefox.app"
    agregar_app_al_dock "/Applications/Slack.app"
    agregar_app_al_dock "/System/Applications/Utilities/Terminal.app"
    agregar_app_al_dock "/Applications/ChatGPT.app"
    agregar_app_al_dock "/Applications/Cursor.app"
    
    # Forzar que los cambios se apliquen inmediatamente
    defaults write com.apple.dock static-only -bool false
    
    echo "✅ Dock optimizado y aplicaciones configuradas"
    
    # === VENTANAS Y SISTEMA ===
    echo "🔧 Configurando ventanas y sistema..."
    
    # Desactivar animaciones de ventanas
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
    defaults write NSGlobalDomain NSDocumentRevisionsWindowTransformAnimation -bool false
    defaults write NSGlobalDomain NSBrowserColumnAnimationSpeedMultiplier -float 0.0
    
    # Desactivar animaciones de diálogos
    defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
    defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
    defaults write NSGlobalDomain NSScrollViewRubberbanding -bool false
    
    # Desactivar efectos de transparencia
    defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
    
    # Desactivar animaciones de sheets
    defaults write NSGlobalDomain NSWindowCollectionBehavior -int 2
    
    echo "✅ Ventanas optimizadas"
    
    # === FINDER ===
    echo "🔧 Configurando Finder..."
    
    # Desactivar todas las animaciones del Finder
    defaults write com.apple.finder DisableAllAnimations -bool true
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    
    # Desactivar animaciones de zoom de iconos
    defaults write com.apple.finder FK_AppCentricShowSidebar -bool false
    defaults write com.apple.finder FXEnableRemoveFromDockWarning -bool false
    
    # Optimizar vista de archivos
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    
    echo "✅ Finder optimizado"
    
    # === MISSION CONTROL Y SPACES ===
    echo "🔧 Configurando Mission Control..."
    
    # Desactivar animaciones de Mission Control
    defaults write com.apple.dock expose-animation-duration -float 0.0
    defaults write com.apple.dock expose-group-apps -bool false
    
    # Desactivar animaciones de Spaces
    defaults write com.apple.dock workspaces-auto-swoosh -bool false
    defaults write com.apple.dock workspaces-edge-delay -float 0.0
    
    # Desactivar reagrupación automática de Spaces
    defaults write com.apple.dock mru-spaces -bool false
    
    echo "✅ Mission Control optimizado"
    
    # === LAUNCHPAD ===
    echo "🔧 Configurando Launchpad..."
    
    # Desactivar completamente animaciones de Launchpad
    defaults write com.apple.dock springboard-show-duration -float 0.0
    defaults write com.apple.dock springboard-hide-duration -float 0.0
    defaults write com.apple.dock springboard-page-duration -float 0.0
    
    echo "✅ Launchpad optimizado"
    
    # === MAIL ===
    echo "🔧 Configurando Mail..."
    
    # Desactivar animaciones de Mail
    defaults write com.apple.mail DisableReplyAnimations -bool true
    defaults write com.apple.mail DisableSendAnimations -bool true
    defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
    
    echo "✅ Mail optimizado"
    
    # === SAFARI ===
    echo "🔧 Configurando Safari..."
    
    # Desactivar animaciones de Safari
    defaults write com.apple.Safari WebKitInitialTimedLayoutDelay -float 0.0
    defaults write com.apple.Safari WebKitResourceTimedLayoutDelay -float 0.0
    
    echo "✅ Safari optimizado"
    
    # === ACCESIBILIDAD ===
    echo "🔧 Configurando accesibilidad..."
    
    # Reducir movimiento (esto desactiva muchas animaciones del sistema)
    defaults write com.apple.universalaccess reduceMotion -bool true
    defaults write com.apple.universalaccess reduceTransparency -bool true
    
    # Desactivar efectos de zoom
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool false
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 0
    
    echo "✅ Accesibilidad optimizada"
    
    # === EFECTOS DE SONIDO ===
    echo "🔧 Configurando efectos de sonido..."
    
    # Desactivar efectos de sonido de interfaz
    defaults write com.apple.systemsound com.apple.sound.beep.volume -float 0.0
    defaults write com.apple.systemsound com.apple.sound.uiaudio.enabled -bool false
    
    echo "✅ Efectos de sonido optimizados"
    
    # === ENERGY SAVER ===
    echo "🔧 Configurando ahorro de energía..."
    
    # Optimizar configuraciones de energía para rendimiento
    sudo pmset -a displaysleep 15
    sudo pmset -a disksleep 30
    sudo pmset -a sleep 60
    sudo pmset -a womp 0
    
    echo "✅ Ahorro de energía optimizado"
    
    # === REINICIAR SERVICIOS ===
    echo "🔄 Reiniciando servicios del sistema..."
    
    # Reiniciar servicios principales
    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true
    killall NotificationCenter 2>/dev/null || true
    
    # Limpiar cache de Launch Services
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
    
    echo "=================================================="
    echo "🎉 OPTIMIZACIÓN EXTREMA COMPLETADA!"
    echo "⚡ Tu Mac ahora está optimizado para máximo rendimiento"
    echo "💡 Todas las animaciones innecesarias han sido desactivadas"
    echo "📊 Reinicia tu Mac para aplicar todos los cambios"
}

# Función para activar animaciones (restaurar)
activar_animaciones() {
    echo "🔄 Restaurando animaciones por defecto..."
    echo "=========================================="
    
    # Restaurar Dock
    defaults delete com.apple.dock mineffect 2>/dev/null || true
    defaults delete com.apple.dock minimize-to-application 2>/dev/null || true
    defaults delete com.apple.dock minimize-duration 2>/dev/null || true
    defaults delete com.apple.dock springboard-minimize-duration 2>/dev/null || true
    defaults delete com.apple.dock launchanim 2>/dev/null || true
    defaults delete com.apple.dock expose-animation-duration 2>/dev/null || true
    defaults delete com.apple.dock springboard-show-duration 2>/dev/null || true
    defaults delete com.apple.dock springboard-hide-duration 2>/dev/null || true
    defaults delete com.apple.dock springboard-page-duration 2>/dev/null || true
    defaults delete com.apple.dock magnification 2>/dev/null || true
    defaults delete com.apple.dock no-bouncing 2>/dev/null || true
    defaults delete com.apple.dock autohide-delay 2>/dev/null || true
    defaults delete com.apple.dock autohide-time-modifier 2>/dev/null || true
    
    # Restaurar ventanas
    defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || true
    defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null || true
    defaults delete NSGlobalDomain NSDocumentRevisionsWindowTransformAnimation 2>/dev/null || true
    defaults delete NSGlobalDomain NSBrowserColumnAnimationSpeedMultiplier 2>/dev/null || true
    defaults delete NSGlobalDomain NSUseAnimatedFocusRing 2>/dev/null || true
    defaults delete NSGlobalDomain NSScrollAnimationEnabled 2>/dev/null || true
    defaults delete NSGlobalDomain NSScrollViewRubberbanding 2>/dev/null || true
    defaults delete NSGlobalDomain AppleEnableMenuBarTransparency 2>/dev/null || true
    
    # Restaurar Finder
    defaults delete com.apple.finder DisableAllAnimations 2>/dev/null || true
    
    # Restaurar Mission Control
    defaults delete com.apple.dock expose-group-apps 2>/dev/null || true
    defaults delete com.apple.dock workspaces-auto-swoosh 2>/dev/null || true
    defaults delete com.apple.dock workspaces-edge-delay 2>/dev/null || true
    defaults delete com.apple.dock mru-spaces 2>/dev/null || true
    
    # Restaurar Mail
    defaults delete com.apple.mail DisableReplyAnimations 2>/dev/null || true
    defaults delete com.apple.mail DisableSendAnimations 2>/dev/null || true
    defaults delete com.apple.mail DisableInlineAttachmentViewing 2>/dev/null || true
    
    # Restaurar Safari
    defaults delete com.apple.Safari WebKitInitialTimedLayoutDelay 2>/dev/null || true
    defaults delete com.apple.Safari WebKitResourceTimedLayoutDelay 2>/dev/null || true
    
    # Restaurar accesibilidad
    defaults delete com.apple.universalaccess reduceMotion 2>/dev/null || true
    defaults delete com.apple.universalaccess reduceTransparency 2>/dev/null || true
    
    # Restaurar efectos de sonido
    defaults delete com.apple.systemsound com.apple.sound.beep.volume 2>/dev/null || true
    defaults delete com.apple.systemsound com.apple.sound.uiaudio.enabled 2>/dev/null || true
    
    # Reiniciar servicios
    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true
    
    echo "=========================================="
    echo "🎉 Animaciones restauradas exitosamente!"
    echo "💡 Tu sistema ahora tiene todas las animaciones por defecto"
}

# Función para mostrar estado detallado
mostrar_estado_detallado() {
    echo "📊 ESTADO DETALLADO DEL SISTEMA"
    echo "=================================="
    
    echo "🔹 DOCK:"
    echo "   Efecto minimizar: $(defaults read com.apple.dock mineffect 2>/dev/null || echo 'sin efecto/por defecto')"
    echo "   Animaciones launch: $(defaults read com.apple.dock launchanim 2>/dev/null || echo 'activadas')"
    echo "   Auto-hide delay: $(defaults read com.apple.dock autohide-delay 2>/dev/null || echo 'por defecto')"
    echo "   Magnificación: $(defaults read com.apple.dock magnification 2>/dev/null || echo 'por defecto')"
    
    echo ""
    echo "🔹 VENTANAS:"
    echo "   Animaciones automáticas: $(defaults read NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || echo 'activadas')"
    echo "   Tiempo de resize: $(defaults read NSGlobalDomain NSWindowResizeTime 2>/dev/null || echo 'por defecto')"
    echo "   Scroll con animación: $(defaults read NSGlobalDomain NSScrollAnimationEnabled 2>/dev/null || echo 'activado')"
    
    echo ""
    echo "🔹 FINDER:"
    echo "   Animaciones: $(if [ "$(defaults read com.apple.finder DisableAllAnimations 2>/dev/null)" = "1" ]; then echo 'desactivadas'; else echo 'activadas'; fi)"
    
    echo ""
    echo "🔹 ACCESIBILIDAD:"
    echo "   Reducir movimiento: $(defaults read com.apple.universalaccess reduceMotion 2>/dev/null || echo 'desactivado')"
    echo "   Reducir transparencia: $(defaults read com.apple.universalaccess reduceTransparency 2>/dev/null || echo 'desactivado')"
    
    echo ""
    echo "🔹 MISSION CONTROL:"
    echo "   Duración animación: $(defaults read com.apple.dock expose-animation-duration 2>/dev/null || echo 'por defecto')"
    echo "   Reagrupar Spaces: $(defaults read com.apple.dock mru-spaces 2>/dev/null || echo 'activado')"
    
    echo "=================================="
}

# Función para configurar aplicaciones del Dock
configurar_dock_apps() {
    echo "🚀 CONFIGURANDO APLICACIONES DEL DOCK"
    echo "===================================="
    
    # Función auxiliar para agregar aplicación al Dock
    agregar_app_al_dock() {
        local app_path="$1"
        if [ -e "$app_path" ]; then
            defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
            echo "   ✓ Agregada: $(basename "$app_path")"
        else
            echo "   ✗ No encontrada: $(basename "$app_path")"
        fi
    }
    
    echo "🗑️  Limpiando Dock actual..."
    defaults write com.apple.dock persistent-apps -array
    
    echo ""
    echo "➕ Agregando aplicaciones en orden:"
    agregar_app_al_dock "/Applications/Google Chrome.app"
    agregar_app_al_dock "/Applications/Firefox.app"
    agregar_app_al_dock "/Applications/Slack.app"
    agregar_app_al_dock "/System/Applications/Utilities/Terminal.app"
    agregar_app_al_dock "/Applications/ChatGPT.app"
    agregar_app_al_dock "/Applications/Cursor.app"
    
    echo ""
    echo "🔄 Reiniciando Dock..."
    killall Dock
    
    echo ""
    echo "===================================="
    echo "✅ Dock configurado exitosamente!"
    echo "🎯 Las aplicaciones aparecerán en el orden solicitado"
}

# Función para limpiar sistema
limpiar_sistema() {
    echo "🧹 LIMPIANDO SISTEMA..."
    echo "======================="
    
    # Limpiar caches
    echo "🔄 Limpiando caches..."
    sudo rm -rf /System/Library/Caches/* 2>/dev/null || true
    rm -rf ~/Library/Caches/* 2>/dev/null || true
    
    # Limpiar logs
    echo "🔄 Limpiando logs..."
    sudo rm -rf /private/var/log/* 2>/dev/null || true
    rm -rf ~/Library/Logs/* 2>/dev/null || true
    
    # Reconstruir Launch Services
    echo "🔄 Reconstruyendo Launch Services..."
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
    
    # Limpiar DNS cache
    echo "🔄 Limpiando DNS cache..."
    sudo dscacheutil -flushcache
    
    echo "======================="
    echo "✅ Sistema limpiado exitosamente!"
}

# Validar entrada
validar_entrada() {
    case "$1" in
        [1-8]) return 0 ;;
        *) return 1 ;;
    esac
}

# Menú principal mejorado
while true; do
    clear
    echo "⚡ GESTOR DE ANIMACIONES MACOS - VERSIÓN OPTIMIZADA"
    echo "=================================================="
    echo "1. 🚀 Desactivar TODAS las animaciones (MODO EXTREMO)"
    echo "2. ✅ Activar todas las animaciones (RESTAURAR)"
    echo "3. 📊 Ver estado detallado del sistema"
    echo "4. 💾 Crear backup de configuraciones"
    echo "5. 🧹 Limpiar sistema (caches, logs, etc.)"
    echo "6. 🔄 Reiniciar servicios del sistema"
    echo "7. 🎯 Configurar aplicaciones del Dock"
    echo "8. 🚪 Salir"
    echo "=================================================="
    echo -n "Selecciona una opción (1-8): "
    
    read opcion
    
    if ! validar_entrada "$opcion"; then
        echo "❌ Opción inválida. Intenta de nuevo."
        sleep 2
        continue
    fi
    
    case $opcion in
        1)
            clear
            echo "⚠️  ADVERTENCIA: Esto desactivará TODAS las animaciones del sistema"
            echo "¿Estás seguro? Esto puede hacer que tu Mac se vea muy diferente."
            echo "¿Continuar? (y/n): "
            read -r respuesta
            if [[ "$respuesta" =~ ^[Yy]$ ]]; then
                crear_backup
                desactivar_animaciones_extremo
            else
                echo "Operación cancelada"
            fi
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        2)
            clear
            echo "🔄 Esto restaurará todas las animaciones por defecto"
            echo "¿Continuar? (y/n): "
            read -r respuesta
            if [[ "$respuesta" =~ ^[Yy]$ ]]; then
                activar_animaciones
            else
                echo "Operación cancelada"
            fi
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        3)
            clear
            mostrar_estado_detallado
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        4)
            clear
            crear_backup
            ;;
        5)
            clear
            echo "⚠️  Esto limpiará caches y logs del sistema"
            echo "¿Continuar? (y/n): "
            read -r respuesta
            if [[ "$respuesta" =~ ^[Yy]$ ]]; then
                limpiar_sistema
            else
                echo "Operación cancelada"
            fi
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        6)
            clear
            echo "🔄 Reiniciando servicios del sistema..."
            killall Dock 2>/dev/null || true
            killall Finder 2>/dev/null || true
            killall SystemUIServer 2>/dev/null || true
            killall NotificationCenter 2>/dev/null || true
            echo "✅ Servicios reiniciados"
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        7)
            clear
            configurar_dock_apps
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        8)
            echo "¡Hasta luego! 👋"
            exit 0
            ;;
    esac
done
