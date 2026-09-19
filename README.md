# OpenSTA SKY130 Codespace

A ready-to-use GitHub Codespace for static timing analysis using OpenSTA and the SKY130A PDK.

## Included Tools

- OpenSTA 3.1
- SKY130A PDK
- SKY130 HD standard-cell timing libraries
- Yosys
- Icarus Verilog
- GTKWave
- XFCE desktop
- noVNC browser access

## Launch the Codespace

1. Open this repository on GitHub.
2. Select **Code → Codespaces**.
3. Click **Create codespace on main**.
4. Wait for the automatic setup to complete.
5. Open a new terminal.

During the first setup, the SKY130A PDK is downloaded using CIEL. This may take several minutes.

## Verify OpenSTA

Run:

```bash
which sta
sta
```

Expected output begins with:

```text
OpenSTA 3.1.0
```

Exit OpenSTA using:

```tcl
exit
```

## Verify the SKY130 PDK

Load the configured environment:

```bash
source ~/.bashrc
```

Check the PDK configuration:

```bash
echo "$PDK_ROOT"
echo "$PDK"
echo "$STD_CELL_LIBRARY"
echo "$SKY130_HD_LIB"
```

Expected values:

```text
PDK_ROOT=/home/vscode/.ciel
PDK=sky130A
STD_CELL_LIBRARY=sky130_fd_sc_hd
```

Verify the Liberty file:

```bash
ls -l "$SKY130_HD_LIB"
```

The default timing library is:

```text
/home/vscode/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

## Load the SKY130 Library in OpenSTA

Start OpenSTA:

```bash
sta
```

At the OpenSTA prompt, run:

```tcl
read_liberty $env(SKY130_HD_LIB)
```

A successful load returns:

```text
1
```

Exit using:

```tcl
exit
```

## Basic Static Timing Analysis

A typical OpenSTA Tcl script contains:

```tcl
read_liberty $env(SKY130_HD_LIB)

read_verilog design_netlist.v
link_design top

read_sdc design.sdc

check_setup
report_checks -path_delay max -digits 3
report_checks -path_delay min -digits 3
report_worst_slack
report_tns

exit
```

Save it as:

```text
run_sta.tcl
```

Run the analysis using:

```bash
sta -no_splash -no_init run_sta.tcl
```

## Required Input Files

OpenSTA normally requires:

- A gate-level Verilog netlist
- A Liberty timing library
- An SDC constraints file
- An optional SPEF parasitics file

Example with SPEF:

```tcl
read_liberty $env(SKY130_HD_LIB)
read_verilog design_netlist.v
link_design top
read_sdc design.sdc
read_spef design.spef
report_checks -path_delay max -digits 3
exit
```

## SKY130 PDK Directory Structure

The PDK is installed under:

```text
$HOME/.ciel/sky130A
```

Important directories:

```text
libs.ref/sky130_fd_sc_hd/lib
libs.ref/sky130_fd_sc_hd/lef
libs.ref/sky130_fd_sc_hd/gds
libs.ref/sky130_fd_sc_hd/verilog
libs.tech/openlane
libs.tech/magic
```

Timing libraries are located under:

```text
libs.ref/sky130_fd_sc_hd/lib
```

List all available timing corners:

```bash
ls "$PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/lib"
```

## Common SKY130 Timing Corners

Typical corner:

```text
sky130_fd_sc_hd__tt_025C_1v80.lib
```

Slow corner:

```text
sky130_fd_sc_hd__ss_100C_1v40.lib
```

Fast corner:

```text
sky130_fd_sc_hd__ff_n40C_1v95.lib
```

Load a different corner in OpenSTA:

```tcl
read_liberty /home/vscode/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v40.lib
```

## Open the noVNC Desktop

1. Open the **Ports** tab in Codespaces.
2. Find port `6080`, labelled **noVNC Desktop**.
3. Click the globe icon.
4. Select `vnc_lite.html` if a directory page appears.

The browser desktop can be used to launch GTKWave and other graphical tools.

## Re-run the Setup

If the PDK setup was interrupted, run:

```bash
bash .devcontainer/setup.sh
```

Then open a new terminal or run:

```bash
source ~/.bashrc
```

## Useful Commands

Check OpenSTA:

```bash
sta
```

Find Liberty files:

```bash
find "$PDK_ROOT/sky130A" -name "*.lib" | head
```

Find LEF files:

```bash
find "$PDK_ROOT/sky130A" -name "*.lef" | head
```

Find Verilog models:

```bash
find "$PDK_ROOT/sky130A" -name "*.v" | head
```

Open the OpenLane directory:

```bash
cd ~/Desktop/OpenLane
```

## References

- [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA)
- [OpenLane](https://github.com/The-OpenROAD-Project/OpenLane)
- [VSD OpenLane Codespace](https://github.com/vsdip/vsd-openlane)
- [VSD RTL Codespace](https://github.com/vsdip/vsd-rtl)
