//*******************************************************************
// Copyright 2016 Opening Vision  (Shanghai) Inc
// All Rights Reserved.
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// OPENING VISION INC OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
//  Language : SystemVerilog 
//  Version  : 2.3
//  Author   : Alex Zhang
//  Date     : 03-03-2016
// (begin source code)
`ifndef WISHBONE_SLAVE_SEQUENCE_ITEMS__SVH
`define WISHBONE_SLAVE_SEQUENCE_ITEMS__SVH
class wb_slave_rsp_transaction#(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequence_item;
  typedef wb_slave_rsp_transaction #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) this_t;
  rand bit [WB_DATA_W-1:0] data;
  rand bit [WB_TGD_W-1:0]  tgd ;
  rand bit                 err ;
  rand bit                 rty ;
  rand wb_rw_e             typ ;
  `uvm_object_param_utils_begin (wb_slave_rsp_transaction)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_int(tgd, UVM_DEFAULT)
    `uvm_field_int(err, UVM_DEFAULT)
    `uvm_field_int(rty, UVM_DEFAULT)
    `uvm_field_enum(wb_rw_e, typ, UVM_DEFAULT)
  `uvm_object_utils_end


endclass  : wb_slave_rsp_transaction



`endif
