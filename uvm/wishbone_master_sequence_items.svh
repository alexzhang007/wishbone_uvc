//*******************************************************************
// Copyright 2016 Opening Vision  (Shanghai) Inc
// All Rights Reserved.
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// OPENING VISION INC OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
//  Language : SystemVerilog 
//  Version  : 2.3
//  Author   : Alex Zhang
//  Date     : 02-27-2016
// (begin source code)
`ifndef WISHBONE_MASTER_SEQUENCE_ITEMS__SVH
`define WISHBONE_MASTER_SEQUENCE_ITEMS__SVH
class wb_master_rw_transaction#(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequence_item;
  rand bit [WB_ADDR_W-1:0]   addr;
  rand bit [WB_DATA_W-1:0]   data[];
  rand bit [WB_DATA_W/8-1:0] sel[];
  rand bit [WB_TGD_W-1:0]    tgd[];

  rand bit [WB_TGC_W-1:0]    tgc;
  rand bit [WB_TGA_W-1:0]    tga;
  rand wb_cti_type_e         cti;
  rand wb_bte_type_e         bte;
  rand bit [WB_ADDR_W-1:0]   addr_bursts[];
  rand wb_cti_type_e         cti_bursts[];

  rand wb_rw_e               read_or_write;
  rand int                   len_bursts; //if the request is not classic, it will have the parameter
  
  rand int                   delay;
  int                        address_to_ack_latency;
  //The uvm_field_int has the sprint work
  `uvm_object_param_utils_begin(wb_master_rw_transaction)
     `uvm_field_int(delay, UVM_DEFAULT)
     `uvm_field_int(len_bursts, UVM_DEFAULT)
     `uvm_field_int(addr, UVM_DEFAULT)
     `uvm_field_sarray_int(addr_bursts, UVM_DEFAULT)
     `uvm_field_enum(wb_rw_e,  read_or_write, UVM_DEFAULT)
     `uvm_field_enum(wb_cti_type_e,  cti, UVM_DEFAULT)
     `uvm_field_sarray_enum(wb_cti_type_e, cti_bursts, UVM_DEFAULT)
     `uvm_field_enum(wb_bte_type_e,  bte, UVM_DEFAULT)
     `uvm_field_sarray_int(data, UVM_DEFAULT)
     `uvm_field_sarray_int(sel, UVM_DEFAULT)
     `uvm_field_sarray_int(tgd, UVM_DEFAULT)
  `uvm_object_utils_end
  constraint address_bursts_gen {
    if (read_or_write == WB_WRITE ) {
         cti_bursts.size() == len_bursts;
         addr_bursts.size()== len_bursts;
         data.size()       == len_bursts;
         sel.size()        == len_bursts;
         tgd.size()        == len_bursts;
    } else if (read_or_write == WB_READ) {
         cti_bursts.size() == len_bursts;
         addr_bursts.size()== len_bursts;
    }
    solve read_or_write before len_bursts;
    solve read_or_write before cti_bursts;
    solve len_bursts before cti_bursts;
    solve len_bursts before addr_bursts;
    solve len_bursts before data;
    solve len_bursts before sel;
    solve len_bursts before tgd;
  }

  function void post_randomize ();
    addr [2:0] = 3'b000; //Make sure the address is 8bit aligned
    begin 
      //if (read_or_write == WB_WRITE) begin
        if (cti == WB_CONST_ADDR_CYCLE) begin  
          for (int index =0; index < len_bursts; index = index +1) begin 
            cti_bursts [index] = WB_CONST_ADDR_CYCLE;
            addr_bursts[index] = addr;
          end 
          cti_bursts[len_bursts-1] = WB_END_OF_BURST;
        end else if (cti == WB_INCR_ADDR_CYCLE) begin 
          if (bte == WB_LINEAR_BURST) begin 
            for (int i =0; i< len_bursts; i= i+1) begin 
              addr_bursts[i] = addr + i*4;
              cti_bursts[i]  = cti;
            end 
          end else if (bte == WB_4BEAT_WRAPPER_BURST) begin 
            for (int i=0; i< len_bursts; i=i+1) begin 
              addr_bursts [i] = addr + (i%4) * 4;
              cti_bursts[i]  = cti;
            end 
          end else if (bte == WB_8BEAT_WRAPPER_BURST) begin 
            for (int i=0; i< len_bursts; i=i+1) begin 
              addr_bursts [i] = addr + (i%8) * 8;
              cti_bursts[i]  = cti;
            end 
          end else if (bte == WB_8BEAT_WRAPPER_BURST) begin 
            for (int i=0; i< len_bursts; i=i+1) begin 
              addr_bursts [i] = addr + (i%16) * 16;
              cti_bursts[i]  = cti;
            end 
          end 
          cti_bursts[len_bursts-1] = WB_END_OF_BURST;
        end  //cti
        for (int i=0; i< len_bursts; i=i+1) begin
          data [i] = $urandom;
          sel  [i] = $urandom;
          tgd  [i] = $urandom;
        end 
      //end 
    end 

  endfunction

endclass 

`endif
