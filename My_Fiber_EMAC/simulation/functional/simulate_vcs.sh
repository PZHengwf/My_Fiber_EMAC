#!/bin/sh

/bin/rm -rf simv* csrc DVEfiles AN.DB

echo "Compiling Core Simulation Models"
vlogan +v2k          \
      ../../example_design/client/address_swap_module_8.v \
      ../../example_design/client/fifo/tx_client_fifo_8.v \
      ../../example_design/client/fifo/rx_client_fifo_8.v \
      ../../example_design/client/fifo/eth_fifo_8.v \
      ../../example_design/physical/gtp_dual_1000X.v \
      ../../example_design/physical/rocketio_wrapper_gtp.v \
      ../../example_design/physical/rocketio_wrapper_gtp_tile.v \
      ../../example_design/My_Fiber_EMAC.v \
      ../../example_design/My_Fiber_EMAC_block.v \
      ../../example_design/My_Fiber_EMAC_locallink.v \
      ../../example_design/My_Fiber_EMAC_example_design.v \
      ../configuration_tb.v \
      ../emac0_phy_tb.v \
      ../emac1_phy_tb.v \
      $XILINX/verilog/src/glbl.v \
      ../demo_tb.v

vcs  -debug -PP testbench glbl
./simv -ucli -i ucli_commands.key
dve -vpd vcdplus.vpd -session vcs_session.tcl
