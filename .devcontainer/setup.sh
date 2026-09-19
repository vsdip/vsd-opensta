#!/usr/bin/env bash

set -euo pipefail

OPENLANE_DIR="$HOME/Desktop/OpenLane"
PDK_ROOT_DEFAULT="$HOME/.ciel"
PDK_NAME="sky130A"
STD_LIB="sky130_fd_sc_hd"

echo "[setup] Cloning OpenLane"

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

echo "[setup] Installing SKY130 PDK using CIEL"

make pdk

echo "[setup] Configuring SKY130 environment"

if ! grep -q "OPENSTA-SKY130-ENV-BEGIN" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# OPENSTA-SKY130-ENV-BEGIN
export PDK_ROOT="$HOME/.ciel"
export PDK="sky130A"
export STD_CELL_LIBRARY="sky130_fd_sc_hd"
export SKY130A_ROOT="$PDK_ROOT/$PDK"

alias ol='cd "$HOME/Desktop/OpenLane"'
alias pdk='cd "$HOME/.ciel/sky130A"'
# OPENSTA-SKY130-ENV-END
EOF
fi

export PDK_ROOT="$PDK_ROOT_DEFAULT"
export PDK="$PDK_NAME"
export STD_CELL_LIBRARY="$STD_LIB"
export SKY130A_ROOT="$PDK_ROOT/$PDK_NAME"

echo
echo "[setup] SKY130 PDK installed"
echo "[setup] PDK_ROOT=$PDK_ROOT"
echo "[setup] PDK=$PDK"
echo "[setup] STD_CELL_LIBRARY=$STD_CELL_LIBRARY"

echo
echo "[setup] Checking PDK contents"

if [ -d "$SKY130A_ROOT" ]; then
    echo "[setup] SKY130A found at:"
    echo "        $SKY130A_ROOT"
else
    echo "[setup][ERROR] SKY130A PDK was not found"
    exit 1
fi

echo
echo "[setup] Example Liberty files:"
find "$SKY130A_ROOT" -type f \( -name "*.lib" -o -name "*.lib.gz" \) | head -10

echo
echo "[setup] Setup completed successfully"
