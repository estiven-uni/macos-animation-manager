#!/bin/bash

# Gestor de animaciones macOS (versión compacta y específica)
# Opción 1: aplica SOLO lo definido en example.yaml
# Opción 2: restaura SOLO a los valores indicados como "como estaban"

reiniciar_servicios_minimos() {
    # comentar que hace cada linea de codigo
    killall Dock 2>/dev/null || true # reinicia el dock
    killall Finder 2>/dev/null || true # reinicia el finder
    killall SystemUIServer 2>/dev/null || true # reinicia el systemUIServer
}

configurar_dock_personalizado() {
    echo "   [DOCK] Configurando aplicaciones específicas en el Dock..."
    
    # Limpiar el Dock completamente
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-others -array
    
    # Lista de aplicaciones a agregar al Dock
    local apps=(
        "/Applications/Claude.app"
        "/Applications/ChatGPT.app"
        "/Applications/Google Chrome.app"
        "/Applications/Safari.app"
        "/Applications/Firefox.app"
        "/Applications/Cursor.app"
        "/System/Applications/Utilities/Terminal.app"
        "/Applications/Slack.app"
        "/Applications/Spotify.app"
        "/Applications/WhatsApp.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Finder.app"
        "/System/Applications/Launchpad.app"
        "/Applications/Warp.app"
        "/Applications/DBeaver.app"    
        "/System/Applications/Reminders.app"
        "/System/Applications/System Settings.app"    
    )
    
    # Agregar cada aplicación al Dock
    for app in "${apps[@]}"; do
        if [ -e "$app" ]; then
            defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://$app</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
            echo "      ✓ Agregada: $(basename "$app")"
        else
            echo "      ⚠️  No encontrada: $(basename "$app")"
        fi
    done
    
    # Configurar auto-hide del Dock
    defaults write com.apple.dock autohide -bool true
    
    echo "   [DOCK] Aplicaciones personalizadas configuradas con auto-hide activado"
}

restaurar_dock_predeterminado() {
    echo "   [DOCK] Restaurando aplicaciones predeterminadas de macOS..."
    
    # Primero, eliminar completamente TODA la configuración del Dock
    defaults delete com.apple.dock 2>/dev/null || true
    
    # Esperar un momento para que se aplique
    sleep 0.5
    
    # Reiniciar el Dock para aplicar la eliminación completa
    killall Dock 2>/dev/null || true
    
    # Esperar a que el Dock se reinicie
    sleep 1
    
    # Ahora configurar las aplicaciones predeterminadas de macOS
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-others -array
    
    # Aplicaciones predeterminadas de macOS (configuración de fábrica)
    # Solo incluir aplicaciones que vienen preinstaladas con macOS
    local apps_default=(
        "/System/Applications/Finder.app"
        "/System/Applications/Launchpad.app"
        "/Applications/Safari.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Maps.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Notes.app"
        "/System/Applications/Reminders.app"
        "/System/Applications/Photos.app"
        "/System/Applications/Music.app"
        "/System/Applications/TV.app"
        "/System/Applications/App Store.app"
        "/System/Applications/System Settings.app"
    )
    
    # Agregar cada aplicación predeterminada al Dock
    for app in "${apps_default[@]}"; do
        if [ -e "$app" ]; then
            defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://$app</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
            echo "      ✓ Restaurada: $(basename "$app")"
        else
            echo "      ⚠️  No encontrada: $(basename "$app")"
        fi
    done
    
    # Agregar la papelera al final del Dock (lado derecho)
    defaults write com.apple.dock persistent-others -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://~/.Trash</string><key>_CFURLStringType</key><integer>0</integer></dict></dict><key>tile-type</key><string>directory-tile</string></dict>'
    
    # Configurar el Dock con valores predeterminados adicionales
    defaults write com.apple.dock tilesize -int 48
    defaults write com.apple.dock show-recents -bool true
    defaults write com.apple.dock minimize-to-application -bool false
    defaults write com.apple.dock autohide -bool true
    
    echo "   [DOCK] Aplicaciones predeterminadas restauradas con auto-hide activado"
}

abrir_configuracion_accesibilidad() {
    # $1: "activar" o "desactivar"
    local accion="$1"
    echo "   [ACC] Abriendo configuración de accesibilidad para $accion las opciones manualmente..."
    echo "   🔧 Debes $accion manualmente: Reducir movimiento y Reducir transparencia"

    # Abrir Accesibilidad y luego Pantalla (sin espera)
    open "x-apple.systempreferences:com.apple.preference.universalaccess"
    open "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Display"

    # Traer Ajustes al frente (compatibilidad Ventura/Sequoia y anteriores)
    osascript -e 'tell application "System Settings" to activate' 2>/dev/null || \
    osascript -e 'tell application "System Preferences" to activate' 2>/dev/null

    echo ""
    echo "   ✅ Configuración abierta. Realiza los cambios y presiona cualquier tecla cuando termines."
    read -n 1 -s
}

