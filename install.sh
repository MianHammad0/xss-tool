#!/bin/bash

echo "[*] Installing system dependencies..."
sudo apt update && sudo apt install -y \
    python3-pip \
    curl \
    jq \
    git \
    libpangocairo-1.0-0 \
    libcairo2 \
    libffi-dev \
    libssl-dev \
    build-essential

echo "[*] Installing Go (if not already installed)..."
if ! command -v go &> /dev/null; then
    wget https://golang.org/dl/go1.21.1.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz
    echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc
    source ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    rm go1.21.1.linux-amd64.tar.gz
fi

echo "[*] Installing Go tools..."
go install github.com/tomnomnom/waybackurls@latest
go install github.com/ameenmaali/urldedupe@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/sensepost/gowitness@latest

echo "[*] Installing Python requirements..."
pip3 install weasyprint

echo "[*] Creating payload and target files..."
touch target.txt
cat <<EOF > payloads.txt
"><svg onload=confirm(1)>
"><script>alert(1)</script>
"><img src=x onerror=alert(1)>
EOF

mkdir -p output

echo "[✓] All tools installed. You're ready to go!"
echo "→ Add your targets to target.txt"
echo "→ Run: ./script.sh"
