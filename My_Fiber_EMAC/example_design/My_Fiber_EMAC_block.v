//-----------------------------------------------------------------------------
// Title      : Virtex-5 Ethernet MAC Wrapper Top Level
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : My_Fiber_EMAC_block.v
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
// Description:  This is the EMAC block level Verilog design for the Virtex-5 
//               Embedded Ethernet MAC Example Design.  It is intended that
//               this example design can be quickly adapted and downloaded onto
//               an FPGA to provide a real hardware test environment.
//
//               The block level:
//
//               * instantiates all clock management logic required (BUFGs, 
//                 DCMs) to operate the EMAC and its example design;
//
//               * instantiates appropriate PHY interface modules (GMII, MII,
//                 RGMII, SGMII or 1000BASE-X) as required based on the user
//                 configuration.
//
//
//               Please refer to the Datasheet, Getting Started Guide, and
//               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
//               further information.
//-----------------------------------------------------------------------------


`timescale 1 ps / 1 ps


//-----------------------------------------------------------------------------
// The module declaration for the top level design.
//-----------------------------------------------------------------------------
module My_Fiber_EMAC_block
(
    // EMAC0 Clocking
    // 125MHz clock output from transceiver
    CLK125_OUT,
    // 125MHz clock input from BUFG
    CLK125,

    // Client Receiver Interface - EMAC0
    EMAC0CLIENTRXD,
    EMAC0CLIENTRXDVLD,
    EMAC0CLIENTRXGOODFRAME,
    EMAC0CLIENTRXBADFRAME,
    EMAC0CLIENTRXFRAMEDROP,
    EMAC0CLIENTRXSTATS,
    EMAC0CLIENTRXSTATSVLD,
    EMAC0CLIENTRXSTATSBYTEVLD,

    // Client Transmitter Interface - EMAC0
    CLIENTEMAC0TXD,
    CLIENTEMAC0TXDVLD,
    EMAC0CLIENTTXACK,
    CLIENTEMAC0TXFIRSTBYTE,
    CLIENTEMAC0TXUNDERRUN,
    EMAC0CLIENTTXCOLLISION,
    EMAC0CLIENTTXRETRANSMIT,
    CLIENTEMAC0TXIFGDELAY,
    EMAC0CLIENTTXSTATS,
    EMAC0CLIENTTXSTATSVLD,
    EMAC0CLIENTTXSTATSBYTEVLD,

    // MAC Control Interface - EMAC0
    CLIENTEMAC0PAUSEREQ,
    CLIENTEMAC0PAUSEVAL,

    //EMAC-MGT link status
    EMAC0CLIENTSYNCACQSTATUS,
    //EMAC0 Interrupt
    EMAC0ANINTERRUPT,


    // 1000BASE-X PCS/PMA Interface - EMAC0
    TXP_0,
    TXN_0,
    RXP_0,
    RXN_0,
    PHYAD_0,
    RESETDONE_0,

    // EMAC1 Clocking

    // Client Receiver Interface - EMAC1
    EMAC1CLIENTRXD,
    EMAC1CLIENTRXDVLD,
    EMAC1CLIENTRXGOODFRAME,
    EMAC1CLIENTRXBADFRAME,
    EMAC1CLIENTRXFRAMEDROP,
    EMAC1CLIENTRXSTATS,
    EMAC1CLIENTRXSTATSVLD,
    EMAC1CLIENTRXSTATSBYTEVLD,

    // Client Transmitter Interface - EMAC1
    CLIENTEMAC1TXD,
    CLIENTEMAC1TXDVLD,
    EMAC1CLIENTTXACK,
    CLIENTEMAC1TXFIRSTBYTE,
    CLIENTEMAC1TXUNDERRUN,
    EMAC1CLIENTTXCOLLISION,
    EMAC1CLIENTTXRETRANSMIT,
    CLIENTEMAC1TXIFGDELAY,
    EMAC1CLIENTTXSTATS,
    EMAC1CLIENTTXSTATSVLD,
    EMAC1CLIENTTXSTATSBYTEVLD,

    // MAC Control Interface - EMAC1
    CLIENTEMAC1PAUSEREQ,
    CLIENTEMAC1PAUSEVAL,

    //EMAC-MGT link status
    EMAC1CLIENTSYNCACQSTATUS,
    //EMAC1 Interrupt 
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

    // Asynchronous Reset Input
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

    // Client Receiver Interface - EMAC0
    output   [7:0]  EMAC0CLIENTRXD;
    output          EMAC0CLIENTRXDVLD;
    output          EMAC0CLIENTRXGOODFRAME;
    output          EMAC0CLIENTRXBADFRAME;
    output          EMAC0CLIENTRXFRAMEDROP;
    output   [6:0]  EMAC0CLIENTRXSTATS;
    output          EMAC0CLIENTRXSTATSVLD;
    output          EMAC0CLIENTRXSTATSBYTEVLD;

    // Client Transmitter Interface - EMAC0
    input    [7:0]  CLIENTEMAC0TXD;
    input           CLIENTEMAC0TXDVLD;
    output          EMAC0CLIENTTXACK;
    input           CLIENTEMAC0TXFIRSTBYTE;
    input           CLIENTEMAC0TXUNDERRUN;
    output          EMAC0CLIENTTXCOLLISION;
    output          EMAC0CLIENTTXRETRANSMIT;
    input    [7:0]  CLIENTEMAC0TXIFGDELAY;
    output          EMAC0CLIENTTXSTATS;
    output          EMAC0CLIENTTXSTATSVLD;
    output          EMAC0CLIENTTXSTATSBYTEVLD;

    // MAC Control Interface - EMAC0
    input           CLIENTEMAC0PAUSEREQ;
    input   [15:0]  CLIENTEMAC0PAUSEVAL;

    //EMAC-MGT link status
    output          EMAC0CLIENTSYNCACQSTATUS;
    //EMAC0 Interrupt
    output          EMAC0ANINTERRUPT;


    // 1000BASE-X PCS/PMA Interface - EMAC0
    output          TXP_0;
    output          TXN_0;
    input           RXP_0;
    input           RXN_0;
    input           [4:0] PHYAD_0;
    output          RESETDONE_0;

    // EMAC1 Clocking

    // Client Receiver Interface - EMAC1
    output   [7:0]  EMAC1CLIENTRXD;
    output          EMAC1CLIENTRXDVLD;
    output          EMAC1CLIENTRXGOODFRAME;
    output          EMAC1CLIENTRXBADFRAME;
    output          EMAC1CLIENTRXFRAMEDROP;
    output   [6:0]  EMAC1CLIENTRXSTATS;
    output          EMAC1CLIENTRXSTATSVLD;
    output          EMAC1CLIENTRXSTATSBYTEVLD;

    // Client Transmitter Interface - EMAC1
    input    [7:0]  CLIENTEMAC1TXD;
    input           CLIENTEMAC1TXDVLD;
    output          EMAC1CLIENTTXACK;
    input           CLIENTEMAC1TXFIRSTBYTE;
    input           CLIENTEMAC1TXUNDERRUN;
    output          EMAC1CLIENTTXCOLLISION;
    output          EMAC1CLIENTTXRETRANSMIT;
    input    [7:0]  CLIENTEMAC1TXIFGDELAY;
    output          EMAC1CLIENTTXSTATS;
    output          EMAC1CLIENTTXSTATSVLD;
    output          EMAC1CLIENTTXSTATSBYTEVLD;

    // MAC Control Interface - EMAC1
    input           CLIENTEMAC1PAUSEREQ;
    input   [15:0]  CLIENTEMAC1PAUSEVAL;

    //EMAC-MGT link status
    output          EMAC1CLIENTSYNCACQSTATUS;
    //EMAC1 Interrupt
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

    // Asynchronous reset signals
    wire            reset_ibuf_i;
    wire            reset_i;
    reg      [3:0]  reset_r;

    // EMAC0 client clocking signals
    wire            rx_client_clk_out_0_i;
    wire            rx_client_clk_in_0_i;
    wire            tx_client_clk_out_0_i;
    wire            tx_client_clk_in_0_i;

    // EMAC0 Physical interface signals
    wire            emac_locked_0_i;
    wire     [7:0]  mgt_rx_data_0_i;
    wire     [7:0]  mgt_tx_data_0_i;
    wire            signal_detect_0_i;
    wire            rxelecidle_0_i;
    wire            encommaalign_0_i;
    wire            loopback_0_i;
    wire            mgt_rx_reset_0_i;
    wire            mgt_tx_reset_0_i;
    wire            powerdown_0_i;
    wire     [2:0]  rxclkcorcnt_0_i;
    wire            rxbuferr_0_i;
    wire            rxchariscomma_0_i;
    wire            rxcharisk_0_i;
    wire            rxdisperr_0_i;
    wire     [1:0]  rxlossofsync_0_i;
    wire            rxnotintable_0_i;
    wire            rxrundisp_0_i;
    wire            txbuferr_0_i;
    wire            txchardispmode_0_i;
    wire            txchardispval_0_i;
    wire            txcharisk_0_i;
    wire     [1:0]  rxbufstatus_0_i;
    reg      [3:0]  tx_reset_sm_0_r;
    reg             tx_pcs_reset_0_r;
    reg      [3:0]  rx_reset_sm_0_r;
    reg             rx_pcs_reset_0_r;

    // EMAC1 client clocking signals
    wire            rx_client_clk_out_1_i;
    wire            rx_client_clk_in_1_i;
    wire            tx_client_clk_out_1_i;
    wire            tx_client_clk_in_1_i;

    // EMAC1 Physical interface signals
    wire            emac_locked_1_i;
    wire     [7:0]  mgt_rx_data_1_i;
    wire     [7:0]  mgt_tx_data_1_i;
    wire            signal_detect_1_i;
    wire            rxelecidle_1_i;
    wire            encommaalign_1_i;
    wire            loopback_1_i;
    wire            mgt_rx_reset_1_i;
    wire            mgt_tx_reset_1_i;
    wire            powerdown_1_i;
    wire     [2:0]  rxclkcorcnt_1_i;
    wire            rxbuferr_1_i;
    wire            rxchariscomma_1_i;
    wire            rxcharisk_1_i;
    wire            rxdisperr_1_i;
    wire     [1:0]  rxlossofsync_1_i;
    wire            rxnotintable_1_i;
    wire            rxrundisp_1_i;
    wire            txbuferr_1_i;
    wire            txchardispmode_1_i;
    wire            txchardispval_1_i;
    wire            txcharisk_1_i;
    wire     [1:0]  rxbufstatus_1_i;
    reg      [3:0]  tx_reset_sm_1_r;
    reg             tx_pcs_reset_1_r;
    reg      [3:0]  rx_reset_sm_1_r;
    reg             rx_pcs_reset_1_r;

    // Transceiver clocking signals
    wire            usrclk2;
   
    wire            refclkout;
    wire            dcm_locked_gtp;  
    wire            plllock_0_i;
    wire            plllock_1_i;



//-----------------------------------------------------------------------------
// Main Body of Code 
//-----------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Main Reset Circuitry
    //-------------------------------------------------------------------------

    assign reset_ibuf_i = RESET;

    // Asserting the reset of the EMAC for a few clock cycles
    always @(posedge usrclk2 or posedge reset_ibuf_i)
    begin
        if (reset_ibuf_i == 1)
        begin
            reset_r <= 4'b1111;
        end
        else
        begin
          if (plllock_0_i == 1 && plllock_1_i == 1)
            reset_r <= {reset_r[2:0], reset_ibuf_i};
        end
    end
    // synthesis attribute async_reg of reset_r is "TRUE";

    // The reset pulse is now several clock cycles in duration
    assign reset_i = reset_r[3];

 
   
    //-------------------------------------------------------------------------
    // Instantiate RocketIO tile for SGMII or 1000BASE-X PCS/PMA Physical I/F
    //-------------------------------------------------------------------------

    //EMAC0 and EMAC1 instances
    GTP_dual_1000X GTP_DUAL_1000X_inst
         (
         .RESETDONE_0           (RESETDONE_0),
         .ENMCOMMAALIGN_0       (encommaalign_0_i),
         .ENPCOMMAALIGN_0       (encommaalign_0_i),
         .LOOPBACK_0            (loopback_0_i),
         .POWERDOWN_0           (powerdown_0_i),
         .RXUSRCLK_0            (usrclk2),
         .RXUSRCLK2_0           (usrclk2),
         .RXRESET_0             (mgt_rx_reset_0_i),
         .TXCHARDISPMODE_0      (txchardispmode_0_i),
         .TXCHARDISPVAL_0       (txchardispval_0_i),
         .TXCHARISK_0           (txcharisk_0_i),
         .TXDATA_0              (mgt_tx_data_0_i),
 
         .TXUSRCLK_0            (usrclk2),
         .TXUSRCLK2_0           (usrclk2),
         .TXRESET_0             (mgt_tx_reset_0_i),                                   
         .RXCHARISCOMMA_0       (rxchariscomma_0_i),
         .RXCHARISK_0           (rxcharisk_0_i),
         .RXCLKCORCNT_0         (rxclkcorcnt_0_i),
         .RXDATA_0              (mgt_rx_data_0_i),
         .RXDISPERR_0           (rxdisperr_0_i),
         .RXNOTINTABLE_0        (rxnotintable_0_i),
         .RXRUNDISP_0           (rxrundisp_0_i),
         .RXBUFERR_0            (rxbuferr_0_i),         
         .TXBUFERR_0            (txbuferr_0_i),
         .PLLLKDET_0            (plllock_0_i),
         .TXOUTCLK_0            (),
         .RXELECIDLE_0          (rxelecidle_0_i),
         .RX1P_0                (RXP_0),
         .RX1N_0                (RXN_0),
         .TX1N_0                (TXN_0),
         .TX1P_0                (TXP_0),
         .RESETDONE_1           (RESETDONE_1),
         .ENMCOMMAALIGN_1       (encommaalign_1_i),
         .ENPCOMMAALIGN_1       (encommaalign_1_i),
         .LOOPBACK_1            (loopback_1_i),
         .POWERDOWN_1           (powerdown_1_i),
         .RXUSRCLK_1            (usrclk2),
         .RXUSRCLK2_1           (usrclk2),
         .RXRESET_1             (mgt_rx_reset_1_i),
         .TXCHARDISPMODE_1      (txchardispmode_1_i),
         .TXCHARDISPVAL_1       (txchardispval_1_i),
         .TXCHARISK_1           (txcharisk_1_i),
         .TXDATA_1              (mgt_tx_data_1_i),
         .TXUSRCLK_1            (usrclk2),
         .TXUSRCLK2_1           (usrclk2),
         .TXRESET_1             (mgt_tx_reset_1_i),                                   
         .RXCHARISCOMMA_1       (rxchariscomma_1_i),
         .RXCHARISK_1           (rxcharisk_1_i),
         .RXCLKCORCNT_1         (rxclkcorcnt_1_i),
         .RXDATA_1              (mgt_rx_data_1_i),
         .RXDISPERR_1           (rxdisperr_1_i),
         .RXNOTINTABLE_1        (rxnotintable_1_i),
         .RXRUNDISP_1           (rxrundisp_1_i),
         .RXBUFERR_1            (rxbuferr_1_i),         
         .TXBUFERR_1            (txbuferr_1_i),
         .PLLLKDET_1            (plllock_1_i),
         .TXOUTCLK_1            (),
         .RXELECIDLE_1          (rxelecidle_1_i),
         .RX1P_1                (RXP_1),
         .RX1N_1                (RXN_1),
         .TX1N_1                (TXN_1),
         .TX1P_1                (TXP_1),
         .CLK_DS                (CLK_DS),         
         .GTRESET               (GTRESET),
         .REFCLKOUT             (refclkout),
         .PMARESET              (reset_ibuf_i),
         .DCM_LOCKED            (dcm_locked_gtp));




    //-------------------------------------------------------------------------
    // Generate the buffer status input to the EMAC0 from the buffer error 
    // output of the transceiver
    //-------------------------------------------------------------------------
    assign rxbufstatus_0_i[1] = rxbuferr_0_i;

    //-------------------------------------------------------------------------
    // Detect when there has been a disconnect
    //-------------------------------------------------------------------------
    assign signal_detect_0_i = ~(rxelecidle_0_i);

 

    //-------------------------------------------------------------------------
    // Generate the buffer status input to the EMAC1 from the buffer error 
    // output of the transceiver
    //-------------------------------------------------------------------------
    assign rxbufstatus_1_i[1] = rxbuferr_1_i;

    //-------------------------------------------------------------------------
    // Detect when there has been a disconnect
    //-------------------------------------------------------------------------
    assign signal_detect_1_i = ~(rxelecidle_1_i);






    //--------------------------------------------------------------------
    // Virtex5 Rocket I/O Clock Management
    //--------------------------------------------------------------------

    // The RocketIO transceivers are available in pairs with shared
    // clock resources
    // 125MHz clock is used for GTP user clocks and used
    // to clock all Ethernet core logic.
    assign usrclk2                   = CLK125;

    assign dcm_locked_gtp            = 1'b1;

    // EMAC0: PLL locks
    assign emac_locked_0_i           = plllock_0_i;


    //------------------------------------------------------------------------
    // GTX_CLK Clock Management for EMAC0 - 125 MHz clock frequency
    // (Connected to PHYEMAC0GTXCLK of the EMAC primitive)
    //------------------------------------------------------------------------
    assign gtx_clk_ibufg_0_i         = usrclk2;


    //------------------------------------------------------------------------
    // PCS/PMA client side receive clock for EMAC0
    //------------------------------------------------------------------------
    assign rx_client_clk_in_0_i      = usrclk2;


    //------------------------------------------------------------------------
    // PCS/PMA client side transmit clock for EMAC0
    //------------------------------------------------------------------------
    assign tx_client_clk_in_0_i      = usrclk2;


    // EMAC1: PLL locks
    assign emac_locked_1_i           = plllock_1_i;


    //------------------------------------------------------------------------
    // GTX_CLK Clock Management for EMAC1 - 125 MHz clock frequency
    // (Connected to PHYEMAC1GTXCLK of the EMAC primitive)
    //------------------------------------------------------------------------
    assign gtx_clk_ibufg_1_i         = usrclk2;


    //------------------------------------------------------------------------
    // PCS/PMA client side receive clock for EMAC1
    //------------------------------------------------------------------------
    assign rx_client_clk_in_1_i      = usrclk2;


    //------------------------------------------------------------------------
    // PCS/PMA client side transmit clock for EMAC0
    //------------------------------------------------------------------------
    assign tx_client_clk_in_1_i      = usrclk2;


    //------------------------------------------------------------------------
    // Connect previously derived client clocks to example design output ports
    //------------------------------------------------------------------------
    // EMAC0 Clocking
    // 125MHz clock output from transceiver
    assign CLK125_OUT                = refclkout;

    // EMAC1 Clocking



    //------------------------------------------------------------------------
    // Instantiate the EMAC Wrapper (My_Fiber_EMAC.v) 
    //------------------------------------------------------------------------
    My_Fiber_EMAC v5_emac_wrapper_inst
    (
        // Client Receiver Interface - EMAC0
        .EMAC0CLIENTRXCLIENTCLKOUT      (rx_client_clk_out_0_i),
        .CLIENTEMAC0RXCLIENTCLKIN       (rx_client_clk_in_0_i),
        .EMAC0CLIENTRXD                 (EMAC0CLIENTRXD),
        .EMAC0CLIENTRXDVLD              (EMAC0CLIENTRXDVLD),
        .EMAC0CLIENTRXDVLDMSW           (),
        .EMAC0CLIENTRXGOODFRAME         (EMAC0CLIENTRXGOODFRAME),
        .EMAC0CLIENTRXBADFRAME          (EMAC0CLIENTRXBADFRAME),
        .EMAC0CLIENTRXFRAMEDROP         (EMAC0CLIENTRXFRAMEDROP),
        .EMAC0CLIENTRXSTATS             (EMAC0CLIENTRXSTATS),
        .EMAC0CLIENTRXSTATSVLD          (EMAC0CLIENTRXSTATSVLD),
        .EMAC0CLIENTRXSTATSBYTEVLD      (EMAC0CLIENTRXSTATSBYTEVLD),

        // Client Transmitter Interface - EMAC0
        .EMAC0CLIENTTXCLIENTCLKOUT      (tx_client_clk_out_0_i),
        .CLIENTEMAC0TXCLIENTCLKIN       (tx_client_clk_in_0_i),
        .CLIENTEMAC0TXD                 (CLIENTEMAC0TXD),
        .CLIENTEMAC0TXDVLD              (CLIENTEMAC0TXDVLD),
        .CLIENTEMAC0TXDVLDMSW           (1'b0),
        .EMAC0CLIENTTXACK               (EMAC0CLIENTTXACK),
        .CLIENTEMAC0TXFIRSTBYTE         (CLIENTEMAC0TXFIRSTBYTE),
        .CLIENTEMAC0TXUNDERRUN          (CLIENTEMAC0TXUNDERRUN),
        .EMAC0CLIENTTXCOLLISION         (EMAC0CLIENTTXCOLLISION),
        .EMAC0CLIENTTXRETRANSMIT        (EMAC0CLIENTTXRETRANSMIT),
        .CLIENTEMAC0TXIFGDELAY          (CLIENTEMAC0TXIFGDELAY),
        .EMAC0CLIENTTXSTATS             (EMAC0CLIENTTXSTATS),
        .EMAC0CLIENTTXSTATSVLD          (EMAC0CLIENTTXSTATSVLD),
        .EMAC0CLIENTTXSTATSBYTEVLD      (EMAC0CLIENTTXSTATSBYTEVLD),

        // MAC Control Interface - EMAC0
        .CLIENTEMAC0PAUSEREQ            (CLIENTEMAC0PAUSEREQ),
        .CLIENTEMAC0PAUSEVAL            (CLIENTEMAC0PAUSEVAL),

        // Clock Signals - EMAC0
        .GTX_CLK_0                      (usrclk2),
        .EMAC0PHYTXGMIIMIICLKOUT        (),
        .PHYEMAC0TXGMIIMIICLKIN         (1'b0),

        // 1000BASE-X PCS/PMA Interface - EMAC0
        .RXDATA_0                       (mgt_rx_data_0_i),
        .TXDATA_0                       (mgt_tx_data_0_i),
        .DCM_LOCKED_0                   (emac_locked_0_i  ),
        .AN_INTERRUPT_0                 (EMAC0ANINTERRUPT),
        .SIGNAL_DETECT_0                (signal_detect_0_i), 
        .PHYAD_0                        (PHYAD_0), 
        .ENCOMMAALIGN_0                 (encommaalign_0_i),
        .LOOPBACKMSB_0                  (loopback_0_i),
        .MGTRXRESET_0                   (mgt_rx_reset_0_i),
        .MGTTXRESET_0                   (mgt_tx_reset_0_i),
        .POWERDOWN_0                    (powerdown_0_i),
        .SYNCACQSTATUS_0                (EMAC0CLIENTSYNCACQSTATUS),
        .RXCLKCORCNT_0                  (rxclkcorcnt_0_i),
        .RXBUFSTATUS_0                  (rxbufstatus_0_i),
        .RXCHARISCOMMA_0                (rxchariscomma_0_i),
        .RXCHARISK_0                    (rxcharisk_0_i),
        .RXDISPERR_0                    (rxdisperr_0_i),
        .RXNOTINTABLE_0                 (rxnotintable_0_i),
        .RXREALIGN_0                    (1'b0),
        .RXRUNDISP_0                    (rxrundisp_0_i),
        .TXBUFERR_0                     (txbuferr_0_i),
        .TXRUNDISP_0                    (1'b0),
        .TXCHARDISPMODE_0               (txchardispmode_0_i),
        .TXCHARDISPVAL_0                (txchardispval_0_i),
        .TXCHARISK_0                    (txcharisk_0_i),

        // Client Receiver Interface - EMAC1
        .EMAC1CLIENTRXCLIENTCLKOUT      (rx_client_clk_out_1_i),
        .CLIENTEMAC1RXCLIENTCLKIN       (rx_client_clk_in_1_i),
        .EMAC1CLIENTRXD                 (EMAC1CLIENTRXD),
        .EMAC1CLIENTRXDVLD              (EMAC1CLIENTRXDVLD),
        .EMAC1CLIENTRXDVLDMSW           (),
        .EMAC1CLIENTRXGOODFRAME         (EMAC1CLIENTRXGOODFRAME),
        .EMAC1CLIENTRXBADFRAME          (EMAC1CLIENTRXBADFRAME),
        .EMAC1CLIENTRXFRAMEDROP         (EMAC1CLIENTRXFRAMEDROP),
        .EMAC1CLIENTRXSTATS             (EMAC1CLIENTRXSTATS),
        .EMAC1CLIENTRXSTATSVLD          (EMAC1CLIENTRXSTATSVLD),
        .EMAC1CLIENTRXSTATSBYTEVLD      (EMAC1CLIENTRXSTATSBYTEVLD),

        // Client Transmitter Interface - EMAC1
        .EMAC1CLIENTTXCLIENTCLKOUT      (tx_client_clk_out_1_i),
        .CLIENTEMAC1TXCLIENTCLKIN       (tx_client_clk_in_1_i),
        .CLIENTEMAC1TXD                 (CLIENTEMAC1TXD),
        .CLIENTEMAC1TXDVLD              (CLIENTEMAC1TXDVLD),
        .CLIENTEMAC1TXDVLDMSW           (1'b0),
        .EMAC1CLIENTTXACK               (EMAC1CLIENTTXACK),
        .CLIENTEMAC1TXFIRSTBYTE         (CLIENTEMAC1TXFIRSTBYTE),
        .CLIENTEMAC1TXUNDERRUN          (CLIENTEMAC1TXUNDERRUN),
        .EMAC1CLIENTTXCOLLISION         (EMAC1CLIENTTXCOLLISION),
        .EMAC1CLIENTTXRETRANSMIT        (EMAC1CLIENTTXRETRANSMIT),
        .CLIENTEMAC1TXIFGDELAY          (CLIENTEMAC1TXIFGDELAY),
        .EMAC1CLIENTTXSTATS             (EMAC1CLIENTTXSTATS),
        .EMAC1CLIENTTXSTATSVLD          (EMAC1CLIENTTXSTATSVLD),
        .EMAC1CLIENTTXSTATSBYTEVLD      (EMAC1CLIENTTXSTATSBYTEVLD),

        // MAC Control Interface - EMAC1
        .CLIENTEMAC1PAUSEREQ            (CLIENTEMAC1PAUSEREQ),
        .CLIENTEMAC1PAUSEVAL            (CLIENTEMAC1PAUSEVAL),

        // Clock Signals - EMAC1
        .GTX_CLK_1                      (usrclk2),
        .EMAC1PHYTXGMIIMIICLKOUT        (),
        .PHYEMAC1TXGMIIMIICLKIN         (1'b0),

        // 1000BASE-X PCS/PMA Interface - EMAC1
        .RXDATA_1                       (mgt_rx_data_1_i),
        .TXDATA_1                       (mgt_tx_data_1_i),
        .DCM_LOCKED_1                   (emac_locked_1_i  ),
        .AN_INTERRUPT_1                 (EMAC1ANINTERRUPT),
        .SIGNAL_DETECT_1                (signal_detect_1_i),
        .PHYAD_1                        (PHYAD_1), 
        .ENCOMMAALIGN_1                 (encommaalign_1_i),
        .LOOPBACKMSB_1                  (loopback_1_i),
        .MGTRXRESET_1                   (mgt_rx_reset_1_i),
        .MGTTXRESET_1                   (mgt_tx_reset_1_i),
        .POWERDOWN_1                    (powerdown_1_i),
        .SYNCACQSTATUS_1                (EMAC1CLIENTSYNCACQSTATUS),
        .RXCLKCORCNT_1                  (rxclkcorcnt_1_i),
        .RXBUFSTATUS_1                  (rxbufstatus_1_i),
        .RXCHARISCOMMA_1                (rxchariscomma_1_i),
        .RXCHARISK_1                    (rxcharisk_1_i),
        .RXDISPERR_1                    (rxdisperr_1_i),
        .RXNOTINTABLE_1                 (rxnotintable_1_i),
        .RXREALIGN_1                    (1'b0),
        .RXRUNDISP_1                    (rxrundisp_1_i),
        .TXBUFERR_1                     (txbuferr_1_i),
        .TXRUNDISP_1                    (1'b0),
        .TXCHARDISPMODE_1               (txchardispmode_1_i),
        .TXCHARDISPVAL_1                (txchardispval_1_i),
        .TXCHARISK_1                    (txcharisk_1_i),



        // Asynchronous Reset
        .RESET                          (reset_i)
        );


  
 
  
 



endmodule
