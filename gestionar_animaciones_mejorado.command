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

    echo "— VENTANAS"
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.0
    defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

    echo "— FINDER"
    defaults write com.apple.finder DisableAllAnimations -bool true

    echo "— ACCESIBILIDAD"
    abrir_configuracion_accesibilidad "activar"

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

    echo "— VENTANAS"
    defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || true
    defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null || true
    defaults delete NSGlobalDomain NSScrollAnimationEnabled 2>/dev/null || true

    echo "— FINDER"
    defaults delete com.apple.finder DisableAllAnimations 2>/dev/null || true

    echo "— ACCESIBILIDAD"
    abrir_configuracion_accesibilidad "desactivar"

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
    echo "1. 🚀 Aplicar configuración (example.yaml)"
    echo "2. 🔄 Restaurar configuración (como estaba)"
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
