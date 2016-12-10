//----------------------------------------------------------------------
// Title      : Demo testbench
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : demo_tb.v
// Version    : 1.8
//-----------------------------------------------------------------------------
//
// (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//----------------------------------------------------------------------
// Description: This testbench will exercise the PHY ports of the EMAC
//              to demonstrate the functionality.
//----------------------------------------------------------------------

`timescale 1ps / 1ps


module testbench;


  //--------------------------------------------------------------------
  // testbench signals
  //--------------------------------------------------------------------
  wire        reset;

  // EMAC0
  wire        tx_client_clk_0;
  wire [7:0]  tx_ifg_delay_0; 
  wire        rx_client_clk_0;
  wire [15:0] pause_val_0;
  wire        pause_req_0;

  // 1000BASE-X PCS/PMA wires
  wire        txp_0;
  wire        txn_0;
  wire        rxp_0;
  wire        rxn_0;
  wire        sync_acq_status_0;
  wire        [4:0] phyad_0;

 
  // EMAC1
  wire        tx_client_clk_1;
  wire [7:0]  tx_ifg_delay_1;
  wire        rx_client_clk_1;
  wire [15:0] pause_val_1;
  wire        pause_req_1;

  // 1000BASE-X PCS/PMA wires
  wire        txp_1;
  wire        txn_1;
  wire        rxp_1;
  wire        rxn_1;
  wire        sync_acq_status_1;
  wire        [4:0] phyad_1;    


  // Clock wires
  wire        host_clk;
  reg         gtx_clk;

  reg         mgtclk_p;   
  reg         mgtclk_n;


  //----------------------------------------------------------------
  // Test Bench Semaphores
  //----------------------------------------------------------------
  wire        emac0_configuration_busy;
  wire        emac0_monitor_finished_1g;
  wire        emac0_monitor_finished_100m;
  wire        emac0_monitor_finished_10m;

  wire        emac1_configuration_busy;
  wire        emac1_monitor_finished_1g;
  wire        emac1_monitor_finished_100m;
  wire        emac1_monitor_finished_10m;

  // Tie-off EMAC0 PHY Address to a default value
  assign phyad_0 = 5'b00001;

  // Tie-off EMAC1 PHY Address to a default value
  assign phyad_1 = 5'b00010;

  //----------------------------------------------------------------
  // Wire up Device Under Test
  //----------------------------------------------------------------
  My_Fiber_EMAC_example_design dut
    (
    // Client Receiver Interface - EMAC0
    .EMAC0CLIENTRXDVLD               (),
    .EMAC0CLIENTRXFRAMEDROP          (),
    .EMAC0CLIENTRXSTATS              (),
    .EMAC0CLIENTRXSTATSVLD           (),
    .EMAC0CLIENTRXSTATSBYTEVLD       (),

    // Client Transmitter Interface - EMAC0
    .CLIENTEMAC0TXIFGDELAY           (tx_ifg_delay_0),
    .EMAC0CLIENTTXSTATS              (),
    .EMAC0CLIENTTXSTATSVLD           (),
    .EMAC0CLIENTTXSTATSBYTEVLD       (),

    // MAC Control Interface - EMAC0
    .CLIENTEMAC0PAUSEREQ             (pause_req_0),
    .CLIENTEMAC0PAUSEVAL             (pause_val_0),

    .EMAC0CLIENTSYNCACQSTATUS        (sync_acq_status_0),
    .EMAC0ANINTERRUPT                (),

    // 1000BASE-X PCS/PMA Interface - EMAC0
    .TXP_0                           (txp_0),
    .TXN_0                           (txn_0),
    .RXP_0                           (rxp_0),
    .RXN_0                           (rxn_0),
    .PHYAD_0                         (phyad_0),

    // Client Receiver Interface - EMAC1
    .EMAC1CLIENTRXDVLD               (),
    .EMAC1CLIENTRXFRAMEDROP          (),
    .EMAC1CLIENTRXSTATS              (),
    .EMAC1CLIENTRXSTATSVLD           (),
    .EMAC1CLIENTRXSTATSBYTEVLD       (),

    // Client Transmitter Interface - EMAC1
    .CLIENTEMAC1TXIFGDELAY           (tx_ifg_delay_1),
    .EMAC1CLIENTTXSTATS              (),
    .EMAC1CLIENTTXSTATSVLD           (),
    .EMAC1CLIENTTXSTATSBYTEVLD       (),

    // MAC Control Interface - EMAC1								   
    .CLIENTEMAC1PAUSEREQ             (pause_req_1),					   
    .CLIENTEMAC1PAUSEVAL             (pause_val_1),					   
																	   
    .EMAC1CLIENTSYNCACQSTATUS        (sync_acq_status_1),
    .EMAC1ANINTERRUPT                (),

    // 1000BASE-X PCS/PMA Interface - EMAC1
    .TXP_1                           (txp_1),
    .TXN_1                           (txn_1),
    .RXP_1                           (rxp_1),
    .RXN_1                           (rxn_1),
    .PHYAD_1                         (phyad_1),
       
    // transceiver differential reference clock
    .MGTCLK_P                        (mgtclk_p),   
    .MGTCLK_N                        (mgtclk_n),
    

        
    // Asynchronous Reset
    .RESET                           (reset)
    );


  //--------------------------------------------------------------------------
  // Flow Control is unused in this demonstration
  //--------------------------------------------------------------------------
  assign pause_req_0 = 1'b0;
  assign pause_val_0 = 16'b0;

  // IFG stretching not used in demo.
  assign tx_ifg_delay_0 = 8'b0;
  assign pause_req_1 = 1'b0;
  assign pause_val_1 = 16'b0;

  // IFG stretching not used in demo.
  assign tx_ifg_delay_1 = 8'b0;





  //--------------------------------------------------------------------------
  // Clock drivers
  //--------------------------------------------------------------------------

  // Drive GTX_CLK at 125 MHz
  initial                 // drives gtx_clk at 125 MHz
  begin
    gtx_clk <= 1'b0;
  	#10000;
    forever
    begin	 
      gtx_clk <= 1'b0;
      #4000;
      gtx_clk <= 1'b1;
      #4000;
    end
  end



  // Drive Gigabit Transceiver differential clock with 125MHz
  initial
  begin
    mgtclk_p <= 1'b0;
    mgtclk_n <= 1'b0;
  	#10000;
    forever
    begin	 
      mgtclk_p <= 1'b1;
      mgtclk_n <= 1'b0;
      #4000;
      mgtclk_p <= 1'b0;
      mgtclk_n <= 1'b1; 
      #4000;
    end
  end

  //--------------------------------------------------------------------
  // Instantiate the EMAC0 PHY stimulus and monitor
  //--------------------------------------------------------------------

  emac0_phy_tb phy0_test
    (
      .clk125m                 (gtx_clk),

      //----------------------------------------------------------------
      // GMII Interface
      //----------------------------------------------------------------
      .txp                     (txp_0),
      .txn                     (txn_0),
      .rxp                     (rxp_0),
      .rxn                     (rxn_0), 

      //----------------------------------------------------------------
      // Test Bench Semaphores
      //----------------------------------------------------------------
      .configuration_busy      (emac0_configuration_busy),
      .monitor_finished_1g     (emac0_monitor_finished_1g),
      .monitor_finished_100m   (emac0_monitor_finished_100m),
      .monitor_finished_10m    (emac0_monitor_finished_10m),
      .monitor_error           (monitor_error_emac0)
      );



  //--------------------------------------------------------------------
  // Instantiate the EMAC1 PHY stimulus and monitor
  //--------------------------------------------------------------------

  emac1_phy_tb phy1_test
    (
      .clk125m                 (gtx_clk),

      //----------------------------------------------------------------
      // GMII Interface
      //----------------------------------------------------------------
      .txp                     (txp_1),
      .txn                     (txn_1),
      .rxp                     (rxp_1),
      .rxn                     (rxn_1), 

      //----------------------------------------------------------------
      // Test Bench Semaphores
      //----------------------------------------------------------------
      .configuration_busy      (emac1_configuration_busy),
      .monitor_finished_1g     (emac1_monitor_finished_1g),
      .monitor_finished_100m   (emac1_monitor_finished_100m),
      .monitor_finished_10m    (emac1_monitor_finished_10m),
      .monitor_error           (monitor_error_emac1)
      );



  //--------------------------------------------------------------------
  // Instantiate the No-Host Configuration Stimulus
  //--------------------------------------------------------------------

  configuration_tb config_test 
    (
      .reset                       (reset),
      //----------------------------------------------------------------
      // Host Interface: host_clk is always required
      //----------------------------------------------------------------
      .host_clk                    (host_clk),

      //----------------------------------------------------------------
      // Test Bench Semaphores
      //----------------------------------------------------------------
      .sync_acq_status_0           (sync_acq_status_0),              
      .sync_acq_status_1           (sync_acq_status_1),              

      .emac0_configuration_busy    (emac0_configuration_busy),
      .emac0_monitor_finished_1g   (emac0_monitor_finished_1g),
      .emac0_monitor_finished_100m (emac0_monitor_finished_100m),
      .emac0_monitor_finished_10m  (emac0_monitor_finished_10m),

      .emac1_configuration_busy    (emac1_configuration_busy),
      .emac1_monitor_finished_1g   (emac1_monitor_finished_1g),
      .emac1_monitor_finished_100m (emac1_monitor_finished_100m),
      .emac1_monitor_finished_10m  (emac1_monitor_finished_10m),

      .monitor_error_emac0         (monitor_error_emac0),
      .monitor_error_emac1         (monitor_error_emac1)

      );



endmodule // testbench
