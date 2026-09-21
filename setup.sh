#!/bin/bash

# Directory di default impostata su $HOME
INSTALL_DIR="$HOME"

echo "=== Configurazione e Installazione SSH Manager ==="
echo "La directory di default è: $INSTALL_DIR"
read -p "Vuoi usare un'altra cartella o specificare un sottodivisione? (es. $HOME/ssh-manager) [Invio per usare $INSTALL_DIR]: " custom_dir

if [ ! -z "$custom_dir" ]; then
    INSTALL_DIR="$custom_dir"
fi

# Creazione della cartella
echo "Creazione della cartella in $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit

# Creazione dei file di configurazione vuoti e protetti
echo "Inizializzazione dei file di configurazione (servers.txt e auth.txt)..."
touch servers.txt auth.txt
chmod 600 servers.txt auth.txt

# Generazione del file docker-compose.yml pronto per l'uso
echo "Scrittura del file docker-compose.yml..."
cat << 'EOF' > docker-compose.yml
services:
  ssh-hub:
    image: ghcr.io/tuo-username/ssh-manager:latest   # Sostituisci con il tuo link Docker registry
    container_name: ssh-manager-app
    ports:
      - "8080:8080"
    volumes:
      - ./servers.txt:/app/servers.txt
      - ./auth.txt:/app/auth.txt
    environment:
      - SSH_HUB_USER=admin
      - SSH_HUB_PASS=admin
    restart: unless-stopped
EOF

echo "---------------------------------------------------"
echo "Installazione completata con successo!"
echo "I file si trovano in: $INSTALL_DIR"
echo "Per avviare l'applicazione, digita:"
echo "  cd $INSTALL_DIR && docker compose up -d"
echo "---------------------------------------------------"