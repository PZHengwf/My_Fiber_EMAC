//-----------------------------------------------------------------------------
// Title      : Virtex-5 Ethernet MAC Example Design Wrapper
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : My_Fiber_EMAC_example_design.v
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
//-----------------------------------------------------------------------------
// Description:  This is the Verilog example design for the Virtex-5 
//               Embedded Ethernet MAC.  It is intended that
//               this example design can be quickly adapted and downloaded onto
//               an FPGA to provide a real hardware test environment.
//
//               This level:
//
//               * instantiates the TEMAC local link file that instantiates 
//                 the TEMAC top level together with a RX and TX FIFO with a 
//                 local link interface;
//
//               * instantiates a simple client I/F side example design,
//                 providing an address swap and a simple
//                 loopback function;
//
//               * Instantiates IBUFs on the GTX_CLK, REFCLK and HOSTCLK inputs 
//                 if required;
//
//               Please refer to the Datasheet, Getting Started Guide, and
//               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
//               further information.
//
//
//
//    ---------------------------------------------------------------------
//    | EXAMPLE DESIGN WRAPPER                                            |
//    |           --------------------------------------------------------|
//    |           |LOCAL LINK WRAPPER                                     |
//    |           |              -----------------------------------------|
//    |           |              |BLOCK LEVEL WRAPPER                     |
//    |           |              |    ---------------------               |
//    | --------  |  ----------  |    | ETHERNET MAC      |               |
//    | |      |  |  |        |  |    | WRAPPER           |  ---------    |
//    | |      |->|->|        |--|--->| Tx            Tx  |--|       |--->|
//    | |      |  |  |        |  |    | client        PHY |  |       |    |
//    | | ADDR |  |  | LOCAL  |  |    | I/F           I/F |  |       |    |  
//    | | SWAP |  |  |  LINK  |  |    |                   |  | PHY   |    |
//    | |      |  |  |  FIFO  |  |    |                   |  | I/F   |    |
//    | |      |  |  |        |  |    |                   |  |       |    |
//    | |      |  |  |        |  |    | Rx            Rx  |  |       |    |
//    | |      |  |  |        |  |    | client        PHY |  |       |    |
//    | |      |<-|<-|        |<-|----| I/F           I/F |<-|       |<---|
//    | |      |  |  |        |  |    |                   |  ---------    |
//    | --------  |  ----------  |    ---------------------               |
//    |           |              -----------------------------------------|
//    |           --------------------------------------------------------|
//    ---------------------------------------------------------------------
//
//-----------------------------------------------------------------------------


