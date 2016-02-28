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

class wb_dirver #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
)extends uvm_driver#(wb_master_rw_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W));
  `uvm_component_param_utils(wb_driver)
 
 typedef wb_master_rw_transaction#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W)  wb_master_txn_t;
 typedef virtual ovi_wishbone wb_vif_t;
 wb_vif_t  wb_if;
 function new (string name, uvm_component parent);
   super.new(name, parent);
 endfunction 
 
 function build_phase (uvm_phase phase);
   super.build_phase (phase);
   uvm_config_db #(wb_vif_t)::get(this, "", "WB_IF", wb_if);
   if (wb_if == null)
     `uvm_error("Wishbone Driver", "Interface for the wb_driver is no set before use")

 endfunction 
 
 task run_phase (uvm_phase phase);
   forever begin 
     seq_item_port.get_next_item(req);
     send (req);
     seq_item_port.item_done();
   end 
 endtask

 task  send (wb_master_txn_t txn);
   begin 
     if (txn.len_bursts==1) begin 
         @(posedge wb_if.wb_clk);
         wb_if.adr_o <= txn.addr;
         wb_if.dat_o <= txn.data[0]; 
         wb_if.sel_o <= txn.sel[0];
         wb_if.tgd_o <= txn.tgd[0];
         wb_if.cyc_o <= 1'b1   ;
         wb_if.stb_o <= 1'b1   ;
         wb_if.cti_o <= txn.cti;
         wb_if.bte_o <= txn.bte;
         wb_if.we_o  <= txn.read_or_write==WB_WRITE ? 1'b1 : 1'b0 ;
         wb_if.tgc_o <= txn.tgc;
         wb_if.tga_o <= txn.tga;
         wait (wb_if.ack_i==1'b1);
     end else begin 
       for (int i =0; i< len_bursts; i= i+1) begin 
         @(posedge wb_if.wb_clk);
         wb_if.adr_o <= txn.addr_bursts[i];
         wb_if.dat_o <= txn.data[i]; 
         wb_if.sel_o <= txn.sel[i];
         wb_if.tgd_o <= txn.tgd[i];
         wb_if.cyc_o <= 1'b1   ;
         wb_if.stb_o <= 1'b1   ;
         wb_if.cti_o <= txn.cti[i];
         wb_if.bte_o <= txn.bte[i];
         wb_if.we_o  <= txn.read_or_write==WB_WRITE ? 1'b1 : 1'b0 ;
         wb_if.tgc_o <= txn.tgc ;
         wb_if.tga_o <= txn.tga ;
         wait (wb_if.ack_i==1'b1);
       end
     end    
   end 
 endtask 
endclass
