//-----------------------------------------------------------------------------
// Title      : 1000BASE-X RocketIO wrapper
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : gtp_dual_1000X.v
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
// Description:  This is the Verilog instantiation of a Virtex-5 GTP    
//               RocketIO tile for the Embedded Ethernet MAC.
//
//               Two GTP's must be instantiated regardless of how many  
//               GTPs are used in the MGT tile. 
//----------------------------------------------------------------------

`timescale 1 ps / 1 ps

module GTP_dual_1000X
(
          RESETDONE_0,
          ENMCOMMAALIGN_0, 
          ENPCOMMAALIGN_0, 
          LOOPBACK_0, 
          POWERDOWN_0, 
          RXUSRCLK_0,
          RXUSRCLK2_0,
          RXRESET_0,          
          TXCHARDISPMODE_0, 
          TXCHARDISPVAL_0, 
          TXCHARISK_0, 
          TXDATA_0, 
          TXUSRCLK_0, 
          TXUSRCLK2_0, 
          TXRESET_0, 
          RXCHARISCOMMA_0, 
          RXCHARISK_0,
          RXCLKCORCNT_0,           
          RXDATA_0, 
          RXDISPERR_0, 
          RXNOTINTABLE_0,
          RXRUNDISP_0, 
          RXBUFERR_0, 
          TXBUFERR_0, 
          PLLLKDET_0, 
          TXOUTCLK_0, 
          RXELECIDLE_0,
          TX1N_0, 
          TX1P_0,
          RX1N_0, 
          RX1P_0,

          RESETDONE_1,
          ENMCOMMAALIGN_1, 
          ENPCOMMAALIGN_1, 
          LOOPBACK_1, 
          POWERDOWN_1,
          RXUSRCLK_1, 
          RXUSRCLK2_1, 
          RXRESET_1,          
          TXCHARDISPMODE_1, 
          TXCHARDISPVAL_1, 
          TXCHARISK_1, 
          TXDATA_1, 
          TXUSRCLK_1, 
          TXUSRCLK2_1, 
          TXRESET_1,
          RXCHARISCOMMA_1, 
          RXCHARISK_1,
          RXCLKCORCNT_1,           
          RXDATA_1, 
          RXDISPERR_1, 
          RXNOTINTABLE_1,
          RXRUNDISP_1, 
          RXBUFERR_1, 
          TXBUFERR_1, 
          PLLLKDET_1, 
          TXOUTCLK_1, 
          RXELECIDLE_1,
          TX1N_1, 
          TX1P_1,
          RX1N_1, 
          RX1P_1,


          CLK_DS,
          REFCLKOUT,
          GTRESET,
          PMARESET,
          DCM_LOCKED);

  output          RESETDONE_0;
  input           ENMCOMMAALIGN_0; 
  input           ENPCOMMAALIGN_0; 
  input           LOOPBACK_0; 
  input           POWERDOWN_0; 
  input           RXUSRCLK_0;
  input           RXUSRCLK2_0;
  input           RXRESET_0;          
  input           TXCHARDISPMODE_0; 
  input           TXCHARDISPVAL_0; 
  input           TXCHARISK_0; 
  input [7:0]     TXDATA_0; 
  input           TXUSRCLK_0; 
  input           TXUSRCLK2_0; 
  input           TXRESET_0; 
  output          RXCHARISCOMMA_0; 
  output          RXCHARISK_0;
  output [2:0]    RXCLKCORCNT_0;           
  output [7:0]    RXDATA_0; 
  output          RXDISPERR_0; 
  output          RXNOTINTABLE_0;
  output          RXRUNDISP_0; 
  output          RXBUFERR_0; 
  output          TXBUFERR_0; 
  output          PLLLKDET_0; 
  output          TXOUTCLK_0; 
  output          RXELECIDLE_0;
  output          TX1N_0; 
  output          TX1P_0;
  input           RX1N_0; 
  input           RX1P_0;

  output          RESETDONE_1;
  input           ENMCOMMAALIGN_1; 
  input           ENPCOMMAALIGN_1; 
  input           LOOPBACK_1; 
  input           POWERDOWN_1; 
  input           RXUSRCLK_1;
  input           RXUSRCLK2_1;
  input           RXRESET_1;          
  input           TXCHARDISPMODE_1; 
  input           TXCHARDISPVAL_1; 
  input           TXCHARISK_1; 
  input [7:0]     TXDATA_1; 
  input           TXUSRCLK_1; 
  input           TXUSRCLK2_1; 
  input           TXRESET_1; 
  output          RXCHARISCOMMA_1; 
  output          RXCHARISK_1;
  output [2:0]    RXCLKCORCNT_1;           
  output [7:0]    RXDATA_1; 
  output          RXDISPERR_1; 
  output          RXNOTINTABLE_1;
  output          RXRUNDISP_1; 
  output          RXBUFERR_1; 
  output          TXBUFERR_1; 
  output          PLLLKDET_1; 
  output          TXOUTCLK_1; 
  output          RXELECIDLE_1;
  output          TX1N_1; 
  output          TX1P_1;
  input           RX1N_1; 
  input           RX1P_1;


  input           CLK_DS;
  output          REFCLKOUT;
  input           GTRESET;
  input           PMARESET;
  input           DCM_LOCKED;

  //--------------------------------------------------------------------
  // Signal declarations for GTP
  //--------------------------------------------------------------------

   wire PLLLOCK;

            
   wire RXNOTINTABLE_0_INT;   
   wire [7:0] RXDATA_0_INT;
   wire RXCHARISK_0_INT;   
   wire RXDISPERR_0_INT;
   wire RXRUNDISP_0_INT;
   
   wire [1:0] RXBUFSTATUS_float0;
   wire TXBUFSTATUS_float0;

   wire gt_txoutclk1_0;

   reg  [7:0] RXDATA_0;
   reg  RXRUNDISP_0;
   reg  RXCHARISK_0;

   wire rxelecidle0_i;
   wire resetdone0_i;

   wire RXNOTINTABLE_1_INT;   
   wire [7:0] RXDATA_1_INT;
   wire RXCHARISK_1_INT;   
   wire RXDISPERR_1_INT;
   wire RXRUNDISP_1_INT;
   
   wire [1:0] RXBUFSTATUS_float1;
   wire TXBUFSTATUS_float1;

   wire gt_txoutclk1_1;

   reg  [7:0] RXDATA_1;
   reg  RXRUNDISP_1;
   reg  RXCHARISK_1;

   wire rxelecidle1_i;
   wire resetdone1_i;

   
   //--------------------------------------------------------------------
   // Wait for both PLL's to lock   
   //--------------------------------------------------------------------

   
   assign PLLLKDET_0        =   PLLLOCK;

   assign PLLLKDET_1        =   PLLLOCK;


   //--------------------------------------------------------------------
   // Wire internal signals to outputs   
   //--------------------------------------------------------------------

   assign RXNOTINTABLE_0  =   RXNOTINTABLE_0_INT;
   assign RXDISPERR_0     =   RXDISPERR_0_INT;
   assign TXOUTCLK_0      =   gt_txoutclk1_0;
   assign RESETDONE_0  = resetdone0_i;
   assign RXELECIDLE_0 = rxelecidle0_i;

  
   assign RXNOTINTABLE_1  =   RXNOTINTABLE_1_INT;
   assign RXDISPERR_1     =   RXDISPERR_1_INT;
   assign TXOUTCLK_1      =   gt_txoutclk1_1;
   assign RESETDONE_1 = resetdone1_i;
   assign RXELECIDLE_1 = rxelecidle1_i;

 

   //--------------------------------------------------------------------
   // Instantiate the Virtex-5 GTP
   // EMAC0 connects to GTP 0 and EMAC1 connects to GTP 1
   //--------------------------------------------------------------------
   
   // Direct from the RocketIO Wizard output
   ROCKETIO_WRAPPER_GTP #
    (
        .WRAPPER_SIM_GTPRESET_SPEEDUP           (1),
        .WRAPPER_SIM_PLL_PERDIV2                (9'h190)
    )
    GTP_1000X
    (
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .TILE0_CLKIN_IN                 (CLK_DS),
        .TILE0_GTPRESET_IN              (GTRESET),
        .TILE0_PLLLKDET_OUT             (PLLLOCK),
        .TILE0_REFCLKOUT_OUT            (REFCLKOUT),
        //---------------------- Loopback and Powerdown Ports ----------------------
        .TILE0_LOOPBACK0_IN             ({2'b00, LOOPBACK_0}),
        .TILE0_RXPOWERDOWN0_IN          ({POWERDOWN_0, POWERDOWN_0}),
        .TILE0_TXPOWERDOWN0_IN          ({POWERDOWN_0, POWERDOWN_0}),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .TILE0_RXCHARISCOMMA0_OUT       (RXCHARISCOMMA_0),
        .TILE0_RXCHARISK0_OUT           (RXCHARISK_0_INT),
        .TILE0_RXDISPERR0_OUT           (RXDISPERR_0_INT),
        .TILE0_RXNOTINTABLE0_OUT        (RXNOTINTABLE_0_INT),
        .TILE0_RXRUNDISP0_OUT           (RXRUNDISP_0_INT),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .TILE0_RXCLKCORCNT0_OUT         (RXCLKCORCNT_0),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .TILE0_RXENMCOMMAALIGN0_IN      (ENMCOMMAALIGN_0),
        .TILE0_RXENPCOMMAALIGN0_IN      (ENPCOMMAALIGN_0),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .TILE0_RXDATA0_OUT              (RXDATA_0_INT),
        .TILE0_RXRECCLK0_OUT            (),
        .TILE0_RXRESET0_IN              (RXRESET_0),
        .TILE0_RXUSRCLK0_IN             (RXUSRCLK_0),
        .TILE0_RXUSRCLK20_IN            (RXUSRCLK_0),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .TILE0_RXBUFSTATUS0_OUT         ({RXBUFERR_0, RXBUFSTATUS_float0}),
	.TILE0_RXBUFRESET0_IN           (RXRESET_0),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .TILE0_RXELECIDLE0_OUT          (rxelecidle0_i),
        .TILE0_RXN0_IN                  (RX1N_0),
        .TILE0_RXP0_IN                  (RX1P_0),       
        //------------- ResetDone Ports --------------------------------------------
        .TILE0_RESETDONE0_OUT           (resetdone0_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TILE0_TXCHARDISPMODE0_IN       (TXCHARDISPMODE_0),
        .TILE0_TXCHARDISPVAL0_IN        (TXCHARDISPVAL_0),
        .TILE0_TXCHARISK0_IN            (TXCHARISK_0),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TILE0_TXBUFSTATUS0_OUT         ({TXBUFERR_0, TXBUFSTATUS_float0}),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TILE0_TXDATA0_IN               (TXDATA_0),
        .TILE0_TXOUTCLK0_OUT            (gt_txoutclk1_0),
        .TILE0_TXRESET0_IN              (TXRESET_0),
        .TILE0_TXUSRCLK0_IN             (TXUSRCLK_0),
        .TILE0_TXUSRCLK20_IN            (TXUSRCLK2_0),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TILE0_TXN0_OUT                 (TX1N_0),
        .TILE0_TXP0_OUT                 (TX1P_0),
        //---------------------- Loopback and Powerdown Ports ----------------------
        .TILE0_LOOPBACK1_IN             ({2'b00, LOOPBACK_1}),
        .TILE0_RXPOWERDOWN1_IN          ({POWERDOWN_1, POWERDOWN_1}),
        .TILE0_TXPOWERDOWN1_IN          ({POWERDOWN_1, POWERDOWN_1}),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .TILE0_RXCHARISCOMMA1_OUT       (RXCHARISCOMMA_1),
        .TILE0_RXCHARISK1_OUT           (RXCHARISK_1_INT),
        .TILE0_RXDISPERR1_OUT           (RXDISPERR_1_INT),
        .TILE0_RXNOTINTABLE1_OUT        (RXNOTINTABLE_1_INT),
        .TILE0_RXRUNDISP1_OUT           (RXRUNDISP_1_INT),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .TILE0_RXCLKCORCNT1_OUT         (RXCLKCORCNT_1),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .TILE0_RXENMCOMMAALIGN1_IN      (ENMCOMMAALIGN_1),
        .TILE0_RXENPCOMMAALIGN1_IN      (ENPCOMMAALIGN_1),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .TILE0_RXDATA1_OUT              (RXDATA_1_INT),
        .TILE0_RXRECCLK1_OUT            (),
        .TILE0_RXRESET1_IN              (RXRESET_1),
        .TILE0_RXUSRCLK1_IN             (RXUSRCLK_1),
        .TILE0_RXUSRCLK21_IN            (RXUSRCLK_1),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .TILE0_RXBUFSTATUS1_OUT         ({RXBUFERR_1, RXBUFSTATUS_float1}),
	.TILE0_RXBUFRESET1_IN           (RXRESET_1),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .TILE0_RXELECIDLE1_OUT          (rxelecidle1_i),
        .TILE0_RXN1_IN                  (RX1N_1),
        .TILE0_RXP1_IN                  (RX1P_1),       
        //------------- ResetDone Ports --------------------------------------------
        .TILE0_RESETDONE1_OUT           (resetdone1_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TILE0_TXCHARDISPMODE1_IN       (TXCHARDISPMODE_1),
        .TILE0_TXCHARDISPVAL1_IN        (TXCHARDISPVAL_1),
        .TILE0_TXCHARISK1_IN            (TXCHARISK_1),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TILE0_TXBUFSTATUS1_OUT         ({TXBUFERR_1, TXBUFSTATUS_float1}),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TILE0_TXDATA1_IN               (TXDATA_1),
        .TILE0_TXOUTCLK1_OUT            (gt_txoutclk1_1),
        .TILE0_TXRESET1_IN              (TXRESET_1),
        .TILE0_TXUSRCLK1_IN             (TXUSRCLK_1),
        .TILE0_TXUSRCLK21_IN            (TXUSRCLK2_1),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TILE0_TXN1_OUT                 (TX1N_1),
        .TILE0_TXP1_OUT                 (TX1P_1)
   );

 
                       
   //---------------------------------------------------------------------------
   // EMAC0 to GTP logic shim
   //---------------------------------------------------------------------------

   // When the RXNOTINTABLE condition is detected, the Virtex5 RocketIO
   // GTP outputs the raw 10B code in a bit swapped order to that of the
   // Virtex-II Pro RocketIO.
   always @ (RXNOTINTABLE_0_INT, RXDISPERR_0_INT, RXCHARISK_0_INT, RXDATA_0_INT,
                         RXRUNDISP_0_INT)
   begin
      if (RXNOTINTABLE_0_INT == 1'b1)
      begin
         RXDATA_0[0] <= RXDISPERR_0_INT;
         RXDATA_0[1] <= RXCHARISK_0_INT;
         RXDATA_0[2] <= RXDATA_0_INT[7];
         RXDATA_0[3] <= RXDATA_0_INT[6];
         RXDATA_0[4] <= RXDATA_0_INT[5];
         RXDATA_0[5] <= RXDATA_0_INT[4];
         RXDATA_0[6] <= RXDATA_0_INT[3];
         RXDATA_0[7] <= RXDATA_0_INT[2];
         RXRUNDISP_0 <= RXDATA_0_INT[1];
         RXCHARISK_0 <= RXDATA_0_INT[0];
      end
      else
      begin
         RXDATA_0    <= RXDATA_0_INT;
         RXRUNDISP_0 <= RXRUNDISP_0_INT;
         RXCHARISK_0 <= RXCHARISK_0_INT;
      end
   end


   //---------------------------------------------------------------------------
   // EMAC1 to GTP logic shim
   //---------------------------------------------------------------------------

   // When the RXNOTINTABLE condition is detected, the Virtex5 RocketIO
   // GTP outputs the raw 10B code in a bit swapped order to that of the
   // Virtex-II Pro RocketIO.
   always @ (RXNOTINTABLE_1_INT, RXDISPERR_1_INT, RXCHARISK_1_INT, RXDATA_1_INT,
                         RXRUNDISP_1_INT)
   begin
      if (RXNOTINTABLE_1_INT == 1'b1)
      begin
         RXDATA_1[0] <= RXDISPERR_1_INT;
         RXDATA_1[1] <= RXCHARISK_1_INT;
         RXDATA_1[2] <= RXDATA_1_INT[7];
         RXDATA_1[3] <= RXDATA_1_INT[6];
         RXDATA_1[4] <= RXDATA_1_INT[5];
         RXDATA_1[5] <= RXDATA_1_INT[4];
         RXDATA_1[6] <= RXDATA_1_INT[3];
         RXDATA_1[7] <= RXDATA_1_INT[2];
         RXRUNDISP_1 <= RXDATA_1_INT[1];
         RXCHARISK_1 <= RXDATA_1_INT[0];
      end
      else
      begin
         RXDATA_1    <= RXDATA_1_INT;
         RXRUNDISP_1 <= RXRUNDISP_1_INT;
         RXCHARISK_1 <= RXCHARISK_1_INT;
      end
   end

endmodule