aplicar_configuracion_opcion_1() {
    echo "🚀 Aplicando configuración rápida (solo lo indicado en example.yaml)"
    echo "— DOCK"
    defaults write com.apple.dock mineffect -string "scale"
    defaults write com.apple.dock launchanim -bool false
    defaults write com.apple.dock autohide-delay -float 0.001
    defaults write com.apple.dock autohide-time-modifier -float 0.0
    defaults write com.apple.dock no-bouncing -bool true
    
    # Configurar aplicaciones personalizadas en el Dock
    configurar_dock_personalizado

    echo "— VENTANAS"
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.0
    defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

    echo "— FINDER"
    defaults write com.apple.finder DisableAllAnimations -bool true

    echo "— ACCESIBILIDAD"
    echo "   [ACC] Abriendo configuración de accesibilidad para activar las opciones manualmente..."
    echo "   🔧 Debes activar manualmente: Reducir movimiento y Reducir transparencia"
    open "x-apple.systempreferences:com.apple.preference.universalaccess"
    open "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Display"
    osascript -e 'tell application "System Settings" to activate' 2>/dev/null || \
    osascript -e 'tell application "System Preferences" to activate' 2>/dev/null
    echo ""
    echo "   ✅ Configuración abierta. Realiza los cambios y presiona cualquier tecla cuando termines."
    read -n 1 -s

    echo "— MISSION CONTROL"
    defaults write com.apple.dock expose-animation-duration -float 0.0
    defaults write com.apple.dock mru-spaces -bool true

    reiniciar_servicios_minimos
    echo "✅ Listo"
}

restaurar_configuracion_opcion_2() {
    echo "🔄 Restaurando configuración por defecto de macOS (como venía)"
    echo "— DOCK"
    defaults delete com.apple.dock mineffect 2>/dev/null || true
    defaults delete com.apple.dock launchanim 2>/dev/null || true
    defaults delete com.apple.dock autohide-delay 2>/dev/null || true
    defaults delete com.apple.dock autohide-time-modifier 2>/dev/null || true
    defaults delete com.apple.dock no-bouncing 2>/dev/null || true
    
    # Restaurar aplicaciones predeterminadas en el Dock
    restaurar_dock_predeterminado

    echo "— VENTANAS"
    defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || true
    defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null || true
    defaults delete NSGlobalDomain NSScrollAnimationEnabled 2>/dev/null || true

    echo "— FINDER"
    defaults delete com.apple.finder DisableAllAnimations 2>/dev/null || true

    echo "— ACCESIBILIDAD"
    echo "   [ACC] Abriendo configuración de accesibilidad para desactivar las opciones manualmente..."
    echo "   🔧 Debes desactivar manualmente: Reducir movimiento y Reducir transparencia"
    open "x-apple.systempreferences:com.apple.preference.universalaccess"
    open "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Display"
    osascript -e 'tell application "System Settings" to activate' 2>/dev/null || \
    osascript -e 'tell application "System Preferences" to activate' 2>/dev/null
    echo ""
    echo "   ✅ Configuración abierta. Realiza los cambios y presiona cualquier tecla cuando termines."
    read -n 1 -s

    echo "— MISSION CONTROL"
    defaults delete com.apple.dock expose-animation-duration 2>/dev/null || true
    defaults delete com.apple.dock mru-spaces 2>/dev/null || true

    reiniciar_servicios_minimos
    echo "✅ Listo"
}

mostrar_estado_detallado() {
    echo "📊 ESTADO DETALLADO DEL SISTEMA"
    echo "=================================="

    echo "🔹 DOCK:"
    echo "   Efecto minimizar: $(defaults read com.apple.dock mineffect 2>/dev/null || echo 'por defecto')"
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
    if [ "$(defaults read com.apple.finder DisableAllAnimations 2>/dev/null)" = "1" ]; then
        echo "   Animaciones: desactivadas"
    else
        echo "   Animaciones: activadas"
    fi

    echo ""
    echo "🔹 ACCESIBILIDAD:"
    echo "   Reducir movimiento: $(defaults read com.apple.universalaccess reduceMotion 2>/dev/null || echo '0')"
    echo "   Reducir transparencia: $(defaults read com.apple.universalaccess reduceTransparency 2>/dev/null || echo '0')"

    echo ""
    echo "🔹 MISSION CONTROL:"
    echo "   Duración animación: $(defaults read com.apple.dock expose-animation-duration 2>/dev/null || echo 'por defecto')"
    echo "   Reagrupar Spaces: $(defaults read com.apple.dock mru-spaces 2>/dev/null || echo 'activado')"

    echo "=================================="
}

validar_entrada() {
    case "$1" in
        [1-4]) return 0 ;;
        *) return 1 ;;
    esac
}

while true; do
    clear
    echo "⚡ GESTOR DE ANIMACIONES MACOS (compacto)"
    echo "========================================"
    echo "1. 🚀 Aplicar configuración + Dock personalizado"
    echo "2. 🔄 Restaurar configuración + Dock predeterminado"
    echo "3. 📊 Ver estado detallado"
    echo "4. 🚪 Salir"
    echo "========================================"
    echo -n "Selecciona una opción (1-4): "
    read opcion

    if ! validar_entrada "$opcion"; then
        echo "❌ Opción inválida. Intenta de nuevo."
        sleep 1.5
        continue
    fi

    case $opcion in
        1)
            clear
            aplicar_configuracion_opcion_1
            echo ""
            echo "Presiona cualquier tecla para continuar..."
            read -n 1 -s
            ;;
        2)
            clear
            restaurar_configuracion_opcion_2
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
            echo "¡Hasta luego! 👋"
            exit 0
            ;;
    esac
done
