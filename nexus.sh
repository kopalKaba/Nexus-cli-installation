#!/bin/bash

# Colors
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
BOLD='\033[1m'

# Clear screen and logo
clear
cat << "EOF"
       █████ █████   █████ ██████████ ███████████ ███████████
      ░░███ ░░███   ░░███ ░░███░░░░░█░░███░░░░░░█░░███░░░░░░█
       ░███  ░███    ░███  ░███  █ ░  ░███   █ ░  ░███   █ ░ 
       ░███  ░███████████  ░██████    ░███████    ░███████   
       ░███  ░███░░░░░███  ░███░░█    ░███░░░█    ░███░░░█   
 ███   ░███  ░███    ░███  ░███ ░   █ ░███  ░     ░███  ░    
░░████████   █████   █████ ██████████ █████       █████      
 ░░░░░░░░   ░░░░░   ░░░░░ ░░░░░░░░░░ ░░░░░       ░░░░░       
EOF

echo -e "${YELLOW}${BOLD}🚀 Nexus CLI Node Installation Script${RESET}" 
echo -e "📣 Telegram: ${MAGENTA}https://t.me/KatayanAirdropGnC${RESET}"

echo -e "${CYAN}🔧 Updating system...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler screen

echo -e "${CYAN}🦀 Installing Rust...${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo -e "${CYAN}🎯 Adding riscv32i Rust target...${RESET}"
rustup target add riscv32i-unknown-none-elf

echo -e "${CYAN}📦 Installing Nexus CLI...${RESET}"
curl https://cli.nexus.xyz/ | sh

read -p "🔑 Enter your Nexus Node ID (from app.nexus.xyz): " NODE_ID
mkdir -p ~/.nexus
echo "$NODE_ID" > ~/.nexus/node-id

echo -e "${CYAN}📝 Creating Nexus start script...${RESET}"
cat <<EOF > $HOME/start_nexus_node.sh
#!/bin/bash
cd \$HOME
echo "🔁 Restarting Nexus CLI..." > \$HOME/nexus_log.txt
while true; do
  echo "[$(date)] Starting Nexus CLI Node..." >> \$HOME/nexus_log.txt
  nexus >> \$HOME/nexus_log.txt 2>&1
  echo "[$(date)] Nexus CLI crashed. Restarting in 5 seconds..." >> \$HOME/nexus_log.txt
  sleep 5
done
EOF

chmod +x $HOME/start_nexus_node.sh

echo -e "${CYAN}📟 Launching node in a screen session...${RESET}"
screen -dmS nexus bash $HOME/start_nexus_node.sh

echo -e "${GREEN}✅ Nexus node is now running in the background!${RESET}"
echo -e "📄 View logs: ${YELLOW}tail -f \$HOME/nexus_log.txt${RESET}"
echo -e "🧵 Reattach to screen: ${YELLOW}screen -r nexus${RESET}"
echo -e "❌ Detach from screen: Press ${YELLOW}Ctrl+A then D${RESET}"
