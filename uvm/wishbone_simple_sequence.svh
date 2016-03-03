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
`ifndef WISHBONE_SIMPLE_SEQUENCE__SVH
`define WISHBONE_SIMPLE_SEQUENCE__SVH

class wb_master_simple_sequence #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequence #(wb_master_rw_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W));
  typedef wb_master_simple_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_master_simple_seq_t;
  typedef wb_master_rw_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)  wb_master_rw_txn_t;
  `uvm_object_param_utils(wb_master_simple_seq_t)
  //Group    : Variables
  //Variable : start_addr
  //Specifies the start address for the master Read/Write transaction
  //Default  : 0 
  bit [WB_ADDR_W-1:0] start_addr = 0;
  //Group    : Variables
  //Variable : start_addr
  //Specifies the start address for the master Read/Write transaction
  //Default  : 0 
  bit [WB_ADDR_W-1:0] end_addr = 0;

  int max_delay = 0; //Request delay cycles
  int min_delay = 0; //Request delay cycles
  int req_num   = 0; //Not including the wrapped number
  function new (string name = "wb_master_simple_sequence");
    super.new(name);
  endfunction 

  virtual task body();
    wb_master_rw_txn_t wr_txn = wb_master_rw_txn_t::type_id::create("wr_txn");
    for (int i=0; i< req_num ; i= i+1) begin 
       start_item(wr_txn);
       if (!wr_txn.randomize() with { 
                                      wr_txn.read_or_write == WB_WRITE             ;
                                      wr_txn.len_bursts    == 1                    ;
                                      wr_txn.addr inside {[start_addr : end_addr]} ;
                                      wr_txn.cti           == WB_CLASSIC_CYCLE     ;
                                      wr_txn.bte           == WB_LINEAR_BURST      ;
                                      wr_txn.delay inside {[min_delay : max_delay]};
                                     })
         `uvm_error ("MasterWishbone/wb_master_simple_sequence", $sformatf("Write txn randomization failed times= %0d", i))
       else 
         `uvm_info ("MasterWishbone/wb_master_simple_sequence", $sformatf("\n%0s", wr_txn.sprint()), UVM_LOW)
       finish_item(wr_txn);
    end 

  endtask
endclass : wb_master_simple_sequence


//Date   : 03-01-2016
//Author : Alex Zhang
//Comment: Constant address mode sequence
class wb_master_const_addr_sequence #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends wb_master_simple_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W);

  typedef wb_master_const_addr_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)  this_t;
  `uvm_object_param_utils(this_t)

  function new(string name = "wb_master_const_addr_sequence");
    super.new(name);
  endfunction

  task body ();
    wb_master_rw_txn_t wr_txn = wb_master_rw_txn_t::type_id::create("wr_txn");
    for (int i=0; i< req_num ; i= i+1) begin 
       start_item(wr_txn);
       if (!wr_txn.randomize() with { 
                                      wr_txn.read_or_write == WB_WRITE             ;
                                      wr_txn.len_bursts    == 5                    ;
                                      wr_txn.addr inside {[start_addr : end_addr]} ;
                                      wr_txn.cti           == WB_CONST_ADDR_CYCLE  ;
                                      wr_txn.bte           == WB_LINEAR_BURST      ;
                                      wr_txn.delay inside {[min_delay : max_delay]};
                                     })
         `uvm_error ("MasterWishbone/wb_master_simple_sequence", $sformatf("Write txn randomization failed times= %0d", i))
       else 
         `uvm_info ("MasterWishbone/wb_master_simple_sequence", $sformatf("\n%0s", wr_txn.sprint()), UVM_LOW)
       finish_item(wr_txn);
    end 

  endtask 

endclass : wb_master_const_addr_sequence

