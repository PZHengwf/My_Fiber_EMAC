//-----------------------------------------------------------------------------
// Title      : Virtex-5 Ethernet MAC Local Link Wrapper
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : My_Fiber_EMAC_locallink.v
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
// Description:  This level:
//
//               * instantiates the TEMAC top level file (the TEMAC
//                 wrapper with the clocking and physical interface
//				   logic;
//               
//               * instantiates TX and RX reference design FIFO's with 
//                 a local link interface.
//               
//               Please refer to the Datasheet, Getting Started Guide, and
//               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
//               further information.
//-----------------------------------------------------------------------------


`timescale 1 ps / 1 ps


//-----------------------------------------------------------------------------
// The module declaration for the MAC with FIFO design.
//-----------------------------------------------------------------------------
module My_Fiber_EMAC_locallink
(
    // EMAC0 Clocking
    // 125MHz clock output from transceiver
    CLK125_OUT,
    // 125MHz clock input from BUFG
    CLK125,

    // Local link Receiver Interface - EMAC0
    RX_LL_CLOCK_0,
    RX_LL_RESET_0,
    RX_LL_DATA_0,
    RX_LL_SOF_N_0,
    RX_LL_EOF_N_0,
    RX_LL_SRC_RDY_N_0,
    RX_LL_DST_RDY_N_0,
    RX_LL_FIFO_STATUS_0,

    // Local link Transmitter Interface - EMAC0
    TX_LL_CLOCK_0,
    TX_LL_RESET_0,
    TX_LL_DATA_0,
    TX_LL_SOF_N_0,
    TX_LL_EOF_N_0,
    TX_LL_SRC_RDY_N_0,
    TX_LL_DST_RDY_N_0,
 
    
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
    RESETDONE_0,

    // EMAC1 Clocking

    // Local link Receiver Interface - EMAC1
    RX_LL_CLOCK_1,
    RX_LL_RESET_1,
    RX_LL_DATA_1,
    RX_LL_SOF_N_1,
    RX_LL_EOF_N_1,
    RX_LL_SRC_RDY_N_1,
    RX_LL_DST_RDY_N_1,
    RX_LL_FIFO_STATUS_1,

    // Local link Transmitter Interface - EMAC1
    TX_LL_CLOCK_1,
    TX_LL_RESET_1,
    TX_LL_DATA_1,
    TX_LL_SOF_N_1,
    TX_LL_EOF_N_1,
    TX_LL_SRC_RDY_N_1,
    TX_LL_DST_RDY_N_1,

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
    RESETDONE_1,

    // 1000BASE-X PCS/PMA Clock buffer inputs 
    CLK_DS, 
    GTRESET,

    // Asynchronous Reset
    RESET
);


//-----------------------------------------------------------------------------
// Port Declarations 
//-----------------------------------------------------------------------------
    // EMAC0 Clocking
    // 125MHz clock output from transceiver
    output          CLK125_OUT;
    // 125MHz clock input from BUFG
    input           CLK125;

    // Local link Receiver Interface - EMAC0
    input           RX_LL_CLOCK_0;
    input           RX_LL_RESET_0;
    output   [7:0]  RX_LL_DATA_0;
    output          RX_LL_SOF_N_0;
    output          RX_LL_EOF_N_0;
    output          RX_LL_SRC_RDY_N_0;
    input           RX_LL_DST_RDY_N_0;
    output   [3:0]  RX_LL_FIFO_STATUS_0;

    // Local link Transmitter Interface - EMAC0
    input           TX_LL_CLOCK_0;
    input           TX_LL_RESET_0;
    input    [7:0]  TX_LL_DATA_0;
    input           TX_LL_SOF_N_0;
    input           TX_LL_EOF_N_0;
    input           TX_LL_SRC_RDY_N_0;
    output          TX_LL_DST_RDY_N_0;

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
    output          RESETDONE_0;

    // EMAC1 Clocking

    // Local link Receiver Interface - EMAC1
    input           RX_LL_CLOCK_1;
    input           RX_LL_RESET_1;
    output   [7:0]  RX_LL_DATA_1;
    output          RX_LL_SOF_N_1;
    output          RX_LL_EOF_N_1;
    output          RX_LL_SRC_RDY_N_1;
    input           RX_LL_DST_RDY_N_1;
    output   [3:0]  RX_LL_FIFO_STATUS_1;

    // Local link Transmitter Interface - EMAC1
    input           TX_LL_CLOCK_1;
    input           TX_LL_RESET_1;
    input    [7:0]  TX_LL_DATA_1;
    input           TX_LL_SOF_N_1;
    input           TX_LL_EOF_N_1;
    input           TX_LL_SRC_RDY_N_1;
    output          TX_LL_DST_RDY_N_1;

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
    output          RESETDONE_1;

    // 1000BASE-X PCS/PMA Clock buffer inputs 
    input           CLK_DS; 
    input           GTRESET; 

    // Asynchronous Reset
    input           RESET;


//-----------------------------------------------------------------------------
// Wire and Reg Declarations 
//-----------------------------------------------------------------------------

    // Global asynchronous reset
    wire            reset_i;
    // Client interface clocking signals - EMAC0
    wire            tx_clk_0_i;
    wire            rx_clk_0_i;

    // Internal client interface connections - EMAC0
    // Transmitter interface
    wire     [7:0]  tx_data_0_i;
    wire            tx_data_valid_0_i;
    wire            tx_underrun_0_i;
    wire            tx_ack_0_i;
    wire            tx_collision_0_i;
    wire            tx_retransmit_0_i;
    // Receiver interface
    wire     [7:0]  rx_data_0_i;
    wire            rx_data_valid_0_i;
    wire            rx_good_frame_0_i;
    wire            rx_bad_frame_0_i;
    // Registers for the EMAC receiver output
    reg      [7:0]  rx_data_0_r;
    reg             rx_data_valid_0_r;
    reg             rx_good_frame_0_r;
    reg             rx_bad_frame_0_r;   

    // Reset signals from the transceiver
    wire            resetdone_0_i;

    // create a synchronous reset in the transmitter clock domain
    reg       [5:0] tx_pre_reset_0_i;
    reg             tx_reset_0_i;

    // create a synchronous reset in the receiver clock domain
    reg       [5:0] rx_pre_reset_0_i;
    reg             rx_reset_0_i;    

    // synthesis attribute ASYNC_REG of rx_pre_reset_0_i is "TRUE";
    // synthesis attribute ASYNC_REG of tx_pre_reset_0_i is "TRUE";

    // Client interface clocking signals - EMAC1
    wire            tx_clk_1_i;
    wire            rx_clk_1_i;

    // Internal client interface connections - EMAC1
    // Transmitter interface
    wire     [7:0]  tx_data_1_i;
    wire            tx_data_valid_1_i;
    wire            tx_underrun_1_i;
    wire            tx_ack_1_i;
    wire            tx_collision_1_i;
    wire            tx_retransmit_1_i;
    // Receiver interface
    wire     [7:0]  rx_data_1_i;
    wire            rx_data_valid_1_i;
    wire            rx_good_frame_1_i;
    wire            rx_bad_frame_1_i;
    // Registers for the EMAC receiver output
    reg      [7:0]  rx_data_1_r;
    reg             rx_data_valid_1_r;
    reg             rx_good_frame_1_r;
    reg             rx_bad_frame_1_r;   

    // Reset signals from the transceiver
    wire            resetdone_1_i;

    // create a synchronous reset in the transmitter clock domain
    reg       [5:0] tx_pre_reset_1_i;
    reg             tx_reset_1_i;

    // create a synchronous reset in the receiver clock domain
    reg       [5:0] rx_pre_reset_1_i;
    reg             rx_reset_1_i;    

    // synthesis attribute ASYNC_REG of rx_pre_reset_1_i is "TRUE";
    // synthesis attribute ASYNC_REG of tx_pre_reset_1_i is "TRUE";

    //synthesis attribute keep of tx_data_0_i is "true";
    //synthesis attribute keep of tx_data_valid_0_i is "true";
    //synthesis attribute keep of tx_ack_0_i is "true";
    //synthesis attribute keep of rx_data_0_i is "true";
    //synthesis attribute keep of rx_data_valid_0_i is "true";
    //synthesis attribute keep of tx_data_1_i is "true";
    //synthesis attribute keep of tx_data_valid_1_i is "true";
    //synthesis attribute keep of tx_ack_1_i is "true";
    //synthesis attribute keep of rx_data_1_i is "true";
    //synthesis attribute keep of rx_data_valid_1_i is "true";

//-----------------------------------------------------------------------------
// Main Body of Code 
//-----------------------------------------------------------------------------

    // Asynchronous reset input
    assign reset_i = RESET; 

    //------------------------------------------------------------------------
    // Instantiate the EMAC Wrapper (My_Fiber_EMAC_block.v) 
    //------------------------------------------------------------------------
    My_Fiber_EMAC_block v5_emac_block_inst
    (
    // EMAC0 Clocking
    // 125MHz clock output from transceiver
    .CLK125_OUT                          (CLK125_OUT),
    // 125MHz clock input from BUFG
    .CLK125                              (CLK125),

    // Client Receiver Interface - EMAC0
    .EMAC0CLIENTRXD                      (rx_data_0_i),
    .EMAC0CLIENTRXDVLD                   (rx_data_valid_0_i),
    .EMAC0CLIENTRXGOODFRAME              (rx_good_frame_0_i),
    .EMAC0CLIENTRXBADFRAME               (rx_bad_frame_0_i),
    .EMAC0CLIENTRXFRAMEDROP              (EMAC0CLIENTRXFRAMEDROP),
    .EMAC0CLIENTRXSTATS                  (EMAC0CLIENTRXSTATS),
    .EMAC0CLIENTRXSTATSVLD               (EMAC0CLIENTRXSTATSVLD),
    .EMAC0CLIENTRXSTATSBYTEVLD           (EMAC0CLIENTRXSTATSBYTEVLD),

    // Client Transmitter Interface - EMAC0
    .CLIENTEMAC0TXD                      (tx_data_0_i),
    .CLIENTEMAC0TXDVLD                   (tx_data_valid_0_i),
    .EMAC0CLIENTTXACK                    (tx_ack_0_i),
    .CLIENTEMAC0TXFIRSTBYTE              (1'b0),
    .CLIENTEMAC0TXUNDERRUN               (tx_underrun_0_i),
    .EMAC0CLIENTTXCOLLISION              (tx_collision_0_i),
    .EMAC0CLIENTTXRETRANSMIT             (tx_retransmit_0_i),
    .CLIENTEMAC0TXIFGDELAY               (CLIENTEMAC0TXIFGDELAY),
    .EMAC0CLIENTTXSTATS                  (EMAC0CLIENTTXSTATS),
    .EMAC0CLIENTTXSTATSVLD               (EMAC0CLIENTTXSTATSVLD),
    .EMAC0CLIENTTXSTATSBYTEVLD           (EMAC0CLIENTTXSTATSBYTEVLD),

    // MAC Control Interface - EMAC0
    .CLIENTEMAC0PAUSEREQ                 (CLIENTEMAC0PAUSEREQ),
    .CLIENTEMAC0PAUSEVAL                 (CLIENTEMAC0PAUSEVAL),

    //EMAC-MGT link status
    .EMAC0CLIENTSYNCACQSTATUS            (EMAC0CLIENTSYNCACQSTATUS),
    .EMAC0ANINTERRUPT                    (EMAC0ANINTERRUPT),


    // 1000BASE-X PCS/PMA Interface - EMAC0
    .TXP_0                               (TXP_0),
    .TXN_0                               (TXN_0),
    .RXP_0                               (RXP_0),
    .RXN_0                               (RXN_0),
    .PHYAD_0                             (PHYAD_0),
    .RESETDONE_0                         (resetdone_0_i),

    // EMAC1 Clocking

    // Client Receiver Interface - EMAC1
    .EMAC1CLIENTRXD                      (rx_data_1_i),
    .EMAC1CLIENTRXDVLD                   (rx_data_valid_1_i),
    .EMAC1CLIENTRXGOODFRAME              (rx_good_frame_1_i),
    .EMAC1CLIENTRXBADFRAME               (rx_bad_frame_1_i),
    .EMAC1CLIENTRXFRAMEDROP              (EMAC1CLIENTRXFRAMEDROP),
    .EMAC1CLIENTRXSTATS                  (EMAC1CLIENTRXSTATS),
    .EMAC1CLIENTRXSTATSVLD               (EMAC1CLIENTRXSTATSVLD),
    .EMAC1CLIENTRXSTATSBYTEVLD           (EMAC1CLIENTRXSTATSBYTEVLD),

    // Client Transmitter Interface - EMAC1
    .CLIENTEMAC1TXD                      (tx_data_1_i),
    .CLIENTEMAC1TXDVLD                   (tx_data_valid_1_i),
    .EMAC1CLIENTTXACK                    (tx_ack_1_i),
    .CLIENTEMAC1TXFIRSTBYTE              (1'b0),
    .CLIENTEMAC1TXUNDERRUN               (tx_underrun_1_i),
    .EMAC1CLIENTTXCOLLISION              (tx_collision_1_i),
    .EMAC1CLIENTTXRETRANSMIT             (tx_retransmit_1_i),
    .CLIENTEMAC1TXIFGDELAY               (CLIENTEMAC1TXIFGDELAY),
    .EMAC1CLIENTTXSTATS                  (EMAC1CLIENTTXSTATS),
    .EMAC1CLIENTTXSTATSVLD               (EMAC1CLIENTTXSTATSVLD),
    .EMAC1CLIENTTXSTATSBYTEVLD           (EMAC1CLIENTTXSTATSBYTEVLD),

    // MAC Control Interface - EMAC1
    .CLIENTEMAC1PAUSEREQ                 (CLIENTEMAC1PAUSEREQ),
    .CLIENTEMAC1PAUSEVAL                 (CLIENTEMAC1PAUSEVAL),

    //EMAC-MGT link status
    .EMAC1CLIENTSYNCACQSTATUS            (EMAC1CLIENTSYNCACQSTATUS),
    .EMAC1ANINTERRUPT                    (EMAC1ANINTERRUPT),


    // 1000BASE-X PCS/PMA Interface - EMAC1
    .TXP_1                               (TXP_1),
    .TXN_1                               (TXN_1),
    .RXP_1                               (RXP_1),
    .RXN_1                               (RXN_1),
    .PHYAD_1                             (PHYAD_1),
    .RESETDONE_1                         (resetdone_1_i),

    // 1000BASE-X PCS/PMA Clock buffer inputs 
    .CLK_DS                              (CLK_DS), 
    .GTRESET                             (GTRESET), 

    // Asynchronous Reset Input
    .RESET                               (reset_i));

  //-------------------------------------------------------------------
  // Instantiate the client side FIFO
  //-------------------------------------------------------------------
  eth_fifo_8 client_side_FIFO_emac0 (
     // EMAC transmitter client interface
     .tx_clk(tx_clk_0_i),
     .tx_reset(tx_reset_0_i),
     .tx_enable(1'b1),
     .tx_data(tx_data_0_i),
     .tx_data_valid(tx_data_valid_0_i),
     .tx_ack(tx_ack_0_i),
     .tx_underrun(tx_underrun_0_i),
     .tx_collision(tx_collision_0_i),
     .tx_retransmit(tx_retransmit_0_i),

     // Transmitter local link interface     
     .tx_ll_clock(TX_LL_CLOCK_0),
     .tx_ll_reset(TX_LL_RESET_0),
     .tx_ll_data_in(TX_LL_DATA_0),
     .tx_ll_sof_in_n(TX_LL_SOF_N_0),
     .tx_ll_eof_in_n(TX_LL_EOF_N_0),
     .tx_ll_src_rdy_in_n(TX_LL_SRC_RDY_N_0),
     .tx_ll_dst_rdy_out_n(TX_LL_DST_RDY_N_0),
     .tx_fifo_status(),
     .tx_overflow(),

     // EMAC receiver client interface     
     .rx_clk(rx_clk_0_i),
     .rx_reset(rx_reset_0_i),
     .rx_enable(1'b1),
     .rx_data(rx_data_0_r),
     .rx_data_valid(rx_data_valid_0_r),
     .rx_good_frame(rx_good_frame_0_r),
     .rx_bad_frame(rx_bad_frame_0_r),
     .rx_overflow(),

     // Receiver local link interface
     .rx_ll_clock(RX_LL_CLOCK_0),
     .rx_ll_reset(RX_LL_RESET_0),
     .rx_ll_data_out(RX_LL_DATA_0),
     .rx_ll_sof_out_n(RX_LL_SOF_N_0),
     .rx_ll_eof_out_n(RX_LL_EOF_N_0),
     .rx_ll_src_rdy_out_n(RX_LL_SRC_RDY_N_0),
     .rx_ll_dst_rdy_in_n(RX_LL_DST_RDY_N_0),
     .rx_fifo_status(RX_LL_FIFO_STATUS_0));


  //-------------------------------------------------------------------
  // Create synchronous reset signals for use in the FIFO.
  // A synchronous reset signal is created in each
  // clock domain.
  //-------------------------------------------------------------------

  // Create synchronous reset in the transmitter clock domain.
  always @(posedge tx_clk_0_i, posedge reset_i)
  begin
    if (reset_i === 1'b1)
    begin
      tx_pre_reset_0_i <= 6'h3F;
      tx_reset_0_i     <= 1'b1;
    end
    else
    begin
      if (resetdone_0_i == 1'b1)
      begin
        tx_pre_reset_0_i[0]   <= 1'b0;
        tx_pre_reset_0_i[5:1] <= tx_pre_reset_0_i[4:0];
        tx_reset_0_i          <= tx_pre_reset_0_i[5];
      end
    end
  end

always @(posedge rx_clk_0_i, posedge reset_i)
  begin
    if (reset_i === 1'b1)
    begin
      rx_pre_reset_0_i <= 6'h3F;
      rx_reset_0_i     <= 1'b1;
    end
    else
    begin
      if (resetdone_0_i == 1'b1)
      begin
        rx_pre_reset_0_i[0]   <= 1'b0;
        rx_pre_reset_0_i[5:1] <= rx_pre_reset_0_i[4:0];
        rx_reset_0_i          <= rx_pre_reset_0_i[5];
      end
    end
  end


  //--------------------------------------------------------------------
  // Register the receiver outputs from EMAC0 before routing 
  // to the FIFO
  //--------------------------------------------------------------------
  always @(posedge rx_clk_0_i, posedge reset_i)
  begin
    if (reset_i == 1'b1)
    begin
      rx_data_valid_0_r <= 1'b0;
      rx_data_0_r       <= 8'h00;
      rx_good_frame_0_r <= 1'b0;
      rx_bad_frame_0_r  <= 1'b0;
    end
    else
    begin
      if (resetdone_0_i == 1'b1)
      begin
        rx_data_0_r       <= rx_data_0_i;
        rx_data_valid_0_r <= rx_data_valid_0_i;
        rx_good_frame_0_r <= rx_good_frame_0_i;
        rx_bad_frame_0_r  <= rx_bad_frame_0_i;
      end
    end
  end
     
  //-------------------------------------------------------------------
  // Instantiate the client side FIFO
  //-------------------------------------------------------------------
  eth_fifo_8 client_side_FIFO_emac1 (
     // EMAC transmitter client interface
     .tx_clk(tx_clk_1_i),
     .tx_reset(tx_reset_1_i),
     .tx_enable(1'b1),
     .tx_data(tx_data_1_i),
     .tx_data_valid(tx_data_valid_1_i),
     .tx_ack(tx_ack_1_i),
     .tx_underrun(tx_underrun_1_i),
     .tx_collision(tx_collision_1_i),
     .tx_retransmit(tx_retransmit_1_i),

     // Transmitter local link interface     
     .tx_ll_clock(TX_LL_CLOCK_1),
     .tx_ll_reset(TX_LL_RESET_1),
     .tx_ll_data_in(TX_LL_DATA_1),
     .tx_ll_sof_in_n(TX_LL_SOF_N_1),
     .tx_ll_eof_in_n(TX_LL_EOF_N_1),
     .tx_ll_src_rdy_in_n(TX_LL_SRC_RDY_N_1),
     .tx_ll_dst_rdy_out_n(TX_LL_DST_RDY_N_1),
     .tx_fifo_status(),
     .tx_overflow(),

     // EMAC receiver client interface     
     .rx_clk(rx_clk_1_i),
     .rx_reset(rx_reset_1_i),
     .rx_enable(1'b1),
     .rx_data(rx_data_1_r),
     .rx_data_valid(rx_data_valid_1_r),
     .rx_good_frame(rx_good_frame_1_r),
     .rx_bad_frame(rx_bad_frame_1_r),
     .rx_overflow(),

     // Receiver local link interface
     .rx_ll_clock(RX_LL_CLOCK_1),
     .rx_ll_reset(RX_LL_RESET_1),
     .rx_ll_data_out(RX_LL_DATA_1),
     .rx_ll_sof_out_n(RX_LL_SOF_N_1),
     .rx_ll_eof_out_n(RX_LL_EOF_N_1),
     .rx_ll_src_rdy_out_n(RX_LL_SRC_RDY_N_1),
     .rx_ll_dst_rdy_in_n(RX_LL_DST_RDY_N_1),
     .rx_fifo_status(RX_LL_FIFO_STATUS_1));


  //-------------------------------------------------------------------
  // Create synchronous reset signals for use in the FIFO.
  // A synchronous reset signal is created in each
  // clock domain.
  //-------------------------------------------------------------------

  // Create synchronous reset in the transmitter clock domain.
  always @(posedge tx_clk_1_i, posedge reset_i)
  begin
    if (reset_i === 1'b1)
    begin
      tx_pre_reset_1_i <= 6'h3F;
      tx_reset_1_i     <= 1'b1;
    end
    else
    begin
      if (resetdone_1_i == 1'b1) 
      begin
        tx_pre_reset_1_i[0]   <= 1'b0;
        tx_pre_reset_1_i[5:1] <= tx_pre_reset_1_i[4:0];
        tx_reset_1_i          <= tx_pre_reset_1_i[5];
      end
    end
  end

  // Create synchronous reset in the receiver clock domain.
  always @(posedge rx_clk_1_i, posedge reset_i)
  begin
    if (reset_i === 1'b1)
    begin
      rx_pre_reset_1_i <= 6'h3F;
      rx_reset_1_i     <= 1'b1;
    end
    else
    begin
      if (resetdone_1_i == 1'b1)
      begin
        rx_pre_reset_1_i[0]   <= 1'b0;
        rx_pre_reset_1_i[5:1] <= rx_pre_reset_1_i[4:0];
        rx_reset_1_i          <= rx_pre_reset_1_i[5];
      end
    end
  end


  //--------------------------------------------------------------------
  // Register the receiver outputs from EMAC1 before routing 
  // to the FIFO
  //--------------------------------------------------------------------
  always @(posedge rx_clk_1_i, posedge reset_i)
  begin
    if (reset_i == 1'b1)
    begin
      rx_data_1_r       <= 8'h00;
      rx_data_valid_1_r <= 1'b0;
      rx_good_frame_1_r <= 1'b0;
      rx_bad_frame_1_r  <= 1'b0;
    end
    else
    begin
      if (resetdone_1_i == 1'b1)
      begin
        rx_data_1_r       <= rx_data_1_i;
        rx_data_valid_1_r <= rx_data_valid_1_i;
        rx_good_frame_1_r <= rx_good_frame_1_i;
        rx_bad_frame_1_r  <= rx_bad_frame_1_i;
      end
    end
  end
   
    assign EMAC0CLIENTRXDVLD = rx_data_valid_0_i;

    // EMAC0 Clocking
    assign tx_clk_0_i = CLK125;
    assign rx_clk_0_i = CLK125;

    assign RESETDONE_0 = resetdone_0_i;

    assign EMAC1CLIENTRXDVLD = rx_data_valid_1_i;

    // EMAC1 Clocking
    assign tx_clk_1_i = CLK125;
    assign rx_clk_1_i = CLK125;

    assign RESETDONE_1 = resetdone_1_i;



endmodule
