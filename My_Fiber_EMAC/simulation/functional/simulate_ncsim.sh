#!/bin/sh
mkdir work

ncvlog -work work $XILINX/verilog/src/glbl.v
ncvlog -work work ../../example_design/client/address_swap_module_8.v
ncvlog -work work ../../example_design/client/fifo/tx_client_fifo_8.v
ncvlog -work work ../../example_design/client/fifo/rx_client_fifo_8.v
ncvlog -work work ../../example_design/client/fifo/eth_fifo_8.v
ncvlog -work work ../../example_design/physical/gtp_dual_1000X.v
ncvlog -work work ../../example_design/physical/rocketio_wrapper_gtp.v
ncvlog -work work ../../example_design/physical/rocketio_wrapper_gtp_tile.v
ncvlog -work work ../../example_design/My_Fiber_EMAC.v
ncvlog -work work ../../example_design/My_Fiber_EMAC_block.v
ncvlog -work work ../../example_design/My_Fiber_EMAC_locallink.v
ncvlog -work work ../../example_design/My_Fiber_EMAC_example_design.v
ncvlog -work work ../configuration_tb.v
ncvlog -work work ../emac0_phy_tb.v
ncvlog -work work ../emac1_phy_tb.v
ncvlog -work work ../demo_tb.v

ncelab -access +rw work.testbench glbl
ncsim -gui -input @"simvision -input wave_ncsim.sv" work.testbench