//Date   : 03-01-2016
//Author : Alex Zhang
//Comment: Incr address mode sequence
class wb_master_incr_addr_sequence #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends wb_master_simple_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W);

  typedef wb_master_incr_addr_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)  this_t;
  `uvm_object_param_utils(this_t)

  function new(string name = "wb_master_incr_addr_sequence");
    super.new(name);
  endfunction

  task body ();
    wb_master_rw_txn_t wr_txn = wb_master_rw_txn_t::type_id::create("wr_txn");
    for (int i=0; i< req_num ; i= i+1) begin 
       start_item(wr_txn);
       if (!wr_txn.randomize() with { 
                                      wr_txn.read_or_write == WB_WRITE               ;
                                      wr_txn.len_bursts    == 6                      ;
                                      wr_txn.addr inside {[start_addr : end_addr]}   ;
                                      wr_txn.cti           == WB_INCR_ADDR_CYCLE     ;
                                      wr_txn.bte           == WB_4BEAT_WRAPPER_BURST ;
                                      wr_txn.delay inside {[min_delay : max_delay]}  ;
                                     })
         `uvm_error ("MasterWishbone/wb_master_simple_sequence", $sformatf("Write txn randomization failed times= %0d", i))
       else 
         `uvm_info ("MasterWishbone/wb_master_simple_sequence", $sformatf("\n%0s", wr_txn.sprint()), UVM_LOW)
       finish_item(wr_txn);
    end 

  endtask 

endclass : wb_master_incr_addr_sequence

//Date   : 03-02-2016
//Author : Alex Zhang
//Comment: Linear read address mode read sequence
class wb_master_linear_read_sequence #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends wb_master_simple_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W);
  typedef wb_master_linear_read_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_master_linear_read_seq_t;
  typedef wb_master_rw_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)  wb_master_rw_txn_t;
  `uvm_object_param_utils(wb_master_linear_read_seq_t)
  //Group    : Variables
  //Variable : start_addr
  //Specifies the start address for the master Read/Write transaction
  //Default  : 0 
  bit [WB_ADDR_W-1:0] start_addr = 0;
  //Group    : Variables
  //Variable : start_addr
  //Specifies the start address for the master Read/Write transaction
  //Default  : 0 
  bit [WB_ADDR_W-1:0] end_addr = 0;

  int max_delay = 0; //Request delay cycles
  int min_delay = 0; //Request delay cycles
  int req_num   = 0; //Not including the wrapped number
  function new (string name = "wb_master_linear_read_sequence");
    super.new(name);
  endfunction 

  virtual task body();
    wb_master_rw_txn_t wr_txn = wb_master_rw_txn_t::type_id::create("wr_txn");
    
    for (int i=0; i< req_num ; i= i+1) begin 
       start_item(wr_txn);
       if (!wr_txn.randomize() with { 
                                      wr_txn.read_or_write == WB_READ              ;
                                      wr_txn.len_bursts    == 1                    ;
                                      wr_txn.addr inside {[start_addr : end_addr]} ;
                                      wr_txn.cti           == WB_CLASSIC_CYCLE     ;
                                      wr_txn.bte           == WB_LINEAR_BURST      ;
                                      wr_txn.delay inside {[min_delay : max_delay]};
                                     })
         `uvm_error ("MasterWishbone/wb_master_simple_sequence", $sformatf("Write txn randomization failed times= %0d", i))
       else 
         `uvm_info ("MasterWishbone/wb_master_simple_sequence", $sformatf("\n%0s", wr_txn.sprint()), UVM_LOW)
       finish_item(wr_txn);
    end 

  endtask
endclass : wb_master_linear_read_sequence

class wb_slave_simple_sequence #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequence #(wb_slave_rsp_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W));

  typedef wb_slave_simple_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) this_t;
  typedef wb_slave_rsp_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) txn_t;
  typedef wb_cfg #(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_cfg_t;
  `uvm_object_param_utils(this_t)
 
  wb_cfg_t cfg;  
  txn_t    slv_txn;

  function new(string name="wb_slave_simple_sequence");
    super.new(name);
  endfunction 

  task body();
    if (cfg==null)
       `uvm_error("wb_slave_simple_sequence", "CFG is not set")
    forever begin  //FIX, it might stay here
      if ( !cfg.is_empty() ) begin 
        slv_txn = cfg.get_rsp();
        start_item(slv_txn);
        finish_item(slv_txn);
      end 
    end 

  endtask

endclass
`endif
