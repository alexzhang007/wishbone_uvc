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
  input  wb_clk,
  input  wb_resetn
);
  //Common Signals
  logic [WB_DATA_W-1:0] wb_dat_i;
  logic [WB_DATA_W-1:0] wb_dat_o;
  logic [WB_TGD_W-1 :0] wb_tgd_i;
  logic [WB_TGD_W-1 :0] wb_tgd_o;

  //Master Signals
  logic                 wb_ack_i;
  logic [WB_ADDR_W-1:0] wb_adr_o;
  logic                 wb_cyc_o;
  logic                 wb_err_i;
  logic                 wb_lock_o;
  logic                 wb_rty_i;
  logic [WB_DATA_W/8-1:0] wb_sel_o;
  logic                   wb_stb_o;
  logic [WB_TGA_W-1:0]    wb_tga_o;
  logic [WB_TGC_W-1:0]    wb_tgc_o;
  logic                   wb_we_o ;
  logic [2:0]             wb_cti_o;
  logic [1:0]             wb_bte_o;

  //Slave Signals
  logic                 wb_ack_o;
  logic [WB_ADDR_W-1:0] wb_adr_i;
  logic                 wb_cyc_i;
  logic                 wb_err_o;
  logic                 wb_lock_i;
  logic                 wb_rty_o;
  logic [WB_DATA_W/8-1:0] wb_sel_i;
  logic                   wb_stb_i;
  logic [WB_TGA_W-1:0]    wb_tga_i;
  logic [WB_TGC_W-1:0]    wb_tgc_i;
  logic                   wb_we_i ;
  logic [2:0]             wb_cti_i;
  logic [1:0]             wb_bte_i;
  


endinterface 
