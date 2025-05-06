#!/bin/bash

# Color codes
CYAN='\033[0;36m'
LIGHTBLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

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
echo -e "📣 Telegram Group: ${MAGENTA}https://t.me/KatayanAirdropGnC${RESET}"
echo

# Function to display steps
print_step() {
  echo -e "\n${CYAN}$1${RESET}"
}

# Function to handle errors
fail_exit() {
  echo -e "${RED}❌ $1 failed. Exiting.${RESET}"
  exit 1
}

print_step "🔧 Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y || fail_exit "System update"
sudo apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler screen || fail_exit "Dependency installation"

print_step "🦀 Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || fail_exit "Rust installation"
source $HOME/.cargo/env

print_step "🎯 Adding riscv32i target to Rust..."
rustup target add riscv32i-unknown-none-elf || fail_exit "Adding riscv32i target"

print_step "📦 Installing Nexus CLI..."
curl https://cli.nexus.xyz/ | sh || fail_exit "Nexus CLI installation"

read -p "🔑 Enter your Nexus Node ID (from app.nexus.xyz): " NODE_ID
echo "$NODE_ID" > ~/.nexus/node-id

print_step "📝 Creating Nexus node start script..."

cat <<EOF > $HOME/start_nexus_node.sh
#!/bin/bash
cd \$HOME
nexus > \$HOME/nexus_log.txt 2>&1
EOF

chmod +x $HOME/start_nexus_node.sh

print_step "📟 Starting Nexus CLI node in a screen session..."
# Check if the screen session already exists
if screen -list | grep -q "nexus"; then
  echo -e "${YELLOW}⚠️ Screen session 'nexus' already exists. Reusing the session.${RESET}"
else
  screen -dmS nexus $HOME/start_nexus_node.sh || fail_exit "Starting Nexus CLI node in screen"
fi

print_step "${GREEN}✅ Nexus CLI node setup complete!${RESET}"
echo -e "\nTo view the node logs, run: ${YELLOW}screen -r nexus${RESET}"
echo -e "To detach from the screen session, press: ${YELLOW}Ctrl+A then D${RESET}"
