//*******************************************************************
// Copyright 2016 Opening Vision  (Shanghai) Inc
// All Rights Reserved.
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// OPENING VISION INC OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
//  Language : SystemVerilog 
//  Version  : 2.4
//  Author   : Alex Zhang
//  Date     : 03-03-2016
// (begin source code)

module wishbone_master #(
parameter WB_ADDR_W = 32,
parameter WB_DATA_W = 32,
parameter WB_TGD_W  = 8 ,
parameter WB_TGC_W  = 4 ,
parameter WB_TGA_W  = 2
)(
input                     RST_I,
input                     CLK_I,
input [WB_DATA_W-1:0]     DAT_I,
output [WB_ADDR_W-1:0]    ADR_O,
output [WB_DATA_W-1:0]    DAT_O,
output [WB_DATA_W/8-1:0]  SEL_O,
output                    WE_O ,
output                    STB_O,
input                     ACK_I,
output                    CYC_O,
output [WB_TGD_W-1:0]     TGD_O,
input                     ERR_I,
output                    LOCK_O,
input                     RTY_I,
output [WB_TGA_W-1:0]     TGA_O,
output [WB_TGC_W-1:0]     TGC_O,
output [2:0]              CTI_O,
output [1:0]              BTE_O,
input  [31:0]             reg_ctrl,
input  [WB_ADDR_W-1:0]    reg_addr,
input                     start_req
);
//-----------------------------
//Register Control 
//2:0  - CTI 
//4:3  - BTE
//5    - ReqType
//       0 - Write
//       1 - Read
//15:6  - ReqNum
//23:16 - BurstLen
//        0 - One request per burst
//        1 - Two requests per burst
//-----------------------------
//Register Address
//Master request address

wire [2:0]  cti;
wire [1:0]  bte;
wire        req_type;
wire [9:0]  req_num;
wire [8:0]  burst_len;

assign cti = reg_ctrl[2:0];
assign bte = reg_ctrl[4:3];
assign req_type = reg_ctrl[5];
assign req_num  = reg_ctrl[15:6];
assign burst_len= reg_ctrl[23:16];



parameter CTI_CLASSIC     = 3'b000,
          CTI_CONST_ADDR  = 3'b001,
          CTI_INCR_ADDR   = 3'b010,
          CTI_END_OF_BURST= 3'b111;

parameter BTE_LINEAR_BURST     = 2'b00,
          BTE_4BEAT_WRAP_BURST = 2'b01,
          BTE_8BEAT_WRAP_BURST = 2'b10,
          BTE_16BEAT_WRAP_BURST= 2'b11;

parameter REQ_IDLE = 3'b000,
          REQ_WAIT = 3'b001,
          REQ_SEND = 3'b010,
          REQ_ACK  = 3'b011;

reg [2:0] req_cs, req_ns;
wire      pending;
always @(posedge CLK_I or negedge RST_I)
  if (~RST_I)
    req_cs <= REQ_IDLE;
  else
    req_cs <= req_ns;

always @(*) 
  case (req_cs)
    REQ_IDLE : begin 
                 if (start_req)
                   req_ns = REQ_SEND;
                 else
                   req_ns = REQ_IDLE;
                end 
    REQ_SEND :  begin 
                  if (ACK_I)
                    req_ns = REQ_ACK;
                  else 
                    req_ns = REQ_SEND;  
                end 
    REQ_WAIT  : begin 
                  if (ACK_I )
                    req_ns = REQ_ACK;
                  else 
                    req_ns = REQ_WAIT;
                end 
    REQ_ACK   : begin 
                  if (pending) 
                    req_ns = REQ_SEND;
                  else 
                    req_ns = REQ_IDLE;
    end 
    default   : begin 
                  req_ns  = REQ_IDLE;
                end
  endcase

reg [9:0]           req_count;
reg [WB_ADDR_W-1:0] req_addr_next; 
always @(posedge CLK_I or negedge RST_I)
  if (~RST_I) begin
    req_count <= 0;
    req_addr_next <= reg_addr;
  end else begin
    req_count     <= ( STB_O & ACK_I ) ?req_count + 1'b1 : req_count;
    req_addr_next <= ( STB_O && ACK_I & cti == CTI_CONST_ADDR ) ? req_addr_next  : 
                     ( STB_O && ACK_I & cti == CTI_CLASSIC)     ? req_addr_next + req_count << 2 :
                     ( STB_O && ACK_I & cti == CTI_INCR_ADDR   && bte == BTE_LINEAR_BURST) ? req_addr_next + req_count << 2 :
                     ( STB_O && ACK_I & cti == CTI_INCR_ADDR   && bte == BTE_4BEAT_WRAP_BURST) ? req_addr_next + (req_count %4 ) << 2 :
                     ( STB_O && ACK_I & cti == CTI_INCR_ADDR   && bte == BTE_8BEAT_WRAP_BURST) ? req_addr_next + (req_count %4 ) << 2 :
                     ( STB_O && ACK_I & cti == CTI_INCR_ADDR   && bte == BTE_16BEAT_WRAP_BURST) ? req_addr_next + (req_count %4 ) << 2 : 
                     req_addr_next ;
  end 

assign pending = req_count < req_num;
assign ADR_O   = req_cs ==REQ_SEND ? req_addr_next  : ADR_O;
assign WE_O    = req_type;
assign STB_O   = req_cs ==REQ_SEND ? 1'b1 : 1'b0;
assign CYC_O   = STB_O;
assign DAT_O   = WE_O ? $urandom : {WB_DATA_W{1'b0}};
assign SEL_O   = WE_O ? $urandom : {'h0}; 
assign TGD_O   = WE_O ? $urandom : {'h0};
assign LOCK_O  = 1'b0;
assign TGC_O   = 2;  //Fixed value
assign BTE_O   = bte;
assign CTI_O   = ((cti == CTI_CONST_ADDR)&&(req_count==(req_num-1)))                         ? CTI_END_OF_BURST : 
                 ((cti == CTI_INCR_ADDR )&&(bte==BTE_4BEAT_WRAP_BURST)&&(req_count%4==3))    ? CTI_END_OF_BURST :
                 ((cti == CTI_INCR_ADDR )&&(bte==BTE_8BEAT_WRAP_BURST)&&(req_count%8==7))    ? CTI_END_OF_BURST :
                 ((cti == CTI_INCR_ADDR )&&(bte==BTE_16BEAT_WRAP_BURST)&&(req_count%16==15)) ? CTI_END_OF_BURST :  cti ;

endmodule 

