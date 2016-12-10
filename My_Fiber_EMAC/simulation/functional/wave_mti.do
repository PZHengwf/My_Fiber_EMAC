view structure
view signals
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -format Logic /testbench/host_clk
add wave -noupdate -format Logic /testbench/mgtclk_p
add wave -noupdate -format Logic /testbench/mgtclk_n
add wave -noupdate -divider {EMAC0 Tx Client Interface}
add wave -noupdate -label tx_client_clk_0 -format Logic /testbench/dut/clk125
add wave -noupdate -format Literal -hex /testbench/dut/v5_emac_ll/tx_data_0_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/tx_data_valid_0_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/tx_ack_0_i
add wave -noupdate -format Literal -hex /testbench/tx_ifg_delay_0
add wave -noupdate -divider {EMAC0 Rx Client Interface}
add wave -noupdate -label rx_client_clk_0 -format Logic /testbench/dut/clk125
add wave -noupdate -format Literal -hex /testbench/dut/v5_emac_ll/rx_data_0_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/rx_data_valid_0_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/rx_good_frame_0_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/rx_bad_frame_0_i
add wave -noupdate -divider {EMAC0 Flow Control}
add wave -noupdate -format Literal -hex /testbench/pause_val_0
add wave -noupdate -format Logic /testbench/pause_req_0
add wave -noupdate -divider {EMAC0 RocketIO Interface}
add wave -noupdate -format Logic /testbench/txp_0
add wave -noupdate -format Logic /testbench/txn_0
add wave -noupdate -format Logic /testbench/rxp_0
add wave -noupdate -format Logic /testbench/rxn_0
add wave -noupdate -divider {EMAC1 Tx Client Interface}
add wave -noupdate -label tx_client_clk_1 -format Logic /testbench/dut/clk125
add wave -noupdate -format Literal -hex /testbench/dut/v5_emac_ll/tx_data_1_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/tx_data_valid_1_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/tx_ack_1_i
add wave -noupdate -format Literal -hex /testbench/tx_ifg_delay_1
add wave -noupdate -divider {EMAC1 Rx Client Interface}
add wave -noupdate -label rx_client_clk_1 -format Logic /testbench/dut/clk125
add wave -noupdate -format Literal -hex /testbench/dut/v5_emac_ll/rx_data_1_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/rx_data_valid_1_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/rx_good_frame_1_i
add wave -noupdate -format Logic /testbench/dut/v5_emac_ll/rx_bad_frame_1_i
add wave -noupdate -divider {EMAC1 Flow Control}
add wave -noupdate -format Literal -hex /testbench/pause_val_1
add wave -noupdate -format Logic /testbench/pause_req_1
add wave -noupdate -divider {EMAC1 RocketIO Interface}
add wave -noupdate -format Logic /testbench/txp_1
add wave -noupdate -format Logic /testbench/txn_1
add wave -noupdate -format Logic /testbench/rxp_1
add wave -noupdate -format Logic /testbench/rxn_1
add wave -noupdate -divider {Test semaphores}
add wave -noupdate -format Logic /testbench/emac0_configuration_busy
add wave -noupdate -format Logic /testbench/emac0_monitor_finished_1g
add wave -noupdate -format Logic /testbench/emac0_monitor_finished_100m
add wave -noupdate -format Logic /testbench/emac0_monitor_finished_10m
add wave -noupdate -format Logic /testbench/emac1_configuration_busy
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_1g
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_100m
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_10m
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
