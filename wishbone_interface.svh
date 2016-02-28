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

interface ovi_wishbone #(
  int WB_ADDR_W   = 32,
  int WB_DATA_W   = 32,
  int WB_TGD_W    = 8 ,
  int WB_TGA_W    = 2 ,
  int WB_TGC_W    = 4
) (
  input wire wb_clk,
  input wire wb_resetn
);
  //Common Signals
  wire wb_clk    ;
  wire wb_resetn ; 
  wire [WB_DATA_W-1:0] wb_dat_i;
  wire [WB_DATA_W-1:0] wb_dat_o;
  wire [WB_TGD_W-1 :0] wb_tgd_i;
  wire [WB_TGD_W-1 :0] wb_tgd_o;

  //Master Signals
  wire                 wb_ack_i;
  wire [WB_ADDR_W-1:0] wb_adr_o;
  wire                 wb_cyc_o;
  wire                 wb_err_i;
  wire                 wb_lock_o;
  wire                 wb_rty_i;
  wire [WB_DATA_W/8-1:0] wb_sel_o;
  wire                   wb_stb_o;
  wire [WB_TGA_W-1:0]    wb_tga_o;
  wire [WB_TGC_W-1:0]    wb_tgc_o;
  wire                   wb_we_o ;
  wire [2:0]             wb_cti_o;
  wire [1:0]             wb_bte_o;

  //Slave Signals
  wire                 wb_ack_o;
  wire [WB_ADDR_W-1:0] wb_adr_i;
  wire                 wb_cyc_i;
  wire                 wb_err_o;
  wire                 wb_lock_i;
  wire                 wb_rty_o;
  wire [WB_DATA_W/8-1:0] wb_sel_i;
  wire                   wb_stb_i;
  wire [WB_TGA_W-1:0]    wb_tga_i;
  wire [WB_TGC_W-1:0]    wb_tgc_i;
  wire                   wb_we_i ;
  wire [2:0]             wb_cti_i;
  wire [1:0]             wb_bte_i;
  


endinterface 
