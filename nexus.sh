#!/bin/bash

# COLORS
CYAN='\033[0;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'
BOLD='\033[1m'

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
echo

# 1. SYSTEM UPDATE & DEPENDENCIES
echo -e "${CYAN}🔧 Updating system...${RESET}"
sudo apt update && sudo apt upgrade -y

echo -e "${CYAN}📦 Installing dependencies...${RESET}"
sudo apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler curl screen

# 2. INSTALL RUST
echo -e "${CYAN}🦀 Installing Rust...${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# 3. ADD RISC-V TARGET
echo -e "${CYAN}🎯 Adding riscv32i Rust target...${RESET}"
rustup target add riscv32i-unknown-none-elf

# 4. INSTALL NEXUS CLI
echo -e "${CYAN}📥 Installing Nexus CLI...${RESET}"
curl https://cli.nexus.xyz/ | sh

# 5. GET NODE ID
read -p "🔑 Enter your Nexus Node ID (from https://app.nexus.xyz): " NODE_ID
mkdir -p ~/.nexus
echo "$NODE_ID" > ~/.nexus/node-id

# 6. CREATE START SCRIPT
echo -e "${CYAN}⚙️ Creating start script...${RESET}"
cat <<EOF > $HOME/start_nexus_node.sh
#!/bin/bash
cd \$HOME
echo "y" | nohup nexus > \$HOME/nexus_log.txt 2>&1 &
echo \$! > \$HOME/nexus_pid.txt
EOF

chmod +x $HOME/start_nexus_node.sh

# 7. START NODE
echo -e "${CYAN}🚀 Starting Nexus node in background...${RESET}"
bash $HOME/start_nexus_node.sh

# 8. DONE
echo -e "${GREEN}✅ Nexus node setup complete!${RESET}"
echo
echo -e "📄 Logs: ${YELLOW}tail -f ~/nexus_log.txt${RESET}"
echo -e "🛑 Stop: ${YELLOW}kill \$(cat ~/nexus_pid.txt)${RESET}"
