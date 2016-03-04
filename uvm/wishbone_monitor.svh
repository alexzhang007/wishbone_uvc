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

`ifndef WISHBONE_MONITOR__SVH
`define WISHBONE_MONITOR__SVH

class wb_slave_monitor #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
)extends uvm_monitor;
  typedef wb_slave_monitor#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) this_t;
  typedef wb_cfg #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_cfg_t;
  typedef wb_slave_rsp_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) txn_t;
  `uvm_component_param_utils(this_t)
  typedef virtual ovi_wishbone #(
    .WB_ADDR_W (WB_ADDR_W),
    .WB_DATA_W (WB_DATA_W),
    .WB_TGD_W  (WB_TGD_W ),
    .WB_TGA_W  (WB_TGA_W ),
    .WB_TGC_W  (WB_TGC_W )
  ) wb_vif_t;
  wb_vif_t  wb_if;
  wb_cfg_t  cfg;  
  txn_t     rsp_txn;
  function new(string name= "wb_slave_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase (uvm_phase phase);
   super.build_phase (phase);
   uvm_config_db #(wb_vif_t)::get(this, "", "WISHBONE_IF", wb_if);
   if (wb_if == null)
     `uvm_error("Wishbone Driver", "Interface for the wb_driver is no set before use")
  endfunction 
  
  task run_phase (uvm_phase phase);
     forever begin 
       @(posedge wb_if.wb_clk);
       if (wb_if.wb_stb_i) begin 
         if (wb_if.wb_we_i == 1'b0) begin  //Write
           cfg.backdoor_write(wb_if.wb_adr_i, wb_if.wb_dat_i);
           rsp_txn = txn_t::type_id::create("rsp_txn");
           rsp_txn.typ = WB_WRITE;
           cfg.fill_rsp(rsp_txn);
         end else begin 
           rsp_txn = txn_t::type_id::create("rsp_txn");
           rsp_txn.typ = WB_READ;
           rsp_txn.data = cfg.backdoor_read(wb_if.wb_adr_i);
           cfg.fill_rsp(rsp_txn);
         end  
       end 
     end 

  endtask 
endclass

`endif