`timescale 1 ps / 1 ps


//-----------------------------------------------------------------------------
// The module declaration for the example design.
//-----------------------------------------------------------------------------
module My_Fiber_EMAC_example_design
(
    // Client Receiver Interface - EMAC0
    EMAC0CLIENTRXDVLD,
    EMAC0CLIENTRXFRAMEDROP,
    EMAC0CLIENTRXSTATS,
    EMAC0CLIENTRXSTATSVLD,
    EMAC0CLIENTRXSTATSBYTEVLD,

    // Client Transmitter Interface - EMAC0
    CLIENTEMAC0TXIFGDELAY,
    EMAC0CLIENTTXSTATS,
    EMAC0CLIENTTXSTATSVLD,
    EMAC0CLIENTTXSTATSBYTEVLD,

    // MAC Control Interface - EMAC0
    CLIENTEMAC0PAUSEREQ,
    CLIENTEMAC0PAUSEVAL,

    //EMAC-MGT link status
    EMAC0CLIENTSYNCACQSTATUS,
    EMAC0ANINTERRUPT,


    // 1000BASE-X PCS/PMA Interface - EMAC0
    TXP_0,
    TXN_0,
    RXP_0,
    RXN_0,
    PHYAD_0,

    // Client Receiver Interface - EMAC1
    EMAC1CLIENTRXDVLD,
    EMAC1CLIENTRXFRAMEDROP,
    EMAC1CLIENTRXSTATS,
    EMAC1CLIENTRXSTATSVLD,
    EMAC1CLIENTRXSTATSBYTEVLD,

    // Client Transmitter Interface - EMAC1
    CLIENTEMAC1TXIFGDELAY,
    EMAC1CLIENTTXSTATS,
    EMAC1CLIENTTXSTATSVLD,
    EMAC1CLIENTTXSTATSBYTEVLD,

    // MAC Control Interface - EMAC1
    CLIENTEMAC1PAUSEREQ,
    CLIENTEMAC1PAUSEVAL,

    //EMAC-MGT link status
    EMAC1CLIENTSYNCACQSTATUS,
    EMAC1ANINTERRUPT,


    // 1000BASE-X PCS/PMA Interface - EMAC1
    TXP_1,
    TXN_1,
    RXP_1,
    RXN_1,
    PHYAD_1,

    // 1000BASE-X PCS/PMA Clock buffer inputs 
    MGTCLK_N,
    MGTCLK_P, 

    // Asynchronous Reset
    RESET
);


//-----------------------------------------------------------------------------
// Port Declarations 
//-----------------------------------------------------------------------------
    // Client Receiver Interface - EMAC0
    output          EMAC0CLIENTRXDVLD;
    output          EMAC0CLIENTRXFRAMEDROP;
    output   [6:0]  EMAC0CLIENTRXSTATS;
    output          EMAC0CLIENTRXSTATSVLD;
    output          EMAC0CLIENTRXSTATSBYTEVLD;

    // Client Transmitter Interface - EMAC0
    input    [7:0]  CLIENTEMAC0TXIFGDELAY;
    output          EMAC0CLIENTTXSTATS;
    output          EMAC0CLIENTTXSTATSVLD;
    output          EMAC0CLIENTTXSTATSBYTEVLD;

    // MAC Control Interface - EMAC0
    input           CLIENTEMAC0PAUSEREQ;
    input   [15:0]  CLIENTEMAC0PAUSEVAL;

    //EMAC-MGT link status
    output          EMAC0CLIENTSYNCACQSTATUS;
    output          EMAC0ANINTERRUPT;


    // 1000BASE-X PCS/PMA Interface - EMAC0
    output          TXP_0;
    output          TXN_0;
    input           RXP_0;
    input           RXN_0;
    input           [4:0] PHYAD_0;

    // Client Receiver Interface - EMAC1
    output          EMAC1CLIENTRXDVLD;
    output          EMAC1CLIENTRXFRAMEDROP;
    output   [6:0]  EMAC1CLIENTRXSTATS;
    output          EMAC1CLIENTRXSTATSVLD;
    output          EMAC1CLIENTRXSTATSBYTEVLD;

    // Client Transmitter Interface - EMAC1
    input    [7:0]  CLIENTEMAC1TXIFGDELAY;
    output          EMAC1CLIENTTXSTATS;
    output          EMAC1CLIENTTXSTATSVLD;
    output          EMAC1CLIENTTXSTATSBYTEVLD;

    // MAC Control Interface - EMAC1
    input           CLIENTEMAC1PAUSEREQ;
    input   [15:0]  CLIENTEMAC1PAUSEVAL;

    //EMAC-MGT link status
    output          EMAC1CLIENTSYNCACQSTATUS;
    output          EMAC1ANINTERRUPT;


    // 1000BASE-X PCS/PMA Interface - EMAC1
    output          TXP_1;
    output          TXN_1;
    input           RXP_1;
    input           RXN_1;
    input           [4:0] PHYAD_1;

   
    // 1000BASE-X PCS/PMA Clock buffer inputs 
    input           MGTCLK_N;
    input           MGTCLK_P; 

    // Asynchronous Reset
    input           RESET;

//-----------------------------------------------------------------------------
// Wire and Reg Declarations 
//-----------------------------------------------------------------------------

    // Global asynchronous reset
    wire            reset_i;
    // Local Link Interface Clocking Signal - EMAC0
    wire            ll_clk_0_i;

    // address swap transmitter connections - EMAC0
    wire      [7:0] tx_ll_data_0_i;
    wire            tx_ll_sof_n_0_i;
    wire            tx_ll_eof_n_0_i;
    wire            tx_ll_src_rdy_n_0_i;
    wire            tx_ll_dst_rdy_n_0_i;

    // address swap receiver connections - EMAC0
    wire      [7:0] rx_ll_data_0_i;
    wire            rx_ll_sof_n_0_i;
    wire            rx_ll_eof_n_0_i;
    wire            rx_ll_src_rdy_n_0_i;
    wire            rx_ll_dst_rdy_n_0_i;

    // create a synchronous reset in the local link clock domain
    reg       [5:0] ll_pre_reset_0_i;
    reg             ll_reset_0_i;

    // synthesis attribute ASYNC_REG of tx_pre_reset_0_i is "TRUE";

    // Reset signals from the transceiver
    wire            resetdone_0_i;

    // Local Link Interface Clocking Signal - EMAC1
    wire            ll_clk_1_i;

    // address swap transmitter connections - EMAC1
    wire      [7:0] tx_ll_data_1_i;
    wire            tx_ll_sof_n_1_i;
    wire            tx_ll_eof_n_1_i;
    wire            tx_ll_src_rdy_n_1_i;
    wire            tx_ll_dst_rdy_n_1_i;

    // address swap receiver connections EMAC1
    wire      [7:0] rx_ll_data_1_i;
    wire            rx_ll_sof_n_1_i;
    wire            rx_ll_eof_n_1_i;
    wire            rx_ll_src_rdy_n_1_i;
    wire            rx_ll_dst_rdy_n_1_i;

    // create a synchronous reset in the local link clock domain
    reg       [5:0] ll_pre_reset_1_i;
    reg             ll_reset_1_i;

    // synthesis attribute ASYNC_REG of tx_pre_reset_1_i is "TRUE";

    // Reset signals from the transceiver
    wire            resetdone_1_i;

    // EMAC0 Clocking signals

    // Transceiver output clock (REFCLKOUT at 125MHz)
    wire            clk125_o;
    // 125MHz clock input to wrappers
    wire            clk125;
    // Input 125MHz differential clock for transceiver
    wire            clk_ds;

    // GT reset signal
    wire gtreset;
    reg  [3:0] reset_r;
    // synthesis attribute ASYNC_REG of reset_r             is "TRUE";


    // EMAC1 Clocking signals





//-----------------------------------------------------------------------------
// Main Body of Code 
//-----------------------------------------------------------------------------

    // Reset input buffer
    //IBUF reset_ibuf (.I(RESET), .O(reset_i));
	 assign reset_i = !RESET;
    // EMAC0 Clocking

    // Generate the clock input to the GTP
    // clk_ds can be shared between multiple MAC instances.
    IBUFDS clkingen (
      .I(MGTCLK_P),
      .IB(MGTCLK_N),
      .O(clk_ds));

    // 125MHz from transceiver is routed through a BUFG and
    // input to the MAC wrappers.
    // This clock can be shared between multiple MAC instances.
    BUFG bufg_clk125 (.I(clk125_o), .O(clk125));

    assign ll_clk_0_i = clk125; 
    //--------------------------------------------------------------------
    //-- RocketIO PMA reset circuitry
    //--------------------------------------------------------------------
    always@(posedge reset_i, posedge clk125)
    begin
      if (reset_i == 1'b1)
      begin
        reset_r <= 4'b1111;
      end
      else
      begin
        reset_r <= {reset_r[2:0], reset_i};
      end
    end

    assign gtreset = reset_r[3];


    // EMAC1 Clocking

    assign ll_clk_1_i = clk125;

    //------------------------------------------------------------------------
    // Instantiate the EMAC Wrapper with LL FIFO 
    // (My_Fiber_EMAC_locallink.v) 
    //------------------------------------------------------------------------
    My_Fiber_EMAC_locallink v5_emac_ll
    (
    // EMAC0 Clocking
    // 125MHz clock output from transceiver
    .CLK125_OUT                          (clk125_o),
    // 125MHz clock input from BUFG
    .CLK125                              (clk125),

    // Local link Receiver Interface - EMAC0
    .RX_LL_CLOCK_0                       (ll_clk_0_i),
    .RX_LL_RESET_0                       (ll_reset_0_i),
    .RX_LL_DATA_0                        (rx_ll_data_0_i),
    .RX_LL_SOF_N_0                       (rx_ll_sof_n_0_i),
    .RX_LL_EOF_N_0                       (rx_ll_eof_n_0_i),
    .RX_LL_SRC_RDY_N_0                   (rx_ll_src_rdy_n_0_i),
    .RX_LL_DST_RDY_N_0                   (rx_ll_dst_rdy_n_0_i),
    .RX_LL_FIFO_STATUS_0                 (),

    // Unused Receiver signals - EMAC0
    .EMAC0CLIENTRXDVLD                   (EMAC0CLIENTRXDVLD),
    .EMAC0CLIENTRXFRAMEDROP              (EMAC0CLIENTRXFRAMEDROP),
    .EMAC0CLIENTRXSTATS                  (EMAC0CLIENTRXSTATS),
    .EMAC0CLIENTRXSTATSVLD               (EMAC0CLIENTRXSTATSVLD),
    .EMAC0CLIENTRXSTATSBYTEVLD           (EMAC0CLIENTRXSTATSBYTEVLD),

    // Local link Transmitter Interface - EMAC0
    .TX_LL_CLOCK_0                       (ll_clk_0_i),
    .TX_LL_RESET_0                       (ll_reset_0_i),
    .TX_LL_DATA_0                        (tx_ll_data_0_i),
    .TX_LL_SOF_N_0                       (tx_ll_sof_n_0_i),
    .TX_LL_EOF_N_0                       (tx_ll_eof_n_0_i),
    .TX_LL_SRC_RDY_N_0                   (tx_ll_src_rdy_n_0_i),
    .TX_LL_DST_RDY_N_0                   (tx_ll_dst_rdy_n_0_i),

    // Unused Transmitter signals - EMAC0
    .CLIENTEMAC0TXIFGDELAY               (CLIENTEMAC0TXIFGDELAY),
    .EMAC0CLIENTTXSTATS                  (EMAC0CLIENTTXSTATS),
    .EMAC0CLIENTTXSTATSVLD               (EMAC0CLIENTTXSTATSVLD),
    .EMAC0CLIENTTXSTATSBYTEVLD           (EMAC0CLIENTTXSTATSBYTEVLD),

    // MAC Control Interface - EMAC0
    .CLIENTEMAC0PAUSEREQ                 (CLIENTEMAC0PAUSEREQ),
    .CLIENTEMAC0PAUSEVAL                 (CLIENTEMAC0PAUSEVAL),

    //EMAC-MGT link status
    .EMAC0CLIENTSYNCACQSTATUS            (EMAC0CLIENTSYNCACQSTATUS),
    // EMAC0 Interrupt
    .EMAC0ANINTERRUPT                    (EMAC0ANINTERRUPT),



    // 1000BASE-X PCS/PMA Interface - EMAC0
    .TXP_0                               (TXP_0),
    .TXN_0                               (TXN_0),
    .RXP_0                               (RXP_0),
    .RXN_0                               (RXN_0),
    .PHYAD_0                             (PHYAD_0),
    .RESETDONE_0                         (resetdone_0_i),

    // EMAC1 Clocking

    // Local link Receiver Interface - EMAC1
    .RX_LL_CLOCK_1                       (ll_clk_1_i),
    .RX_LL_RESET_1                       (ll_reset_1_i),
    .RX_LL_DATA_1                        (rx_ll_data_1_i),
    .RX_LL_SOF_N_1                       (rx_ll_sof_n_1_i),
    .RX_LL_EOF_N_1                       (rx_ll_eof_n_1_i),
    .RX_LL_SRC_RDY_N_1                   (rx_ll_src_rdy_n_1_i),
    .RX_LL_DST_RDY_N_1                   (rx_ll_dst_rdy_n_1_i),
    .RX_LL_FIFO_STATUS_1                 (),

    // Unused Receiver signals - EMAC1
    .EMAC1CLIENTRXDVLD                   (EMAC1CLIENTRXDVLD),
    .EMAC1CLIENTRXFRAMEDROP              (EMAC1CLIENTRXFRAMEDROP),
    .EMAC1CLIENTRXSTATS                  (EMAC1CLIENTRXSTATS),
    .EMAC1CLIENTRXSTATSVLD               (EMAC1CLIENTRXSTATSVLD),
    .EMAC1CLIENTRXSTATSBYTEVLD           (EMAC1CLIENTRXSTATSBYTEVLD),

    // Local link Transmitter Interface - EMAC1
    .TX_LL_CLOCK_1                       (ll_clk_1_i),
    .TX_LL_RESET_1                       (ll_reset_1_i),
    .TX_LL_DATA_1                        (tx_ll_data_1_i),
    .TX_LL_SOF_N_1                       (tx_ll_sof_n_1_i),
    .TX_LL_EOF_N_1                       (tx_ll_eof_n_1_i),
    .TX_LL_SRC_RDY_N_1                   (tx_ll_src_rdy_n_1_i),
    .TX_LL_DST_RDY_N_1                   (tx_ll_dst_rdy_n_1_i),

    // Unused Transmitter signals - EMAC1
    .CLIENTEMAC1TXIFGDELAY               (CLIENTEMAC1TXIFGDELAY),
    .EMAC1CLIENTTXSTATS                  (EMAC1CLIENTTXSTATS),
    .EMAC1CLIENTTXSTATSVLD               (EMAC1CLIENTTXSTATSVLD),
    .EMAC1CLIENTTXSTATSBYTEVLD           (EMAC1CLIENTTXSTATSBYTEVLD),

    // MAC Control Interface - EMAC1
    .CLIENTEMAC1PAUSEREQ                 (CLIENTEMAC1PAUSEREQ),
    .CLIENTEMAC1PAUSEVAL                 (CLIENTEMAC1PAUSEVAL),

    //EMAC-MGT link status
    .EMAC1CLIENTSYNCACQSTATUS            (EMAC1CLIENTSYNCACQSTATUS),
    // EMAC0 Interrupt
    .EMAC1ANINTERRUPT                    (EMAC1ANINTERRUPT),


    // 1000BASE-X PCS/PMA Interface - EMAC1
    .TXP_1                               (TXP_1),
    .TXN_1                               (TXN_1),
    .RXP_1                               (RXP_1),
    .RXN_1                               (RXN_1),
    .PHYAD_1                             (PHYAD_1),
    .RESETDONE_1                         (resetdone_1_i),

    // 1000BASE-X PCS/PMA Clock buffer inputs 
    .CLK_DS                              (clk_ds), 
    .GTRESET                             (gtreset), 

    // Asynchronous Reset Input
    .RESET                               (reset_i));


    //-------------------------------------------------------------------
    //  Instatiate the address swapping module
    //-------------------------------------------------------------------
    address_swap_module_8 client_side_asm_emac0 
      (.rx_ll_clock(ll_clk_0_i),
       .rx_ll_reset(ll_reset_0_i),
       .rx_ll_data_in(rx_ll_data_0_i),
       .rx_ll_sof_in_n(rx_ll_sof_n_0_i),
       .rx_ll_eof_in_n(rx_ll_eof_n_0_i),
       .rx_ll_src_rdy_in_n(rx_ll_src_rdy_n_0_i),
       .rx_ll_data_out(tx_ll_data_0_i),
       .rx_ll_sof_out_n(tx_ll_sof_n_0_i),
       .rx_ll_eof_out_n(tx_ll_eof_n_0_i),
       .rx_ll_src_rdy_out_n(tx_ll_src_rdy_n_0_i),
       .rx_ll_dst_rdy_in_n(tx_ll_dst_rdy_n_0_i)
    );

    assign rx_ll_dst_rdy_n_0_i   = tx_ll_dst_rdy_n_0_i;

    // Create synchronous reset in the transmitter clock domain.
    always @(posedge ll_clk_0_i, posedge reset_i)
    begin
      if (reset_i === 1'b1)
      begin
        ll_pre_reset_0_i <= 6'h3F;
        ll_reset_0_i     <= 1'b1;
      end
      else if (resetdone_0_i === 1'b1)
      begin
        ll_pre_reset_0_i[0]   <= 1'b0;
        ll_pre_reset_0_i[5:1] <= ll_pre_reset_0_i[4:0];
        ll_reset_0_i          <= ll_pre_reset_0_i[5];
      end
    end
     

    //-------------------------------------------------------------------
    //  Instatiate the address swapping module
    //-------------------------------------------------------------------
    address_swap_module_8 client_side_asm_emac1 
      (.rx_ll_clock(ll_clk_1_i),
       .rx_ll_reset(ll_reset_1_i),
       .rx_ll_data_in(rx_ll_data_1_i),
       .rx_ll_sof_in_n(rx_ll_sof_n_1_i),
       .rx_ll_eof_in_n(rx_ll_eof_n_1_i),
       .rx_ll_src_rdy_in_n(rx_ll_src_rdy_n_1_i),
       .rx_ll_data_out(tx_ll_data_1_i),
       .rx_ll_sof_out_n(tx_ll_sof_n_1_i),
       .rx_ll_eof_out_n(tx_ll_eof_n_1_i),
       .rx_ll_src_rdy_out_n(tx_ll_src_rdy_n_1_i),
       .rx_ll_dst_rdy_in_n(tx_ll_dst_rdy_n_1_i)
    );

    assign rx_ll_dst_rdy_n_1_i   = tx_ll_dst_rdy_n_1_i;

    // Create synchronous reset in the transmitter clock domain.
    always @(posedge ll_clk_1_i, posedge reset_i)
    begin
      if (reset_i === 1'b1)
      begin
        ll_pre_reset_1_i <= 6'h3F;
        ll_reset_1_i     <= 1'b1;
      end
      else if (resetdone_1_i === 1'b1)
      begin
        ll_pre_reset_1_i[0]   <= 1'b0;
        ll_pre_reset_1_i[5:1] <= ll_pre_reset_1_i[4:0];
        ll_reset_1_i          <= ll_pre_reset_1_i[5];
      end
    end
   




endmodule
