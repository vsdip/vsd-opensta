#!/usr/bin/env bash

set -euo pipefail

OPENLANE_DIR="$HOME/Desktop/OpenLane"
PDK_ROOT_DEFAULT="$HOME/.ciel"
PDK_NAME="sky130A"
STD_CELL_LIBRARY="sky130_fd_sc_hd"

echo "[setup] Installing required runtime packages"

sudo apt-get update
sudo apt-get install -y \
    python3-pip \
    python3-venv \
    python3.10-venv \
    rsync

echo "[setup] Preparing OpenLane"

if [ ! -d "$OPENLANE_DIR/.git" ]; then
    mkdir -p "$(dirname "$OPENLANE_DIR")"

    git clone \
        --depth 1 \
        --branch superstable \
        https://github.com/The-OpenROAD-Project/OpenLane.git \
        "$OPENLANE_DIR"
else
    echo "[setup] OpenLane already exists"
fi

cd "$OPENLANE_DIR"

echo "[setup] Installing matched SKY130 PDK using CIEL"

make pdk

echo "[setup] Configuring environment"

if ! grep -q "VSD-OPENSTA-SKY130-BEGIN" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# VSD-OPENSTA-SKY130-BEGIN
export PDK_ROOT="$HOME/.ciel"
export PDK="sky130A"
export STD_CELL_LIBRARY="sky130_fd_sc_hd"

export SKY130A_ROOT="$PDK_ROOT/$PDK"

export SKY130_HD_LIB="$SKY130A_ROOT/libs.ref/$STD_CELL_LIBRARY/lib/${STD_CELL_LIBRARY}__tt_025C_1v80.lib"

export SKY130_HD_LEF="$SKY130A_ROOT/libs.ref/$STD_CELL_LIBRARY/lef/${STD_CELL_LIBRARY}__nominal__30C_1v80.lef"

alias ol='cd "$HOME/Desktop/OpenLane"'
alias pdk='cd "$HOME/.ciel/sky130A"'
# VSD-OPENSTA-SKY130-END
EOF
fi

export PDK_ROOT="$PDK_ROOT_DEFAULT"
export PDK="$PDK_NAME"
export STD_CELL_LIBRARY="$STD_CELL_LIBRARY"

SKY130A_ROOT="$PDK_ROOT/$PDK"
SKY130_HD_LIB="$SKY130A_ROOT/libs.ref/$STD_CELL_LIBRARY/lib/${STD_CELL_LIBRARY}__tt_025C_1v80.lib"

echo "[setup] Verifying SKY130 PDK"

if [ ! -d "$SKY130A_ROOT" ]; then
    echo "[ERROR] SKY130A PDK was not found"
    exit 1
fi

if [ ! -f "$SKY130_HD_LIB" ]; then
    echo "[ERROR] SKY130 Liberty file was not found:"
    echo "$SKY130_HD_LIB"
    exit 1
fi

echo
echo "[setup] SKY130 PDK installed successfully"
echo "[setup] PDK_ROOT: $PDK_ROOT"
echo "[setup] PDK: $PDK"
echo "[setup] Standard cell library: $STD_CELL_LIBRARY"
echo "[setup] Liberty file: $SKY130_HD_LIB"
echo
echo "[setup] Open a new terminal to load the environment"
