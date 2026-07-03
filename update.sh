#!/bin/bash
set -e
# Asegurar que el sistema encuentre todas las herramientas de administración
export PATH=$PATH:/usr/sbin:/sbin:/usr/local/bin

echo "=========================================="
echo "   ACTUALIZANDO INFRAESTRUCTURA FEYA-OS   "
echo "=========================================="
echo ""

# 1. Ejemplo práctico: Aquí se descargará tu script de persistencia corregido en el futuro
# echo "[+] Actualizando herramientas base..."
# sudo wget -qO /usr/local/bin/persistence.sh https://raw.githubusercontent.com/pedidort-blip/Feya-OS/main/persistence.sh
# sudo chmod +x /usr/local/bin/persistence.sh

# 2. Mensaje de éxito
echo "------------------------------------------"
echo "[✔] ¡FEYA-OS se ha actualizado correctamente!"
echo "=========================================="
