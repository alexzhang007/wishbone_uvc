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
`ifndef WISHBONE_SEQUENCER__SVH
`define WISHBONE_SEQUENCER__SVH

class wb_master_sequencer #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequencer#(wb_master_rw_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W));
  typedef wb_master_sequencer #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_master_seqr_t;
  `uvm_component_param_utils(wb_master_seqr_t)
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

endclass 

class wb_slave_sequencer #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequencer#(wb_slave_rsp_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W));
  typedef wb_slave_sequencer #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_slave_seqr_t;
  `uvm_component_param_utils(wb_slave_seqr_t)
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

endclass 
`endif
