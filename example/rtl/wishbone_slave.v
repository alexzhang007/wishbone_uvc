//*******************************************************************
// Copyright 2016 Opening Vision  (Shanghai) Inc
// All Rights Reserved.
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// OPENING VISION INC OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
//  Language : SystemVerilog 
//  Version  : 2.3
//  Author   : Alex Zhang
//  Date     : 02-26-2016
// (begin source code)

module wishbone_slave #(
parameter WB_ADDR_W = 32,
parameter WB_DATA_W = 32,
parameter WB_TGD_W  = 8 ,
parameter WB_TGC_W  = 4 ,
parameter WB_TGA_W  = 2
)(
input                    RST_I,
input                    CLK_I,
output [WB_DATA_W-1:0]   DAT_O,
input [WB_ADDR_W-1:0]    ADR_I,
input [WB_DATA_W-1:0]    DAT_I,
input [WB_DATA_W/8-1:0]  SEL_I,
input                    WE_I ,
input                    STB_I,
output                   ACK_O,
input                    CYC_I,
input [WB_TGD_W-1:0]     TGD_I,
output                   ERR_O,
input                    LOCK_I,
output                   RTY_O,
input [WB_TGA_W-1:0]     TGA_I,
input [WB_TGC_W-1:0]     TGC_I,
input [2:0]              CTI_I,
input [1:0]              BTE_I
);

assign ERR_O = 1'b0;
assign DAT_O = 'h0;
assign RTY_O = 1'b0;

parameter ACK_IDLE = 1'b0,
          ACK_BUSY = 1'b1;

reg  ack_ns, ack_cs;

always @(posedge CLK_I or negedge RST_I)
  if (~RST_I)
    ack_cs <= ACK_IDLE;
  else 
    ack_cs <= ack_ns;

always @(*)
  case (ack_cs) 
    ACK_IDLE : begin 
                 if (WE_I & STB_I)
                   ack_ns = ACK_BUSY;
                 else
                   ack_ns = ACK_IDLE;
    end 
    ACK_BUSY  : begin 
                  ack_ns = ACK_IDLE;
    end 
    default   : ack_ns = ACK_IDLE;
    endcase

assign ACK_O = ack_cs == ACK_BUSY;

endmodule 
