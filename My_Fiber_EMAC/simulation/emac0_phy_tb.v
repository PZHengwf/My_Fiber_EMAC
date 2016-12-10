//----------------------------------------------------------------------
// Title      : Demo testbench
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : emac0_phy_tb.v
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
//
// This testbench performs the following operations on the EMAC 
// and its design example:
//
//  - Four frames are pushed into the receiver from the PHY 
//    interface (Gigabit Trasnceiver):
//    The first is of minimum length (Length/Type = Length = 46 bytes).
//    The second frame sets Length/Type to Type = 0x8000. 
//    The third frame has an error inserted. 
//    The fourth frame only sends 4 bytes of data: the remainder of the 
//    data field is padded up to the minimum frame length i.e. 46 bytes.
//
//  - These frames are then parsed from the MAC into the MAC's design
//    example.  The design example provides a MAC client loopback 
//    function so that frames which are received without error will be 
//    looped back to the MAC transmitter and transmitted back to the
//    testbench.  The testbench verifies that this data matches that 
//    previously injected into the receiver.

`timescale 1ps / 1ps


// This module abstracts the frame data for simpler manipulation
module frame_typ_e0;

   // data field
   reg [7:0]  data  [0:61];
   reg        valid [0:61];
   reg        error [0:61];

   // Indicate to the testbench that the frame contains an error
   reg        bad_frame;    

`define FRAME_TYP [8*62+62+62+1:1]

   reg `FRAME_TYP bits;

   function `FRAME_TYP tobits;
      input dummy;
      begin
	  bits = {data[ 0],  data[ 1],  data[ 2],  data[ 3],  data[ 4],
	  	      data[ 5],  data[ 6],  data[ 7],  data[ 8],  data[ 9],
	  	      data[10],  data[11],  data[12],  data[13],  data[14],
	  	      data[15],  data[16],  data[17],  data[18],  data[19],
	  	      data[20],  data[21],  data[22],  data[23],  data[24],
	  	      data[25],  data[26],  data[27],  data[28],  data[29],
	  	      data[30],  data[31],  data[32],  data[33],  data[34], 
	  	      data[35],  data[36],  data[37],  data[38],  data[39], 
	  	      data[40],  data[41],  data[42],  data[43],  data[44], 
	  	      data[45],  data[46],  data[47],  data[48],  data[49], 
	  	      data[50],  data[51],  data[52],  data[53],  data[54], 
	  	      data[55],  data[56],  data[57],  data[58],  data[59], 
	  	      data[60],  data[61],
	  	       
	          valid[ 0], valid[ 1], valid[ 2], valid[ 3], valid[ 4],
	  	      valid[ 5], valid[ 6], valid[ 7], valid[ 8], valid[ 9],
	  	      valid[10], valid[11], valid[12], valid[13], valid[14],
	  	      valid[15], valid[16], valid[17], valid[18], valid[19],
	  	      valid[20], valid[21], valid[22], valid[23], valid[24],
	  	      valid[25], valid[26], valid[27], valid[28], valid[29],
	  	      valid[30], valid[31], valid[32], valid[33], valid[34], 
	  	      valid[35], valid[36], valid[37], valid[38], valid[39], 
	  	      valid[40], valid[41], valid[42], valid[43], valid[44], 
	  	      valid[45], valid[46], valid[47], valid[48], valid[49], 
	  	      valid[50], valid[51], valid[52], valid[53], valid[54], 
	  	      valid[55], valid[56], valid[57], valid[58], valid[59], 
	  	      valid[60], valid[61], 
	  	       
	          error[ 0], error[ 1], error[ 2], error[ 3], error[ 4],
	  	      error[ 5], error[ 6], error[ 7], error[ 8], error[ 9],
	  	      error[10], error[11], error[12], error[13], error[14],
	  	      error[15], error[16], error[17], error[18], error[19],
	  	      error[20], error[21], error[22], error[23], error[24],
	  	      error[25], error[26], error[27], error[28], error[29],
	  	      error[30], error[31], error[32], error[33], error[34], 
	  	      error[35], error[36], error[37], error[38], error[39], 
	  	      error[40], error[41], error[42], error[43], error[44], 
	  	      error[45], error[46], error[47], error[48], error[49], 
	  	      error[50], error[51], error[52], error[53], error[54], 
	  	      error[55], error[56], error[57], error[58], error[59], 
	  	      error[60], error[61], 

	  	      bad_frame};
	  tobits = bits;
      end
   endfunction // tobits

   task frombits;
      input `FRAME_TYP frame;
      begin
	  bits = frame;
	         {data[ 0],  data[ 1],  data[ 2],  data[ 3],  data[ 4],
	  	      data[ 5],  data[ 6],  data[ 7],  data[ 8],  data[ 9],
	  	      data[10],  data[11],  data[12],  data[13],  data[14],
	  	      data[15],  data[16],  data[17],  data[18],  data[19],
	  	      data[20],  data[21],  data[22],  data[23],  data[24],
	  	      data[25],  data[26],  data[27],  data[28],  data[29],
	  	      data[30],  data[31],  data[32],  data[33],  data[34], 
	  	      data[35],  data[36],  data[37],  data[38],  data[39], 
	  	      data[40],  data[41],  data[42],  data[43],  data[44], 
	  	      data[45],  data[46],  data[47],  data[48],  data[49], 
	  	      data[50],  data[51],  data[52],  data[53],  data[54], 
	  	      data[55],  data[56],  data[57],  data[58],  data[59], 
	  	      data[60],  data[61],
	  	       
	          valid[ 0], valid[ 1], valid[ 2], valid[ 3], valid[ 4],
	  	      valid[ 5], valid[ 6], valid[ 7], valid[ 8], valid[ 9],
	  	      valid[10], valid[11], valid[12], valid[13], valid[14],
	  	      valid[15], valid[16], valid[17], valid[18], valid[19],
	  	      valid[20], valid[21], valid[22], valid[23], valid[24],
	  	      valid[25], valid[26], valid[27], valid[28], valid[29],
	  	      valid[30], valid[31], valid[32], valid[33], valid[34], 
	  	      valid[35], valid[36], valid[37], valid[38], valid[39], 
	  	      valid[40], valid[41], valid[42], valid[43], valid[44], 
	  	      valid[45], valid[46], valid[47], valid[48], valid[49], 
	  	      valid[50], valid[51], valid[52], valid[53], valid[54], 
	  	      valid[55], valid[56], valid[57], valid[58], valid[59], 
	  	      valid[60], valid[61], 
	  	       
	          error[ 0], error[ 1], error[ 2], error[ 3], error[ 4],
	  	      error[ 5], error[ 6], error[ 7], error[ 8], error[ 9],
	  	      error[10], error[11], error[12], error[13], error[14],
	  	      error[15], error[16], error[17], error[18], error[19],
	  	      error[20], error[21], error[22], error[23], error[24],
	  	      error[25], error[26], error[27], error[28], error[29],
	  	      error[30], error[31], error[32], error[33], error[34], 
	  	      error[35], error[36], error[37], error[38], error[39], 
	  	      error[40], error[41], error[42], error[43], error[44], 
	  	      error[45], error[46], error[47], error[48], error[49], 
	  	      error[50], error[51], error[52], error[53], error[54], 
	  	      error[55], error[56], error[57], error[58], error[59], 
	  	      error[60], error[61],
	  	      
	  	      bad_frame} = bits;
      end
   endtask // frombits
   
endmodule // frame_typ_e0



// This module is the Gigabit Transcever stimulus / monitor
module emac0_phy_tb
  (
    clk125m,

    //----------------------------------------------------------------
    // Gigabit Transceiver Interface
    //----------------------------------------------------------------
    txp,
    txn,
    rxp,
    rxn, 

    //----------------------------------------------------------------
    // Test Bench Semaphores
    //----------------------------------------------------------------
    configuration_busy,
    monitor_finished_1g,
    monitor_finished_100m,
    monitor_finished_10m,

    monitor_error
    );


  // port declarations
  input            clk125m;
  input            txp;
  input            txn;
  output reg       rxp;
  output reg       rxn; 
  input            configuration_busy;
  output reg       monitor_finished_1g;
  output reg       monitor_finished_100m;
  output reg       monitor_finished_10m;
  output reg       monitor_error;

  
  //--------------------------------------------------------------------
  // types to support frame data
  //--------------------------------------------------------------------

   frame_typ_e0 frame0();
   frame_typ_e0 frame1();
   frame_typ_e0 frame2();
   frame_typ_e0 frame3();

   frame_typ_e0 rx_stimulus_working_frame();
   frame_typ_e0 tx_monitor_working_frame();


  //--------------------------------------------------------------------
  // Stimulus - Frame data 
  //--------------------------------------------------------------------
  // The following constant holds the stimulus for the testbench. It is 
  // an ordered array of frames, with frame 0 the first to be injected 
  // into the core transmit interface by the testbench. 
  //--------------------------------------------------------------------
  initial
  begin
    //-----------
    // Frame 0
    //-----------
    frame0.data[0]  = 8'h00;  frame0.valid[0]  = 1'b1;  frame0.error[0]  = 1'b0; // Destination Address (DA) 
    frame0.data[1]  = 8'h22;  frame0.valid[1]  = 1'b1;  frame0.error[1]  = 1'b0;
    frame0.data[2]  = 8'h19;  frame0.valid[2]  = 1'b1;  frame0.error[2]  = 1'b0;
    frame0.data[3]  = 8'h05;  frame0.valid[3]  = 1'b1;  frame0.error[3]  = 1'b0;
    frame0.data[4]  = 8'h1B;  frame0.valid[4]  = 1'b1;  frame0.error[4]  = 1'b0;
    frame0.data[5]  = 8'h9B;  frame0.valid[5]  = 1'b1;  frame0.error[5]  = 1'b0;
    frame0.data[6]  = 8'h5A;  frame0.valid[6]  = 1'b1;  frame0.error[6]  = 1'b0; // Source Address	(5A)
    frame0.data[7]  = 8'h02;  frame0.valid[7]  = 1'b1;  frame0.error[7]  = 1'b0; 
    frame0.data[8]  = 8'h03;  frame0.valid[8]  = 1'b1;  frame0.error[8]  = 1'b0; 
    frame0.data[9]  = 8'h04;  frame0.valid[9]  = 1'b1;  frame0.error[9]  = 1'b0;
    frame0.data[10] = 8'h05;  frame0.valid[10] = 1'b1;  frame0.error[10] = 1'b0;
    frame0.data[11] = 8'h06;  frame0.valid[11] = 1'b1;  frame0.error[11] = 1'b0;
    frame0.data[12] = 8'h00;  frame0.valid[12] = 1'b1;  frame0.error[12] = 1'b0;
    frame0.data[13] = 8'h2E;  frame0.valid[13] = 1'b1;  frame0.error[13] = 1'b0; // Length/Type = Length = 46
    frame0.data[14] = 8'h01;  frame0.valid[14] = 1'b1;  frame0.error[14] = 1'b0;  
    frame0.data[15] = 8'h02;  frame0.valid[15] = 1'b1;  frame0.error[15] = 1'b0;
    frame0.data[16] = 8'h03;  frame0.valid[16] = 1'b1;  frame0.error[16] = 1'b0;
    frame0.data[17] = 8'h04;  frame0.valid[17] = 1'b1;  frame0.error[17] = 1'b0;
    frame0.data[18] = 8'h05;  frame0.valid[18] = 1'b1;  frame0.error[18] = 1'b0;
    frame0.data[19] = 8'h06;  frame0.valid[19] = 1'b1;  frame0.error[19] = 1'b0;
    frame0.data[20] = 8'h07;  frame0.valid[20] = 1'b1;  frame0.error[20] = 1'b0; 
    frame0.data[21] = 8'h08;  frame0.valid[21] = 1'b1;  frame0.error[21] = 1'b0; 
    frame0.data[22] = 8'h09;  frame0.valid[22] = 1'b1;  frame0.error[22] = 1'b0;
    frame0.data[23] = 8'h0A;  frame0.valid[23] = 1'b1;  frame0.error[23] = 1'b0; 
    frame0.data[24] = 8'h0B;  frame0.valid[24] = 1'b1;  frame0.error[24] = 1'b0;
    frame0.data[25] = 8'h0C;  frame0.valid[25] = 1'b1;  frame0.error[25] = 1'b0;
    frame0.data[26] = 8'h0D;  frame0.valid[26] = 1'b1;  frame0.error[26] = 1'b0;
    frame0.data[27] = 8'h0E;  frame0.valid[27] = 1'b1;  frame0.error[27] = 1'b0;
    frame0.data[28] = 8'h0F;  frame0.valid[28] = 1'b1;  frame0.error[28] = 1'b0;
    frame0.data[29] = 8'h10;  frame0.valid[29] = 1'b1;  frame0.error[29] = 1'b0;
    frame0.data[30] = 8'h11;  frame0.valid[30] = 1'b1;  frame0.error[30] = 1'b0;
    frame0.data[31] = 8'h12;  frame0.valid[31] = 1'b1;  frame0.error[31] = 1'b0;
    frame0.data[32] = 8'h13;  frame0.valid[32] = 1'b1;  frame0.error[32] = 1'b0;
    frame0.data[33] = 8'h14;  frame0.valid[33] = 1'b1;  frame0.error[33] = 1'b0;
    frame0.data[34] = 8'h15;  frame0.valid[34] = 1'b1;  frame0.error[34] = 1'b0;
    frame0.data[35] = 8'h16;  frame0.valid[35] = 1'b1;  frame0.error[35] = 1'b0;
    frame0.data[36] = 8'h17;  frame0.valid[36] = 1'b1;  frame0.error[36] = 1'b0;
    frame0.data[37] = 8'h18;  frame0.valid[37] = 1'b1;  frame0.error[37] = 1'b0;
    frame0.data[38] = 8'h19;  frame0.valid[38] = 1'b1;  frame0.error[38] = 1'b0;
    frame0.data[39] = 8'h1A;  frame0.valid[39] = 1'b1;  frame0.error[39] = 1'b0;
    frame0.data[40] = 8'h1B;  frame0.valid[40] = 1'b1;  frame0.error[40] = 1'b0;
    frame0.data[41] = 8'h1C;  frame0.valid[41] = 1'b1;  frame0.error[41] = 1'b0;
    frame0.data[42] = 8'h1D;  frame0.valid[42] = 1'b1;  frame0.error[42] = 1'b0;
    frame0.data[43] = 8'h1E;  frame0.valid[43] = 1'b1;  frame0.error[43] = 1'b0;
    frame0.data[44] = 8'h1F;  frame0.valid[44] = 1'b1;  frame0.error[44] = 1'b0; 
    frame0.data[45] = 8'h20;  frame0.valid[45] = 1'b1;  frame0.error[45] = 1'b0;
    frame0.data[46] = 8'h21;  frame0.valid[46] = 1'b1;  frame0.error[46] = 1'b0;
    frame0.data[47] = 8'h22;  frame0.valid[47] = 1'b1;  frame0.error[47] = 1'b0;
    frame0.data[48] = 8'h23;  frame0.valid[48] = 1'b1;  frame0.error[48] = 1'b0;
    frame0.data[49] = 8'h24;  frame0.valid[49] = 1'b1;  frame0.error[49] = 1'b0;
    frame0.data[50] = 8'h25;  frame0.valid[50] = 1'b1;  frame0.error[50] = 1'b0;
    frame0.data[51] = 8'h26;  frame0.valid[51] = 1'b1;  frame0.error[51] = 1'b0; 
    frame0.data[52] = 8'h27;  frame0.valid[52] = 1'b1;  frame0.error[52] = 1'b0;
    frame0.data[53] = 8'h28;  frame0.valid[53] = 1'b1;  frame0.error[53] = 1'b0; 
    frame0.data[54] = 8'h29;  frame0.valid[54] = 1'b1;  frame0.error[54] = 1'b0;
    frame0.data[55] = 8'h2A;  frame0.valid[55] = 1'b1;  frame0.error[55] = 1'b0;
    frame0.data[56] = 8'h2B;  frame0.valid[56] = 1'b1;  frame0.error[56] = 1'b0;
    frame0.data[57] = 8'h2C;  frame0.valid[57] = 1'b1;  frame0.error[57] = 1'b0;
    frame0.data[58] = 8'h2D;  frame0.valid[58] = 1'b1;  frame0.error[58] = 1'b0;
    frame0.data[59] = 8'h2E;  frame0.valid[59] = 1'b1;  frame0.error[59] = 1'b0;	// 46th Byte of Data
    // unused
    frame0.data[60] = 8'h00;  frame0.valid[60] = 1'b0;  frame0.error[60] = 1'b0;
    frame0.data[61] = 8'h00;  frame0.valid[61] = 1'b0;  frame0.error[61] = 1'b0;

    // No error in this frame
    frame0.bad_frame  = 1'b0;


    //-----------
    // Frame 1
    //-----------
    frame1.data[0]  = 8'h00;  frame1.valid[0]  = 1'b1;  frame1.error[0]  = 1'b0; // Destination Address (DA) 
    frame1.data[1]  = 8'h22;  frame1.valid[1]  = 1'b1;  frame1.error[1]  = 1'b0;
    frame1.data[2]  = 8'h19;  frame1.valid[2]  = 1'b1;  frame1.error[2]  = 1'b0;
    frame1.data[3]  = 8'h05;  frame1.valid[3]  = 1'b1;  frame1.error[3]  = 1'b0;
    frame1.data[4]  = 8'h1B;  frame1.valid[4]  = 1'b1;  frame1.error[4]  = 1'b0;
    frame1.data[5]  = 8'h9B;  frame1.valid[5]  = 1'b1;  frame1.error[5]  = 1'b0;
    frame1.data[6]  = 8'h5A;  frame1.valid[6]  = 1'b1;  frame1.error[6]  = 1'b0; // Source Address	(5A)
    frame1.data[7]  = 8'h02;  frame1.valid[7]  = 1'b1;  frame1.error[7]  = 1'b0; 
    frame1.data[8]  = 8'h03;  frame1.valid[8]  = 1'b1;  frame1.error[8]  = 1'b0; 
    frame1.data[9]  = 8'h04;  frame1.valid[9]  = 1'b1;  frame1.error[9]  = 1'b0;
    frame1.data[10] = 8'h05;  frame1.valid[10] = 1'b1;  frame1.error[10] = 1'b0;
    frame1.data[11] = 8'h06;  frame1.valid[11] = 1'b1;  frame1.error[11] = 1'b0;
    frame1.data[12] = 8'h80;  frame1.valid[12] = 1'b1;  frame1.error[12] = 1'b0; // Length/Type = Type = 8000
    frame1.data[13] = 8'h00;  frame1.valid[13] = 1'b1;  frame1.error[13] = 1'b0; 
    frame1.data[14] = 8'h01;  frame1.valid[14] = 1'b1;  frame1.error[14] = 1'b0;  
    frame1.data[15] = 8'h02;  frame1.valid[15] = 1'b1;  frame1.error[15] = 1'b0;
    frame1.data[16] = 8'h03;  frame1.valid[16] = 1'b1;  frame1.error[16] = 1'b0;
    frame1.data[17] = 8'h04;  frame1.valid[17] = 1'b1;  frame1.error[17] = 1'b0;
    frame1.data[18] = 8'h05;  frame1.valid[18] = 1'b1;  frame1.error[18] = 1'b0;
    frame1.data[19] = 8'h06;  frame1.valid[19] = 1'b1;  frame1.error[19] = 1'b0;
    frame1.data[20] = 8'h07;  frame1.valid[20] = 1'b1;  frame1.error[20] = 1'b0; 
    frame1.data[21] = 8'h08;  frame1.valid[21] = 1'b1;  frame1.error[21] = 1'b0; 
    frame1.data[22] = 8'h09;  frame1.valid[22] = 1'b1;  frame1.error[22] = 1'b0;
    frame1.data[23] = 8'h0A;  frame1.valid[23] = 1'b1;  frame1.error[23] = 1'b0; 
    frame1.data[24] = 8'h0B;  frame1.valid[24] = 1'b1;  frame1.error[24] = 1'b0;
    frame1.data[25] = 8'h0C;  frame1.valid[25] = 1'b1;  frame1.error[25] = 1'b0;
    frame1.data[26] = 8'h0D;  frame1.valid[26] = 1'b1;  frame1.error[26] = 1'b0;
    frame1.data[27] = 8'h0E;  frame1.valid[27] = 1'b1;  frame1.error[27] = 1'b0;
    frame1.data[28] = 8'h0F;  frame1.valid[28] = 1'b1;  frame1.error[28] = 1'b0;
    frame1.data[29] = 8'h10;  frame1.valid[29] = 1'b1;  frame1.error[29] = 1'b0;
    frame1.data[30] = 8'h11;  frame1.valid[30] = 1'b1;  frame1.error[30] = 1'b0;
    frame1.data[31] = 8'h12;  frame1.valid[31] = 1'b1;  frame1.error[31] = 1'b0;
    frame1.data[32] = 8'h13;  frame1.valid[32] = 1'b1;  frame1.error[32] = 1'b0;
    frame1.data[33] = 8'h14;  frame1.valid[33] = 1'b1;  frame1.error[33] = 1'b0;
    frame1.data[34] = 8'h15;  frame1.valid[34] = 1'b1;  frame1.error[34] = 1'b0;
    frame1.data[35] = 8'h16;  frame1.valid[35] = 1'b1;  frame1.error[35] = 1'b0;
    frame1.data[36] = 8'h17;  frame1.valid[36] = 1'b1;  frame1.error[36] = 1'b0;
    frame1.data[37] = 8'h18;  frame1.valid[37] = 1'b1;  frame1.error[37] = 1'b0;
    frame1.data[38] = 8'h19;  frame1.valid[38] = 1'b1;  frame1.error[38] = 1'b0;
    frame1.data[39] = 8'h1A;  frame1.valid[39] = 1'b1;  frame1.error[39] = 1'b0;
    frame1.data[40] = 8'h1B;  frame1.valid[40] = 1'b1;  frame1.error[40] = 1'b0;
    frame1.data[41] = 8'h1C;  frame1.valid[41] = 1'b1;  frame1.error[41] = 1'b0;
    frame1.data[42] = 8'h1D;  frame1.valid[42] = 1'b1;  frame1.error[42] = 1'b0;
    frame1.data[43] = 8'h1E;  frame1.valid[43] = 1'b1;  frame1.error[43] = 1'b0;
    frame1.data[44] = 8'h1F;  frame1.valid[44] = 1'b1;  frame1.error[44] = 1'b0; 
    frame1.data[45] = 8'h20;  frame1.valid[45] = 1'b1;  frame1.error[45] = 1'b0;
    frame1.data[46] = 8'h21;  frame1.valid[46] = 1'b1;  frame1.error[46] = 1'b0;
    frame1.data[47] = 8'h22;  frame1.valid[47] = 1'b1;  frame1.error[47] = 1'b0;
    frame1.data[48] = 8'h23;  frame1.valid[48] = 1'b1;  frame1.error[48] = 1'b0;
    frame1.data[49] = 8'h24;  frame1.valid[49] = 1'b1;  frame1.error[49] = 1'b0;
    frame1.data[50] = 8'h25;  frame1.valid[50] = 1'b1;  frame1.error[50] = 1'b0;
    frame1.data[51] = 8'h26;  frame1.valid[51] = 1'b1;  frame1.error[51] = 1'b0; 
    frame1.data[52] = 8'h27;  frame1.valid[52] = 1'b1;  frame1.error[52] = 1'b0;
    frame1.data[53] = 8'h28;  frame1.valid[53] = 1'b1;  frame1.error[53] = 1'b0; 
    frame1.data[54] = 8'h29;  frame1.valid[54] = 1'b1;  frame1.error[54] = 1'b0;
    frame1.data[55] = 8'h2A;  frame1.valid[55] = 1'b1;  frame1.error[55] = 1'b0;
    frame1.data[56] = 8'h2B;  frame1.valid[56] = 1'b1;  frame1.error[56] = 1'b0;
    frame1.data[57] = 8'h2C;  frame1.valid[57] = 1'b1;  frame1.error[57] = 1'b0;
    frame1.data[58] = 8'h2D;  frame1.valid[58] = 1'b1;  frame1.error[58] = 1'b0;
    frame1.data[59] = 8'h2E;  frame1.valid[59] = 1'b1;  frame1.error[59] = 1'b0; 
    frame1.data[60] = 8'h2F;  frame1.valid[60] = 1'b1;  frame1.error[60] = 1'b0; // 47th Data byte
    // unused
    frame1.data[61] = 8'h00;  frame1.valid[61] = 1'b0;  frame1.error[61] = 1'b0;

    // No error in this frame
    frame1.bad_frame  = 1'b0;


    //-----------
    // Frame 2
    //-----------
    frame2.data[0]  = 8'h00;  frame2.valid[0]  = 1'b1;  frame2.error[0]  = 1'b0; // Destination Address (DA) 
    frame2.data[1]  = 8'h22;  frame2.valid[1]  = 1'b1;  frame2.error[1]  = 1'b0;
    frame2.data[2]  = 8'h19;  frame2.valid[2]  = 1'b1;  frame2.error[2]  = 1'b0;
    frame2.data[3]  = 8'h05;  frame2.valid[3]  = 1'b1;  frame2.error[3]  = 1'b0;
    frame2.data[4]  = 8'h1B;  frame2.valid[4]  = 1'b1;  frame2.error[4]  = 1'b0;
    frame2.data[5]  = 8'h9B;  frame2.valid[5]  = 1'b1;  frame2.error[5]  = 1'b0;
    frame2.data[6]  = 8'h5A;  frame2.valid[6]  = 1'b1;  frame2.error[6]  = 1'b0; // Source Address	(5A)
    frame2.data[7]  = 8'h02;  frame2.valid[7]  = 1'b1;  frame2.error[7]  = 1'b0;  
    frame2.data[8]  = 8'h03;  frame2.valid[8]  = 1'b1;  frame2.error[8]  = 1'b0;  
    frame2.data[9]  = 8'h04;  frame2.valid[9]  = 1'b1;  frame2.error[9]  = 1'b0;
    frame2.data[10] = 8'h05;  frame2.valid[10] = 1'b1;  frame2.error[10] = 1'b0;
    frame2.data[11] = 8'h06;  frame2.valid[11] = 1'b1;  frame2.error[11] = 1'b0;
    frame2.data[12] = 8'h00;  frame2.valid[12] = 1'b1;  frame2.error[12] = 1'b0;
    frame2.data[13] = 8'h2E;  frame2.valid[13] = 1'b1;  frame2.error[13] = 1'b0; // Length/Type = Length = 46
    frame2.data[14] = 8'h01;  frame2.valid[14] = 1'b1;  frame2.error[14] = 1'b0;  
    frame2.data[15] = 8'h02;  frame2.valid[15] = 1'b1;  frame2.error[15] = 1'b0;
    frame2.data[16] = 8'h03;  frame2.valid[16] = 1'b1;  frame2.error[16] = 1'b0;
    frame2.data[17] = 8'h00;  frame2.valid[17] = 1'b1;  frame2.error[17] = 1'b0; // Underrun this frame
    frame2.data[18] = 8'h00;  frame2.valid[18] = 1'b1;  frame2.error[18] = 1'b0;
    frame2.data[19] = 8'h00;  frame2.valid[19] = 1'b1;  frame2.error[19] = 1'b0;
    frame2.data[20] = 8'h00;  frame2.valid[20] = 1'b1;  frame2.error[20] = 1'b0;
    frame2.data[21] = 8'h00;  frame2.valid[21] = 1'b1;  frame2.error[21] = 1'b0; 
    frame2.data[22] = 8'h00;  frame2.valid[22] = 1'b1;  frame2.error[22] = 1'b0;
    frame2.data[23] = 8'h00;  frame2.valid[23] = 1'b1;  frame2.error[23] = 1'b1; // Error asserted 
    frame2.data[24] = 8'h00;  frame2.valid[24] = 1'b1;  frame2.error[24] = 1'b0;
    frame2.data[25] = 8'h00;  frame2.valid[25] = 1'b1;  frame2.error[25] = 1'b0;
    frame2.data[26] = 8'h00;  frame2.valid[26] = 1'b1;  frame2.error[26] = 1'b0;
    frame2.data[27] = 8'h00;  frame2.valid[27] = 1'b1;  frame2.error[27] = 1'b0;
    frame2.data[28] = 8'h00;  frame2.valid[28] = 1'b1;  frame2.error[28] = 1'b0;
    frame2.data[29] = 8'h00;  frame2.valid[29] = 1'b1;  frame2.error[29] = 1'b0;
    frame2.data[30] = 8'h00;  frame2.valid[30] = 1'b1;  frame2.error[30] = 1'b0;
    frame2.data[31] = 8'h00;  frame2.valid[31] = 1'b1;  frame2.error[31] = 1'b0;
    frame2.data[32] = 8'h00;  frame2.valid[32] = 1'b1;  frame2.error[32] = 1'b0;
    frame2.data[33] = 8'h00;  frame2.valid[33] = 1'b1;  frame2.error[33] = 1'b0;
    frame2.data[34] = 8'h00;  frame2.valid[34] = 1'b1;  frame2.error[34] = 1'b0;
    frame2.data[35] = 8'h00;  frame2.valid[35] = 1'b1;  frame2.error[35] = 1'b0;
    frame2.data[36] = 8'h00;  frame2.valid[36] = 1'b1;  frame2.error[36] = 1'b0;
    frame2.data[37] = 8'h00;  frame2.valid[37] = 1'b1;  frame2.error[37] = 1'b0;
    frame2.data[38] = 8'h00;  frame2.valid[38] = 1'b1;  frame2.error[38] = 1'b0;
    frame2.data[39] = 8'h00;  frame2.valid[39] = 1'b1;  frame2.error[39] = 1'b0;
    frame2.data[40] = 8'h00;  frame2.valid[40] = 1'b1;  frame2.error[40] = 1'b0;
    frame2.data[41] = 8'h00;  frame2.valid[41] = 1'b1;  frame2.error[41] = 1'b0;
    frame2.data[42] = 8'h00;  frame2.valid[42] = 1'b1;  frame2.error[42] = 1'b0;
    frame2.data[43] = 8'h00;  frame2.valid[43] = 1'b1;  frame2.error[43] = 1'b0;
    frame2.data[44] = 8'h00;  frame2.valid[44] = 1'b1;  frame2.error[44] = 1'b0; 
    frame2.data[45] = 8'h00;  frame2.valid[45] = 1'b1;  frame2.error[45] = 1'b0;
    frame2.data[46] = 8'h00;  frame2.valid[46] = 1'b1;  frame2.error[46] = 1'b0;
    frame2.data[47] = 8'h00;  frame2.valid[47] = 1'b1;  frame2.error[47] = 1'b0; 
    frame2.data[48] = 8'h00;  frame2.valid[48] = 1'b1;  frame2.error[48] = 1'b0;
    frame2.data[49] = 8'h00;  frame2.valid[49] = 1'b1;  frame2.error[49] = 1'b0;
    frame2.data[50] = 8'h00;  frame2.valid[50] = 1'b1;  frame2.error[50] = 1'b0;
    frame2.data[51] = 8'h00;  frame2.valid[51] = 1'b1;  frame2.error[51] = 1'b0; 
    frame2.data[52] = 8'h00;  frame2.valid[52] = 1'b1;  frame2.error[52] = 1'b0;
    frame2.data[53] = 8'h00;  frame2.valid[53] = 1'b1;  frame2.error[53] = 1'b0; 
    frame2.data[54] = 8'h00;  frame2.valid[54] = 1'b1;  frame2.error[54] = 1'b0;
    frame2.data[55] = 8'h00;  frame2.valid[55] = 1'b1;  frame2.error[55] = 1'b0;
    frame2.data[56] = 8'h00;  frame2.valid[56] = 1'b1;  frame2.error[56] = 1'b0;
    frame2.data[57] = 8'h00;  frame2.valid[57] = 1'b1;  frame2.error[57] = 1'b0;
    frame2.data[58] = 8'h00;  frame2.valid[58] = 1'b1;  frame2.error[58] = 1'b0;
    frame2.data[59] = 8'h00;  frame2.valid[59] = 1'b1;  frame2.error[59] = 1'b0;
    // unused
    frame2.data[60] = 8'h00;  frame2.valid[60] = 1'b0;  frame2.error[60] = 1'b0;
    frame2.data[61] = 8'h00;  frame2.valid[61] = 1'b0;  frame2.error[61] = 1'b0;
    												    
    // Error this frame
    frame2.bad_frame  = 1'b1;


    //-----------
    // Frame 3
    //-----------
    frame3.data[0]  = 8'h00;  frame3.valid[0]  = 1'b1;  frame3.error[0]  = 1'b0; // Destination Address (DA) 
    frame3.data[1]  = 8'h22;  frame3.valid[1]  = 1'b1;  frame3.error[1]  = 1'b0;
    frame3.data[2]  = 8'h19;  frame3.valid[2]  = 1'b1;  frame3.error[2]  = 1'b0;
    frame3.data[3]  = 8'h05;  frame3.valid[3]  = 1'b1;  frame3.error[3]  = 1'b0;
    frame3.data[4]  = 8'h1B;  frame3.valid[4]  = 1'b1;  frame3.error[4]  = 1'b0;
    frame3.data[5]  = 8'h9B;  frame3.valid[5]  = 1'b1;  frame3.error[5]  = 1'b0;
    frame3.data[6]  = 8'h5A;  frame3.valid[6]  = 1'b1;  frame3.error[6]  = 1'b0; // Source Address	(5A)
    frame3.data[7]  = 8'h02;  frame3.valid[7]  = 1'b1;  frame3.error[7]  = 1'b0; 
    frame3.data[8]  = 8'h03;  frame3.valid[8]  = 1'b1;  frame3.error[8]  = 1'b0; 
    frame3.data[9]  = 8'h04;  frame3.valid[9]  = 1'b1;  frame3.error[9]  = 1'b0;
    frame3.data[10] = 8'h05;  frame3.valid[10] = 1'b1;  frame3.error[10] = 1'b0;
    frame3.data[11] = 8'h06;  frame3.valid[11] = 1'b1;  frame3.error[11] = 1'b0;
    frame3.data[12] = 8'h00;  frame3.valid[12] = 1'b1;  frame3.error[12] = 1'b0;
    frame3.data[13] = 8'h03;  frame3.valid[13] = 1'b1;  frame3.error[13] = 1'b0; // Length/Type = Length = 03
    frame3.data[14] = 8'h01;  frame3.valid[14] = 1'b1;  frame3.error[14] = 1'b0; // Therefore padding is required 
    frame3.data[15] = 8'h02;  frame3.valid[15] = 1'b1;  frame3.error[15] = 1'b0; 
    frame3.data[16] = 8'h03;  frame3.valid[16] = 1'b1;  frame3.error[16] = 1'b0;
    frame3.data[17] = 8'h00;  frame3.valid[17] = 1'b1;  frame3.error[17] = 1'b0; // Padding starts here
    frame3.data[18] = 8'h00;  frame3.valid[18] = 1'b1;  frame3.error[18] = 1'b0;
    frame3.data[19] = 8'h00;  frame3.valid[19] = 1'b1;  frame3.error[19] = 1'b0;
    frame3.data[20] = 8'h00;  frame3.valid[20] = 1'b1;  frame3.error[20] = 1'b0;
    frame3.data[21] = 8'h00;  frame3.valid[21] = 1'b1;  frame3.error[21] = 1'b0; 
    frame3.data[22] = 8'h00;  frame3.valid[22] = 1'b1;  frame3.error[22] = 1'b0;	
    frame3.data[23] = 8'h00;  frame3.valid[23] = 1'b1;  frame3.error[23] = 1'b0; 
    frame3.data[24] = 8'h00;  frame3.valid[24] = 1'b1;  frame3.error[24] = 1'b0;
    frame3.data[25] = 8'h00;  frame3.valid[25] = 1'b1;  frame3.error[25] = 1'b0;	
    frame3.data[26] = 8'h00;  frame3.valid[26] = 1'b1;  frame3.error[26] = 1'b0;
    frame3.data[27] = 8'h00;  frame3.valid[27] = 1'b1;  frame3.error[27] = 1'b0;
    frame3.data[28] = 8'h00;  frame3.valid[28] = 1'b1;  frame3.error[28] = 1'b0;
    frame3.data[29] = 8'h00;  frame3.valid[29] = 1'b1;  frame3.error[29] = 1'b0;
    frame3.data[30] = 8'h00;  frame3.valid[30] = 1'b1;  frame3.error[30] = 1'b0;
    frame3.data[31] = 8'h00;  frame3.valid[31] = 1'b1;  frame3.error[31] = 1'b0;
    frame3.data[32] = 8'h00;  frame3.valid[32] = 1'b1;  frame3.error[32] = 1'b0;
    frame3.data[33] = 8'h00;  frame3.valid[33] = 1'b1;  frame3.error[33] = 1'b0;
    frame3.data[34] = 8'h00;  frame3.valid[34] = 1'b1;  frame3.error[34] = 1'b0;
    frame3.data[35] = 8'h00;  frame3.valid[35] = 1'b1;  frame3.error[35] = 1'b0;
    frame3.data[36] = 8'h00;  frame3.valid[36] = 1'b1;  frame3.error[36] = 1'b0;
    frame3.data[37] = 8'h00;  frame3.valid[37] = 1'b1;  frame3.error[37] = 1'b0;
    frame3.data[38] = 8'h00;  frame3.valid[38] = 1'b1;  frame3.error[38] = 1'b0;
    frame3.data[39] = 8'h00;  frame3.valid[39] = 1'b1;  frame3.error[39] = 1'b0;
    frame3.data[40] = 8'h00;  frame3.valid[40] = 1'b1;  frame3.error[40] = 1'b0;
    frame3.data[41] = 8'h00;  frame3.valid[41] = 1'b1;  frame3.error[41] = 1'b0;
    frame3.data[42] = 8'h00;  frame3.valid[42] = 1'b1;  frame3.error[42] = 1'b0;
    frame3.data[43] = 8'h00;  frame3.valid[43] = 1'b1;  frame3.error[43] = 1'b0;
    frame3.data[44] = 8'h00;  frame3.valid[44] = 1'b1;  frame3.error[44] = 1'b0; 
    frame3.data[45] = 8'h00;  frame3.valid[45] = 1'b1;  frame3.error[45] = 1'b0;
    frame3.data[46] = 8'h00;  frame3.valid[46] = 1'b1;  frame3.error[46] = 1'b0;
    frame3.data[47] = 8'h00;  frame3.valid[47] = 1'b1;  frame3.error[47] = 1'b0; 
    frame3.data[48] = 8'h00;  frame3.valid[48] = 1'b1;  frame3.error[48] = 1'b0;
    frame3.data[49] = 8'h00;  frame3.valid[49] = 1'b1;  frame3.error[49] = 1'b0;
    frame3.data[50] = 8'h00;  frame3.valid[50] = 1'b1;  frame3.error[50] = 1'b0;
    frame3.data[51] = 8'h00;  frame3.valid[51] = 1'b1;  frame3.error[51] = 1'b0; 
    frame3.data[52] = 8'h00;  frame3.valid[52] = 1'b1;  frame3.error[52] = 1'b0;
    frame3.data[53] = 8'h00;  frame3.valid[53] = 1'b1;  frame3.error[53] = 1'b0; 
    frame3.data[54] = 8'h00;  frame3.valid[54] = 1'b1;  frame3.error[54] = 1'b0;
    frame3.data[55] = 8'h00;  frame3.valid[55] = 1'b1;  frame3.error[55] = 1'b0;
    frame3.data[56] = 8'h00;  frame3.valid[56] = 1'b1;  frame3.error[56] = 1'b0;
    frame3.data[57] = 8'h00;  frame3.valid[57] = 1'b1;  frame3.error[57] = 1'b0;
    frame3.data[58] = 8'h00;  frame3.valid[58] = 1'b1;  frame3.error[58] = 1'b0;
    frame3.data[59] = 8'h00;  frame3.valid[59] = 1'b1;  frame3.error[59] = 1'b0;
    // unused
    frame3.data[60] = 8'h00;  frame3.valid[60] = 1'b0;  frame3.error[60] = 1'b0;
    frame3.data[61] = 8'h00;  frame3.valid[61] = 1'b0;  frame3.error[61] = 1'b0;

    // No error in this frame
    frame3.bad_frame  = 1'b0;

  end



  //--------------------------------------------------------------------
  // CRC engine 
  //--------------------------------------------------------------------
  task calc_crc;
    input  [7:0]  data;
    inout  [31:0] fcs;

    reg [31:0] crc;
    reg        crc_feedback;	  
    integer    I;
  begin

    crc = ~ fcs;

    for (I = 0; I < 8; I = I + 1)
    begin
      crc_feedback = crc[0] ^ data[I];

      crc[0]       = crc[1];
      crc[1]       = crc[2];
      crc[2]       = crc[3];
      crc[3]       = crc[4];
      crc[4]       = crc[5];
      crc[5]       = crc[6]  ^ crc_feedback;
      crc[6]       = crc[7];
      crc[7]       = crc[8];
      crc[8]       = crc[9]  ^ crc_feedback;
      crc[9]       = crc[10] ^ crc_feedback;
      crc[10]      = crc[11];
      crc[11]      = crc[12];
      crc[12]      = crc[13];
      crc[13]      = crc[14];
      crc[14]      = crc[15];
      crc[15]      = crc[16] ^ crc_feedback;
      crc[16]      = crc[17];
      crc[17]      = crc[18];
      crc[18]      = crc[19];
      crc[19]      = crc[20] ^ crc_feedback;
      crc[20]      = crc[21] ^ crc_feedback;
      crc[21]      = crc[22] ^ crc_feedback;
      crc[22]      = crc[23];
      crc[23]      = crc[24] ^ crc_feedback;
      crc[24]      = crc[25] ^ crc_feedback;
      crc[25]      = crc[26];
      crc[26]      = crc[27] ^ crc_feedback;
      crc[27]      = crc[28] ^ crc_feedback;
      crc[28]      = crc[29];
      crc[29]      = crc[30] ^ crc_feedback;
      crc[30]      = crc[31] ^ crc_feedback;
      crc[31]      =           crc_feedback;
    end

    // return the CRC result                                  
    fcs = ~ crc;

    end
  endtask // calc_crc



  //--------------------------------------------------------------------
  // Procedure to perform 8B10B decoding
  //--------------------------------------------------------------------

  // Decode the 8B10B code. No disparity verification is performed, just
  // a simple table lookup.
   task decode_8b10b;
      input  [0:9] d10;
      output [7:0] q8;
      output       is_k;
      reg          k28;
      reg    [9:0] d10_rev;
      integer I;
      begin
	 // reverse the 10B codeword
	 for (I = 0; I < 10; I = I + 1)
	   d10_rev[I] = d10[I];
	 case (d10_rev[5:0])
	   6'b000110 : q8[4:0] = 5'b00000;   //D.0
	   6'b111001 : q8[4:0] = 5'b00000;   //D.0
	   6'b010001 : q8[4:0] = 5'b00001;   //D.1
	   6'b101110 : q8[4:0] = 5'b00001;   //D.1
	   6'b010010 : q8[4:0] = 5'b00010;   //D.2
	   6'b101101 : q8[4:0] = 5'b00010;   //D.2
	   6'b100011 : q8[4:0] = 5'b00011;   //D.3
	   6'b010100 : q8[4:0] = 5'b00100;   //D.4
	   6'b101011 : q8[4:0] = 5'b00100;   //D.4
	   6'b100101 : q8[4:0] = 5'b00101;   //D.5
	   6'b100110 : q8[4:0] = 5'b00110;   //D.6
	   6'b000111 : q8[4:0] = 5'b00111;   //D.7
	   6'b111000 : q8[4:0] = 5'b00111;   //D.7
	   6'b011000 : q8[4:0] = 5'b01000;   //D.8
	   6'b100111 : q8[4:0] = 5'b01000;   //D.8
	   6'b101001 : q8[4:0] = 5'b01001;   //D.9
	   6'b101010 : q8[4:0] = 5'b01010;   //D.10
	   6'b001011 : q8[4:0] = 5'b01011;   //D.11
	   6'b101100 : q8[4:0] = 5'b01100;   //D.12
	   6'b001101 : q8[4:0] = 5'b01101;   //D.13
	   6'b001110 : q8[4:0] = 5'b01110;   //D.14
	   6'b000101 : q8[4:0] = 5'b01111;   //D.15
	   6'b111010 : q8[4:0] = 5'b01111;   //D.15
	   6'b110110 : q8[4:0] = 5'b10000;   //D.16
	   6'b001001 : q8[4:0] = 5'b10000;   //D.16
	   6'b110001 : q8[4:0] = 5'b10001;   //D.17
	   6'b110010 : q8[4:0] = 5'b10010;   //D.18
	   6'b010011 : q8[4:0] = 5'b10011;   //D.19
	   6'b110100 : q8[4:0] = 5'b10100;   //D.20
	   6'b010101 : q8[4:0] = 5'b10101;   //D.21
	   6'b010110 : q8[4:0] = 5'b10110;   //D.22
	   6'b010111 : q8[4:0] = 5'b10111;   //D/K.23
	   6'b101000 : q8[4:0] = 5'b10111;   //D/K.23
	   6'b001100 : q8[4:0] = 5'b11000;   //D.24
	   6'b110011 : q8[4:0] = 5'b11000;   //D.24
	   6'b011001 : q8[4:0] = 5'b11001;   //D.25
	   6'b011010 : q8[4:0] = 5'b11010;   //D.26
	   6'b011011 : q8[4:0] = 5'b11011;   //D/K.27
	   6'b100100 : q8[4:0] = 5'b11011;   //D/K.27
	   6'b011100 : q8[4:0] = 5'b11100;   //D.28
	   6'b111100 : q8[4:0] = 5'b11100;   //K.28
	   6'b000011 : q8[4:0] = 5'b11100;   //K.28
	   6'b011101 : q8[4:0] = 5'b11101;   //D/K.29
	   6'b100010 : q8[4:0] = 5'b11101;   //D/K.29
	   6'b011110 : q8[4:0] = 5'b11110;   //D.30
	   6'b100001 : q8[4:0] = 5'b11110;   //D.30
	   6'b110101 : q8[4:0] = 5'b11111;   //D.31
	   6'b001010 : q8[4:0] = 5'b11111;   //D.31
           default   : q8[4:0] = 5'b11110;    //CODE VIOLATION - return /E/
	 endcase
	 
	 k28 = ~((d10[2] | d10[3] | d10[4] | d10[5] | ~(d10[8] ^ d10[9])));
	 
	 case (d10_rev[9:6])
	   4'b0010 : q8[7:5] = 3'b000;       //D/K.x.0
	   4'b1101 : q8[7:5] = 3'b000;       //D/K.x.0
	   4'b1001 :
	     if (!k28)
	       q8[7:5] = 3'b001;             //D/K.x.1
             else
	       q8[7:5] = 3'b110;             //K28.6
	   4'b0110 :
             if (k28)
               q8[7:5] = 3'b001;         //K.28.1
             else
               q8[7:5] = 3'b110;         //D/K.x.6
	   4'b1010 :
             if (!k28)
               q8[7:5] = 3'b010;         //D/K.x.2
             else
               q8[7:5] = 3'b101;         //K28.5
	   4'b0101 :
             if (k28)
               q8[7:5] = 3'b010;         //K28.2
             else
               q8[7:5] = 3'b101;         //D/K.x.5
	   4'b0011 : q8[7:5] = 3'b011;       //D/K.x.3
	   4'b1100 : q8[7:5] = 3'b011;       //D/K.x.3
	   4'b0100 : q8[7:5] = 3'b100;       //D/K.x.4
	   4'b1011 : q8[7:5] = 3'b100;       //D/K.x.4
	   4'b0111 : q8[7:5] = 3'b111;       //D.x.7
	   4'b1000 : q8[7:5] = 3'b111;       //D.x.7
	   4'b1110 : q8[7:5] = 3'b111;       //D/K.x.7
	   4'b0001 : q8[7:5] = 3'b111;       //D/K.x.7
	   default : q8[7:5] = 3'b111;   //CODE VIOLATION - return /E/
	 endcase
	 is_k = ((d10[2] & d10[3] & d10[4] & d10[5])
		 | ~(d10[2] | d10[3] | d10[4] | d10[5])
		 | ((d10[4] ^ d10[5]) & ((d10[5] & d10[7] & d10[8] & d10[9])
					 | ~(d10[5] | d10[7] | d10[8] | d10[9]))));
	 
      end
   endtask // decode_8b10b


  
  //--------------------------------------------------------------------
  // Procedure to perform comma detection
  //--------------------------------------------------------------------

   function is_comma;
      input [0:9] codegroup;
      begin
	 case (codegroup[0:6])
	   7'b0011111 : is_comma = 1;
	   7'b1100000 : is_comma = 1;
	   default : is_comma = 0;
	 endcase // case(codegroup[0:6])
      end
   endfunction // is_comma


  //--------------------------------------------------------------------
  // Procedure to perform 8B10B encoding
  //--------------------------------------------------------------------

   task encode_8b10b;
      input [7:0] d8;
      input is_k;
      output [0:9] q10;
      input disparity_pos_in;
      output disparity_pos_out;
      reg [5:0] b6;
      reg [3:0] b4;
      reg k28, pdes6, a7, l13, l31, a, b, c, d, e;
      integer I;
      
      begin  // encode_8b10b
	 // precalculate some common terms
	 a = d8[0];
	 b = d8[1];
	 c = d8[2];
	 d = d8[3];
	 e = d8[4];

	 k28 = is_k && d8[4:0] === 5'b11100;
	 
	 l13 = (((a ^ b) & !(c | d))
            | ((c ^ d) & !(a | b)));

	 l31 = (((a ^ b) & (c & d))
		| ((c ^ d) & (a & b)));

	 a7 = is_k | ((l31 & d & !e & disparity_pos_in)
                   | (l13 & !d & e & !disparity_pos_in));

     // calculate the running disparity after the 5B6B block encode
	 if (k28)                           //K.28
	   if (!disparity_pos_in) 
             b6 = 6'b111100;
	   else
             b6 = 6'b000011;

	 else
	   case (d8[4:0])
             5'b00000 :                 //D.0
               if (disparity_pos_in)
		 b6 = 6'b000110;
               else
		 b6 = 6'b111001;
             5'b00001 :                 //D.1
               if (disparity_pos_in)
		 b6 = 6'b010001;
               else
		 b6 = 6'b101110;
             5'b00010 :                 //D.2
               if (disparity_pos_in)
		 b6 = 6'b010010;
               else
		 b6 = 6'b101101;
             5'b00011 :
	       b6 = 6'b100011;              //D.3
             5'b00100 :                 //-D.4
               if (disparity_pos_in)
		 b6 = 6'b010100;
               else
		 b6 = 6'b101011;
             5'b00101 :
               b6 = 6'b100101;          //D.5
             5'b00110 :
               b6 = 6'b100110;          //D.6
             5'b00111 :                 //D.7   
               if (!disparity_pos_in)
		 b6 = 6'b000111;
               else
		 b6 = 6'b111000;
             5'b01000 :                 //D.8
               if (disparity_pos_in)
		 b6 = 6'b011000;
               else
		 b6 = 6'b100111;
             5'b01001 :
               b6 = 6'b101001;          //D.9
             5'b01010 :
               b6 = 6'b101010;          //D.10
             5'b01011 :
               b6 = 6'b001011;          //D.11
             5'b01100 :
               b6 = 6'b101100;          //D.12
             5'b01101 :
               b6 = 6'b001101;          //D.13
             5'b01110 :
               b6 = 6'b001110;          //D.14
             5'b01111 :                 //D.15
               if (disparity_pos_in)
		 b6 = 6'b000101;
               else
		 b6 = 6'b111010;
           
             5'b10000 :                 //D.16
               if (!disparity_pos_in)
		 b6 = 6'b110110;
               else
		 b6 = 6'b001001;
           
             5'b10001 :
               b6 = 6'b110001;          //D.17
             5'b10010 :
               b6 = 6'b110010;          //D.18
             5'b10011 :
               b6 = 6'b010011;          //D.19
             5'b10100 :
               b6 = 6'b110100;          //D.20
             5'b10101 :
               b6 = 6'b010101;          //D.21
             5'b10110 :
               b6 = 6'b010110;          //D.22
             5'b10111 :                 //D/K.23
               if (!disparity_pos_in)
		 b6 = 6'b010111;
               else
		 b6 = 6'b101000;
             5'b11000 :                 //D.24
               if (disparity_pos_in)
		 b6 = 6'b001100;
               else
		 b6 = 6'b110011;
             5'b11001 :
               b6 = 6'b011001;          //D.25
             5'b11010 :
               b6 = 6'b011010;          //D.26
             5'b11011 :                 //D/K.27
               if (!disparity_pos_in)
		 b6 = 6'b011011;
               else
		 b6 = 6'b100100;
             5'b11100 :
               b6 = 6'b011100;          //D.28
             5'b11101 :                 //D/K.29
               if (!disparity_pos_in) 
		 b6 = 6'b011101;
               else
		 b6 = 6'b100010;
             5'b11110 :                 //D/K.30
               if (!disparity_pos_in)
		 b6 = 6'b011110;
               else
		 b6 = 6'b100001;
             5'b11111 :                 //D.31
               if (!disparity_pos_in)
		 b6 = 6'b110101;
               else
		 b6 = 6'b001010;
             default :
               b6 = 6'bXXXXXX;
	   endcase // case(d8[4:0])
	 
	 
	 // reverse the bits
	 for (I = 0; I < 6; I = I + 1)
	   q10[I] = b6[I];
	 

	 // calculate the running disparity after the 5B6B block encode
	 if (k28)
	   pdes6 = !disparity_pos_in;
	 else
	   case (d8[4:0])
             5'b00000 : pdes6 = !disparity_pos_in;
             5'b00001 : pdes6 = !disparity_pos_in;
             5'b00010 : pdes6 = !disparity_pos_in;
             5'b00011 : pdes6 = disparity_pos_in;
             5'b00100 : pdes6 = !disparity_pos_in;
             5'b00101 : pdes6 = disparity_pos_in;
             5'b00110 : pdes6 = disparity_pos_in;
             5'b00111 : pdes6 = disparity_pos_in;
             5'b01000 : pdes6 = !disparity_pos_in;
             5'b01001 : pdes6 = disparity_pos_in;
             5'b01010 : pdes6 = disparity_pos_in;
             5'b01011 : pdes6 = disparity_pos_in;
             5'b01100 : pdes6 = disparity_pos_in;
             5'b01101 : pdes6 = disparity_pos_in;
             5'b01110 : pdes6 = disparity_pos_in;
             5'b01111 : pdes6 = !disparity_pos_in;
             5'b10000 : pdes6 = !disparity_pos_in;
             5'b10001 : pdes6 = disparity_pos_in;
             5'b10010 : pdes6 = disparity_pos_in;
             5'b10011 : pdes6 = disparity_pos_in;
             5'b10100 : pdes6 = disparity_pos_in;
             5'b10101 : pdes6 = disparity_pos_in;
             5'b10110 : pdes6 = disparity_pos_in;
             5'b10111 : pdes6 = !disparity_pos_in;
             5'b11000 : pdes6 = !disparity_pos_in;
             5'b11001 : pdes6 = disparity_pos_in;
             5'b11010 : pdes6 = disparity_pos_in;
             5'b11011 : pdes6 = !disparity_pos_in;
             5'b11100 : pdes6 = disparity_pos_in;
             5'b11101 : pdes6 = !disparity_pos_in;
             5'b11110 : pdes6 = !disparity_pos_in;
             5'b11111 : pdes6 = !disparity_pos_in;
             default  : pdes6 = disparity_pos_in;
	   endcase // case(d8[4:0])

	 case (d8[7:5])
	   3'b000 :                     //D/K.x.0
             if (pdes6)
               b4 = 4'b0010;
	     else
               b4 = 4'b1101;
	   3'b001 :                     //D/K.x.1
             if (k28 && !pdes6)
               b4 = 4'b0110;
             else
               b4 = 4'b1001;
	   3'b010 :                     //D/K.x.2
             if (k28 && !pdes6)
               b4 = 4'b0101;
             else
               b4 = 4'b1010;
	   3'b011 :                     //D/K.x.3
             if (!pdes6)
               b4 = 4'b0011;
             else
               b4 = 4'b1100;
	   3'b100 :                     //D/K.x.4
             if (pdes6)
               b4 = 4'b0100;
             else
               b4 = 4'b1011;
	   3'b101 :                     //D/K.x.5
             if (k28 && !pdes6)
               b4 = 4'b1010;
             else
               b4 = 4'b0101;
	   3'b110 :                     //D/K.x.6
             if (k28 && !pdes6)
               b4 = 4'b1001;
             else
               b4 = 4'b0110;
	   3'b111 :                     //D.x.P7
             if (!a7)
               if (!pdes6)
		 b4 = 4'b0111;
               else
		 b4 = 4'b1000;
             else                   //D/K.y.A7
               if (!pdes6)
		 b4 = 4'b1110;
               else
		 b4 = 4'b0001;
	   default :
             b4 = 4'bXXXX;
	 endcase

	 // Reverse the bits
	 for (I = 0; I < 4; I = I + 1)
	   q10[I+6] = b4[I];
	 
	 // Calculate the running disparity after the 4B group
	 case (d8[7:5])
	   3'b000  : disparity_pos_out = ~pdes6;
	   3'b001  : disparity_pos_out = pdes6;
	   3'b010  : disparity_pos_out = pdes6;
	   3'b011  : disparity_pos_out = pdes6;
	   3'b100  : disparity_pos_out = ~pdes6;
	   3'b101  : disparity_pos_out = pdes6;
	   3'b110  : disparity_pos_out = pdes6;
	   3'b111  : disparity_pos_out = ~pdes6;
	   default : disparity_pos_out = pdes6;
	 endcase
      end
   endtask // encode_8b10b



  //--------------------------------------------------------------------
  // testbench signals and constants
  //--------------------------------------------------------------------

  // Unit Interval for Gigabit Ethernet
  parameter UI  = 800;  // 800 ps

  // testbench clocks and sampling
  reg       bitclock;         // clock running at RocketIO serial frequency
  reg       stim_rx_sample;   // Sample on every clock at 1Gbps, every 10 clocks at 100Mbps, every 100 clocks at 10Mbps 
  reg       mon_tx_sample;    // Sample on every clock at 1Gbps, every 10 clocks at 100Mbps, every 100 clocks at 10Mbps 

  // signals for the Tx monitor following 8B10B decode
  reg [7:0] tx_pdata;  
  reg       tx_is_k;

  // signals for the Rx stimulus prior to 8B10B encode
  reg [7:0] rx_pdata;  
  reg rx_is_k;  
  reg rx_even;                // Keep track of the even/odd position
  reg rx_rundisp_pos;         // Indicates +ve running disparity

  // testbench control signals
  reg [1:0] current_speed;

  //--------------------------------------------------------------------
  // Clock drivers
  //--------------------------------------------------------------------

  // drives bitclock at 1.25GHz
  initial
  begin
    bitclock <= 1'b0;
    forever
    begin	 
      bitclock <= 1'b0;
      #(UI/2);
      bitclock <= 1'b1;
      #(UI/2);
    end
  end


  //--------------------------------------------------------------------
  // Simulus processes
  //------------------
  // Send four frames through the MAC and Design Example
  //      -- frame 0 = minimum length frame
  //      -- frame 1 = type frame
  //      -- frame 2 = errored frame
  //      -- frame 3 = padded frame
  //--------------------------------------------------------------------


  // sample on every clock
  initial
  begin
    stim_rx_sample <= 1'b1; 
  end


  // A task to create an Idle /I1/ code group
  task send_I1;
    begin  
      rx_pdata  <= 8'hBC;  // /K28.5/
      rx_is_k   <= 1'b1;
      @(posedge clk125m);
      rx_pdata  <= 8'hC5;  // /D5.6/
      rx_is_k   <= 1'b0;
      @(posedge clk125m);
    end
  endtask // send_I1;


  // A task to create an Idle /I2/ code group
  task send_I2;
    begin  
      rx_pdata  <= 8'hBC;  // /K28.5/
      rx_is_k   <= 1'b1;
      @(posedge clk125m);
      rx_pdata  <= 8'h50;  // /D16.2/
      rx_is_k   <= 1'b0;
      @(posedge clk125m);
    end
  endtask // send_I2;


  // A task to create a Start of Packet /S/ code group 
  task send_S;
    begin  
      rx_pdata  <= 8'hFB;  // /K27.7/
      rx_is_k   <= 1'b1;
      @(posedge clk125m);
    end
  endtask // send_S;


  // A task to create a Terminate /T/ code group 
  task send_T;
    begin  
      rx_pdata  <= 8'hFD;  // /K29.7/
      rx_is_k   <= 1'b1;
      @(posedge clk125m);
    end
  endtask // send_T;


  // A task to create a Carrier Extend /R/ code group 
  task send_R;
    begin  
      rx_pdata  <= 8'hF7;  // /K23.7/
      rx_is_k   <= 1'b1;
      @(posedge clk125m);
    end
  endtask // send_R;


  // A task to create an Error Propogation /V/ code group 
  task send_V;
    begin  
      rx_pdata  <= 8'hFE;  // /K30.7/
      rx_is_k   <= 1'b1;
    end
  endtask // send_V;


  //---------------------------------------------------
  // Rx stimulus process. This task will create frames 						  
  // of data to be pushed into the receiver side of the 
  // Gigabit Transceiver.
  //---------------------------------------------------
  task rx_stimulus_send_frame;
    input   `FRAME_TYP frame;
    input   integer frame_number;
    integer current_col;
    reg [31:0] fcs;
    integer I;
    begin
      // import the frame into scratch space
      rx_stimulus_working_frame.frombits(frame);


      $display("EMAC0: Sending Frame %d", frame_number);

      // Send a Start of Packet code group
      //----------------------------------
      send_S;

      // Adding the preamble field
      //----------------------------------
      if (current_speed == 2'b10)
      begin
        // 1Gbps (the 1st preamble has been replaced with the /S/ character)
        for (I = 0; I < 6; I = I + 1)
        begin
          rx_pdata  <= 8'h55;
          rx_is_k   <= 1'b0;
          while (stim_rx_sample == 1'b0)
            @(posedge clk125m);

          @(posedge clk125m);
        end
      end
      else
      begin
        // 10/100Mbps (the 1st preamble should still be sent)
        for (I = 0; I < 7; I = I + 1)
        begin
          rx_pdata  <= 8'h55;
          rx_is_k   <= 1'b0;
          while (stim_rx_sample == 1'b0)
            @(posedge clk125m);

          @(posedge clk125m);
        end
      end

      // Adding the Start of Frame Delimiter (SFD)
      rx_pdata    <= 8'hD5;
      rx_is_k     <= 1'b0;
      fcs = 32'h0; // reset the FCS field
      while (stim_rx_sample == 1'b0)
        @(posedge clk125m);

      @(posedge clk125m);
        
      // Sending the MAC frame    	  
      //----------------------------------
	  current_col = 0;
      // loop over columns in frame.
      while (rx_stimulus_working_frame.valid[current_col] != 1'b0)
      begin	 
        calc_crc(rx_stimulus_working_frame.data[current_col], fcs);
        if (rx_stimulus_working_frame.error[current_col] == 1'b1)
        begin
          send_V; // insert an error propogation code group

          while (stim_rx_sample == 1'b0)
            @(posedge clk125m);

          @(posedge clk125m);
        end
        else
        begin	   
          rx_pdata <= rx_stimulus_working_frame.data[current_col];
          rx_is_k  <= 1'b0;

          while (stim_rx_sample == 1'b0)
            @(posedge clk125m);

          @(posedge clk125m);
        end
        current_col = current_col + 1;
      end // while

      // Send the FCS.
      //----------------------------------
      rx_pdata    <= fcs[7:0];	 
      rx_is_k     <= 1'b0;
      while (stim_rx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);

      rx_pdata    <= fcs[15:8];	 
      while (stim_rx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);

      rx_pdata    <= fcs[23:16];	 
      while (stim_rx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);

      rx_pdata    <= fcs[31:24];	 
      while (stim_rx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);

      // Send a frame termination sequence
      //----------------------------------
      send_T;    // Terminate code group
      send_R;    // Carrier Extend code group

      // An extra Carrier Extend code group should be sent to end the frame
      // on an even boundary.       
      if (rx_even == 1'b1)
        send_R;  // Carrier Extend code group  

      // Send an Inter Packet Gap.
      //----------------------------------
      // The initial Idle following a frame should be chosen to ensure
      // that the running disparity is returned to -ve.            
      if (rx_rundisp_pos == 1'b1)
        send_I1;  // /I1/ will flip the running disparity  
      else	
        send_I2;  // /I2/ will maintain the running disparity  

      // The remainder of the IPG is made up of /I2/ 's.

      // NOTE: the number 4 in the following calculation is made up 
      //      from 2 bytes of the termination sequence and 2 bytes from 
      //      the initial Idle.
      for (I = 0; I < 4; I = I + 1)     // 4 /I2/'s = 8 clock periods (12 - 4)
        send_I2; 
    end 
  endtask // rx_stimulus_send_frame;



  //---------------------------------------------------
  // Inject the frames into the Gigabit Transceiver 
  //---------------------------------------------------
  integer I;

  initial
  begin : p_rx_stimulus 

    current_speed <= 2'b10;  // 1G/s

    // Initialise stimulus
    rx_rundisp_pos <= 0;      // Initialise running disparity
    rx_pdata       <= 8'hBC;  // /K28.5/
    rx_is_k        <= 1'b1;

    // Wait for the testbench to initialise
    wait (configuration_busy == 1);

    @(posedge clk125m);
    // Initialisation sequence: always start I2 in even position
    if (rx_even == 1'b1)
    begin
      rx_pdata  <= 8'hBC;  // /K28.5/
      rx_is_k   <= 1'b1;
      @(posedge clk125m);
    end

    // Wait for the configuration to initialise the MAC
    while (configuration_busy !== 0)
      send_I2;

      rx_stimulus_send_frame(frame0.tobits(0), 0);
      rx_stimulus_send_frame(frame1.tobits(0), 1);
      rx_stimulus_send_frame(frame2.tobits(0), 2);
      rx_stimulus_send_frame(frame3.tobits(0), 3);

    // After the completion of the simulus, send Idles continuously
    forever
      send_I2;  

  end // p_rx_stimulus



  // A process to keep track of the even/odd code group position for the
  // injected receiver code groups.
  initial
  begin : p_rx_even_odd
    rx_even <= 1'b1;
    forever
    begin	 
      @(posedge clk125m)
      rx_even <= ! rx_even;
    end
  end // p_rx_even_odd


 
  // Data from the Rx Stimulus is 8B10B encoded and serialised so that
  // it can be injected into the RocketIO receiver port.

  // A task to serialise a single 10-bit code group
  task rx_stimulus_send_10b_column;
    input [0:9] d;
    integer I;
    begin
      for (I = 0; I < 10; I = I + 1)
        begin
          @(posedge bitclock)
          rxp <= d[I];
          rxn <= ~d[I];
        end // I
    end
  endtask // rx_stimulus_send_10b_column


  // 8B10B encode the Rx stimulus
  initial                 
  begin : p_rx_encode
    reg [0:9] encoded_data;
 
    // Get synced up with the Rx clock					   
    @(posedge clk125m)

    // Perform 8B10B encoding of the data stream
    forever
    begin	 
      encode_8b10b(
        rx_pdata,
        rx_is_k,
        encoded_data,
        rx_rundisp_pos,
        rx_rundisp_pos);

      rx_stimulus_send_10b_column(encoded_data);
    end // forever
  end // p_rx_encode



  //--------------------------------------------------------------------
  // Monitor processs.
  //------------------
  // These processes checks the data coming out of the
  // transmitter to make sure that it matches that inserted into the
  // receiver.
  //      -- frame 0 = minimum length frame
  //      -- frame 1 = type frame
  //      -- frame 2 = errored frame
  //      -- frame 3 = padded frame
  //
  // Repeated for all 3 speeds.
  //--------------------------------------------------------------------

 
  // The Phy side serial transmitter output from the core is captured, 
  // converted to 10-bit parallel and 8B10B decoded.  Correct Parallel 
  // alignment is achieved using comma detection.
  initial
  begin : p_tx_decode 

    reg [0:9] code_buffer;
    reg [7:0] decoded_data;
    integer bit_count;
    reg is_k_var;
    reg initial_sync;

    bit_count = 0;
    initial_sync = 0;

    forever
      begin
      @(posedge bitclock);
      #200	   
      code_buffer = {code_buffer[1:9], txp};
      // comma detection
      if (is_comma(code_buffer))
      begin
        bit_count = 0;
        initial_sync = 1;
      end

      if (bit_count == 0 && initial_sync)
      begin
        // Perform 8B10B decoding of the data stream
		decode_8b10b(code_buffer,
			         decoded_data,
			         is_k_var);

        // drive the output signals with the results
        tx_pdata <= decoded_data;

        if (is_k_var) 
          tx_is_k <= 1'b1;
        else
          tx_is_k <= 1'b0;
      end
      
      if (initial_sync)
      begin
        bit_count = bit_count + 1;
        if (bit_count == 10)
          bit_count = 0;
      end

    end // forever
  end // p_tx_decode


  // sample on every clock
  initial
  begin
    mon_tx_sample <= 1'b1; 
  end



  //---------------------------------------------------
  // Tx Monitor process. This task checks the frames 
  // coming out of the Gigabit Transceiver transmitter    
  // to make sure that they match those injected into 
  // the Gigabit Transceiver receiver.
  //---------------------------------------------------
  task tx_monitor_check_frame;
    input `FRAME_TYP frame;
    input  integer frame_number;
    integer current_col;
    reg [31:0] fcs;
    integer I;
  begin
    $timeformat(-9, 0, "ns", 7);

    monitor_error <= 1'b0;

    // import the frame into scratch space
    tx_monitor_working_frame.frombits(frame);

    current_col = 0;
    @(posedge clk125m);
    
    // If the current frame had an error inserted then it would have 
    // been dropped by the FIFO in the design example.  Therefore 
    // exit this task and move immediately on to the next frame.
    if (tx_monitor_working_frame.bad_frame !== 1'b1)
    begin

      // Detect the Start of Frame
      while (tx_pdata !== 8'hFB) // /K27.7/ character
        @(posedge clk125m);

      $display("EMAC0: Comparing Frame %d", frame_number);

      // Move past the Start of Frame code to the 1st byte of preamble
      while (mon_tx_sample == 1'b0)
        @(posedge clk125m);

      @(posedge clk125m);

      // wait until the SFD code is detected.  
      // NOTE: It is neccessary to resynchronise on the SFD as the preamble field
      //       may have shrunk.
      while (tx_pdata !== 8'hD5)
      begin
        while (mon_tx_sample == 1'b0)
          @(posedge clk125m);

        @(posedge clk125m);
      end

      // Move past the SFD to the 1st byte of destination address
      while (mon_tx_sample == 1'b0)
        @(posedge clk125m);

      fcs = 32'h0; // reset the FCS field

      @(posedge clk125m);

      // frame has started, loop over columns of frame
      while (tx_monitor_working_frame.valid[current_col] !== 1'b0)
      begin
            
        // The transmitted Destination Address was the Source Address of the injected frame
        if (current_col < 6) 
        begin
          calc_crc(tx_monitor_working_frame.data[current_col+6], fcs);
          if (tx_pdata !== tx_monitor_working_frame.data[(current_col+6)])
          begin
            $display("** ERROR: EMAC0: data incorrect during Destination Address at %t", $realtime);
            monitor_error <= 1'b1;
          end
        end

        // The transmitted Source Address was the Destination Address of the injected frame
        else if (current_col < 12)
        begin
          calc_crc(tx_monitor_working_frame.data[current_col-6], fcs);
          if (tx_pdata !== tx_monitor_working_frame.data[(current_col-6)])
          begin
            $display("** ERROR: EMAC0: data incorrect during Source Address at %t", $realtime);
            monitor_error <= 1'b1;
          end
        end
               
        // for remainder of frame
        else
        begin
          calc_crc(tx_monitor_working_frame.data[current_col], fcs);
          if (tx_pdata !== tx_monitor_working_frame.data[current_col])
          begin
            $display("** ERROR: EMAC0: data incorrect at %t", $realtime);
            monitor_error <= 1'b1;
          end
        end

        // wait for next column of data
        current_col = current_col + 1;
        while (mon_tx_sample == 1'b0)
          @(posedge clk125m);

        @(posedge clk125m);

      end

      // Check the FCS
      // Having checked all data columns, txd must contain FCS.
      if (tx_pdata !== fcs[7:0])
      begin
        $display("** ERROR: data incorrect during FCS field at %t", $realtime);
        monitor_error <= 1'b1;
      end
      while (mon_tx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);
    
      if (tx_pdata !== fcs[15:8])
      begin
        $display("** ERROR: data incorrect during FCS field at %t", $realtime);
        monitor_error <= 1'b1;
      end
      while (mon_tx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);
    
      if (tx_pdata !== fcs[23:16])
      begin
        $display("** ERROR: data incorrect during FCS field at %t", $realtime);
        monitor_error <= 1'b1;
      end
      while (mon_tx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);
    
      if (tx_pdata !== fcs[31:24])
      begin
        $display("** ERROR: data incorrect during FCS field at %t", $realtime);
        monitor_error <= 1'b1;
      end
      while (mon_tx_sample == 1'b0)
        @(posedge clk125m);
      @(posedge clk125m);
    
    end 
   end 
  endtask // tx_monitor_check_frame



  
  //---------------------------------------------------
  // Monitor the frames from the Gigabit Transceiver 
  //---------------------------------------------------
  initial
  begin : p_tx_monitor
   
    monitor_finished_1g   <= 0;
    monitor_finished_100m <= 0;
    monitor_finished_10m  <= 0;

    // first, get synced up with the TX clock
    while (mon_tx_sample == 1'b0)
      @(posedge clk125m);

    @(posedge clk125m);
    
      // parse all the frames in the stimulus vector
      tx_monitor_check_frame(frame0.tobits(0), 0);
      tx_monitor_check_frame(frame1.tobits(0), 1);
      tx_monitor_check_frame(frame2.tobits(0), 2);
      tx_monitor_check_frame(frame3.tobits(0), 3);

    monitor_finished_1g   <= 1;  

  end // p_rx_stimulus



endmodule // emac0_phy_tb
