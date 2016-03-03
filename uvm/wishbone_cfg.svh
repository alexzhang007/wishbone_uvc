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

`ifndef WISHBONE_CFG__SVH
`define WISHBONE_CFG__SVH
class wb_cfg #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
)extends uvm_object;
 typedef wb_cfg#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) this_t;
 typedef wb_slave_rsp_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) slv_txn_t;
 typedef bit[WB_ADDR_W-1:0] addr_t;
 typedef bit[WB_DATA_W-1:0] data_t;
 bit[WB_DATA_W-1:0]  slv_mem[addr_t];
 slv_txn_t           slv_resp_q[$];

 `uvm_object_param_utils(this_t)
 
 function new(string name = "wb_cfg");
   super.new(name);
 endfunction 

 function void backdoor_write(addr_t addr, data_t data);
   slv_mem[addr] = data;
 endfunction  

 function data_t backdoor_read(addr_t addr);
   if (slv_mem.exists(addr))
     return slv_mem[addr];
   else
     return 0;
 endfunction 
 function bit is_empty();
   return slv_resp_q.size()>0 ? 1'b0 : 1'b1;
 endfunction 

 function slv_txn_t get_rsp();
    return slv_resp_q.pop_front();
 endfunction 

 function void fill_rsp(slv_txn_t txn);
    slv_resp_q.push_back(txn);
 endfunction 
endclass 



`endif
