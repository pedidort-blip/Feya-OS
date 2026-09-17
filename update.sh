#!/bin/bash

# ==============================================================================
# FEYA-OS HORIZON - REMOTE UPDATE SYSTEM (OTA)
# ==============================================================================
# Detener el script si ocurre cualquier error no controlado
set -e

REPO_URL="https://raw.githubusercontent.com/pedidort-blip/Feya-OS/main"
LOCAL_VERSION_FILE="/etc/feya/version"
LOG_FILE="/var/log/feya-update.log"

# Asegurar que existan los directorios del sistema
mkdir -p /etc/feya
mkdir -p /usr/share/feya/docs
mkdir -p /var/log

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== Iniciando comprobación de actualización de FEYA-OS ==="

# 1. Obtener versión local
IF_LOCAL_VER="0.0.0"
if [ -f "$LOCAL_VERSION_FILE" ]; then
    IF_LOCAL_VER=$(cat "$LOCAL_VERSION_FILE")
fi

# 2. Obtener versión remota desde GitHub
REMOTE_VER=$(curl -sL "$REPO_URL/version.txt" || echo "ERROR")

if [ "$REMOTE_VER" = "ERROR" ] || [ -z "$REMOTE_VER" ]; then
    log "Error: No se pudo conectar a GitHub o el archivo version.txt no existe. Abortando."
    exit 1
fi

# 3. Comprobar si hay cambios de versión
if [ "$IF_LOCAL_VER" = "$REMOTE_VER" ]; then
    log "El sistema está actualizado (Versión $IF_LOCAL_VER). No hay acciones pendientes."
    exit 0
fi

log "Nueva versión detectada: $REMOTE_VER (Versión actual: $IF_LOCAL_VER). Aplicando cambios..."

# ==============================================================================
# ZONA DE DESCARGAS Y DESPLIEGUE DE ARCHIVOS (MODIFICA AQUÍ SEGÚN LO QUE NECESITES)
# ==============================================================================

# A) Ejemplo: Instalar o actualizar un script/herramienta ejecutable
log "Instalando herramientas FEYA..."
curl -sL "$REPO_URL/files/feya-tool.sh" -o /usr/local/bin/feya-tool
chmod +x /usr/local/bin/feya-tool

# B) Ejemplo: Descargar documentos/PDFs al sistema
log "Descargando documentación oficial..."
curl -sL "$REPO_URL/files/manual_usuario.pdf" -o /usr/share/feya/docs/manual_usuario.pdf

# C) Ejemplo: Copiar un acceso directo al escritorio de todos los usuarios
if [ -d "/home/feya-os/Desktop" ]; then
    curl -sL "$REPO_URL/files/Manual.desktop" -o /home/feya-os/Desktop/Manual.desktop
    chmod +x /home/feya-os/Desktop/Manual.desktop
    chown feya-os:feya-os /home/feya-os/Desktop/Manual.desktop
fi

# D) Ejemplo: Actualizaciones del sistema Debian (Apt)
# sudo apt-get update && sudo apt-get install -y un_paquete_nuevo

# ==============================================================================
# FINALIZACIÓN
# ==============================================================================

# Actualizar el archivo de versión local para no volver a ejecutar esto
echo "$REMOTE_VER" > "$LOCAL_VERSION_FILE"
log "=== Actualización completada con éxito a la versión $REMOTE_VER ==="

exit 0
