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

`ifndef WISHBONE_AGENT__SVH
`define WISHBONE_AGENT__SVH

class wb_master_agent #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_agent;

  typedef wb_master_agent #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)      wb_master_agent_t;
  typedef wb_master_driver#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)      wb_master_driver_t;
  typedef wb_master_sequencer#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)   wb_master_seqr_t; 
  `uvm_component_utils(wb_master_agent_t)
  wb_master_driver_t  mst_drv;
  wb_master_seqr_t    mst_sqr;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase (phase);

    mst_drv = wb_master_driver_t::type_id::create("mst_drv", this);
    mst_sqr = wb_master_seqr_t::type_id::create("mst_sqr", this);

  endfunction 

  function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
    mst_drv.seq_item_port.connect(mst_sqr.seq_item_export);
  endfunction 

endclass 


class wb_slave_agent #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_agent;

  typedef wb_slave_agent #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)      wb_slave_agent_t;
  typedef wb_slave_driver#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)      wb_slave_driver_t;
  typedef wb_slave_monitor#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)     wb_slave_monitor_t;
  typedef wb_slave_sequencer#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)   wb_slave_seqr_t; 
  `uvm_component_utils(wb_slave_agent_t)
  wb_slave_driver_t  slv_drv;
  wb_slave_seqr_t    slv_sqr;
  wb_slave_monitor_t slv_mon;
  

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase (phase);

    slv_drv = wb_slave_driver_t::type_id::create("slv_drv", this);
    slv_sqr = wb_slave_seqr_t::type_id::create("slv_sqr", this);
    slv_mon = wb_slave_monitor_t::type_id::create("slv_mon", this);
  endfunction 

  function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
    slv_drv.seq_item_port.connect(slv_sqr.seq_item_export);
  endfunction 

endclass 
`endif
