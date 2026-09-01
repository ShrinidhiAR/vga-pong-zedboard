constraints file


# ============================================================
# vga_pong.xdc
# Pin constraints for ZedBoard, verified against the official
# Digilent/Avnet Zedboard-Master.xdc and ZedBoard Hardware User's Guide.
# ============================================================

# 100 MHz system clock - Bank 13
set_property PACKAGE_PIN Y9  [get_ports {clk100mhz}];
set_property IOSTANDARD LVCMOS33 [get_ports {clk100mhz}];
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add
[get_ports {clk100mhz}];

# ---------------- Push buttons - Bank 34 (1.8V) ----------------
set_property PACKAGE_PIN P16 [get_ports {btnc}];   # BTNC - reset/serve
set_property PACKAGE_PIN T18 [get_ports {btnu}];   # BTNU - player 1 up
set_property PACKAGE_PIN R16 [get_ports {btnd}];   # BTND - player 1 down

set_property IOSTANDARD LVCMOS18 [get_ports {btnc}];
set_property IOSTANDARD LVCMOS18 [get_ports {btnu}];
set_property IOSTANDARD LVCMOS18 [get_ports {btnd}];

# ---------------- DIP switches - Bank 13 (3.3V) ----------------
set_property PACKAGE_PIN F22 [get_ports {sw0}];    # SW0 - player 2 up
set_property PACKAGE_PIN G22 [get_ports {sw1}];    # SW1 - player 2 down

set_property IOSTANDARD LVCMOS33 [get_ports {sw0}];
set_property IOSTANDARD LVCMOS33 [get_ports {sw1}];

# ---------------- VGA Output - Bank 33 (3.3V) ----------------
set_property PACKAGE_PIN V20  [get_ports {vga_r[0]}];   # VGA-R1
set_property PACKAGE_PIN U20  [get_ports {vga_r[1]}];   # VGA-R2
set_property PACKAGE_PIN V19  [get_ports {vga_r[2]}];   # VGA-R3
set_property PACKAGE_PIN V18  [get_ports {vga_r[3]}];   # VGA-R4

set_property PACKAGE_PIN AB22 [get_ports {vga_g[0]}];   # VGA-G1
set_property PACKAGE_PIN AA22 [get_ports {vga_g[1]}];   # VGA-G2
set_property PACKAGE_PIN AB21 [get_ports {vga_g[2]}];   # VGA-G3
set_property PACKAGE_PIN AA21 [get_ports {vga_g[3]}];   # VGA-G4

set_property PACKAGE_PIN Y21  [get_ports {vga_b[0]}];   # VGA-B1
set_property PACKAGE_PIN Y20  [get_ports {vga_b[1]}];   # VGA-B2
set_property PACKAGE_PIN AB20 [get_ports {vga_b[2]}];   # VGA-B3
set_property PACKAGE_PIN AB19 [get_ports {vga_b[3]}];   # VGA-B4

set_property PACKAGE_PIN AA19 [get_ports {vga_hs}];     # VGA-HS
set_property PACKAGE_PIN Y19  [get_ports {vga_vs}];     # VGA-VS

set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {vga_hs}];
set_property IOSTANDARD LVCMOS33 [get_ports {vga_vs}];
