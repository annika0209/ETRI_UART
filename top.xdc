# CLK_125M
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN K17 [get_ports clk]

# BTN for RST
set_property IOSTANDARD LVCMOS33 [get_ports reset_poweron]
set_property PACKAGE_PIN Y16 [get_ports reset_poweron]

# BTN input (BTN SW)
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_en]
set_property PACKAGE_PIN K19 [get_ports uart_tx_en]

#BTM input for btn_rx_hex (BTN SW)
set_property IOSTANDARD LVCMOS33 [get_ports btn_P16]
set_property PACKAGE_PIN P16 [get_ports btn_P16]

# tx_data (DIP SW)
set_property IOSTANDARD LVCMOS33 [get_ports {uart_tx_data[*]}]
set_property PACKAGE_PIN T16 [get_ports {uart_tx_data[3]}] 
set_property PACKAGE_PIN W13 [get_ports {uart_tx_data[2]}] 
set_property PACKAGE_PIN P15 [get_ports {uart_tx_data[1]}] 
set_property PACKAGE_PIN G15 [get_ports {uart_tx_data[0]}] 

# UART TXD (Pmod JA)
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property PACKAGE_PIN L14 [get_ports uart_txd]


# rx_data (LED)
set_property IOSTANDARD LVCMOS33 [get_ports {test_c_state[*]}]
set_property PACKAGE_PIN D18 [get_ports {test_c_state[3]}] 
set_property PACKAGE_PIN G14 [get_ports {test_c_state[2]}] 
set_property PACKAGE_PIN M15 [get_ports {test_c_state[1]}] 
set_property PACKAGE_PIN M14 [get_ports {test_c_state[0]}] 

## UART RXD (Pmod JA)
#set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
#set_property PACKAGE_PIN K16 [get_ports uart_rxd]

# KEYPAD (JE)
set_property IOSTANDARD LVCMOS33 [get_ports {key_io[*]}]
set_property PACKAGE_PIN V12 [get_ports {key_io[0]}]
set_property PACKAGE_PIN W16 [get_ports {key_io[1]}]
set_property PACKAGE_PIN J15 [get_ports {key_io[2]}]
set_property PACKAGE_PIN H15 [get_ports {key_io[3]}]
set_property PACKAGE_PIN V13 [get_ports {key_io[4]}]
set_property PACKAGE_PIN U17 [get_ports {key_io[5]}]
set_property PACKAGE_PIN T17 [get_ports {key_io[6]}]
set_property PACKAGE_PIN Y17 [get_ports {key_io[7]}]

# JB(for 7'seg LED)
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[*]}]
set_property PACKAGE_PIN V8 [get_ports {seg_data[7]}]
set_property PACKAGE_PIN W8 [get_ports {seg_data[6]}]
set_property PACKAGE_PIN U7 [get_ports {seg_data[5]}]
set_property PACKAGE_PIN V7 [get_ports {seg_data[4]}]
set_property PACKAGE_PIN Y7 [get_ports {seg_data[3]}]
set_property PACKAGE_PIN Y6 [get_ports {seg_data[2]}]
set_property PACKAGE_PIN V6 [get_ports {seg_data[1]}]
set_property PACKAGE_PIN W6 [get_ports {seg_data[0]}]

# JC(for 7'seg LED, be Aligned)
set_property IOSTANDARD LVCMOS33 [get_ports {seg_com[*]}]
set_property PACKAGE_PIN V15 [get_ports {seg_com[5]}]
set_property PACKAGE_PIN W15 [get_ports {seg_com[4]}]
set_property PACKAGE_PIN T11 [get_ports {seg_com[3]}]
set_property PACKAGE_PIN T10 [get_ports {seg_com[2]}]
set_property PACKAGE_PIN W14 [get_ports {seg_com[1]}]
set_property PACKAGE_PIN Y14 [get_ports {seg_com[0]}]
