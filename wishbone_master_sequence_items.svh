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

class wb_master_rw_transaction#(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequence_item;
  `uvm_object_param_utils(wb_master_rw_transaction)
  rand bit [WB_ADDR_W-1:0]  addr;
  rand bit [WB_DATA_W-1:0]  data[];
  rand bit [WB_DATA_W/8-1:0] sel[];
  rand bit [WB_TGD_W-1:0]    tgd[];

  rand bit [WB_TGC_W-1:0]    tgc;
  rand bit [WB_TGA_W-1:0]    tga;
  rand bit [2:0]             cti;
  rand bit [1:0]             bte;
  rand bit [WB_ADDR_W-1:0]   addr_bursts[];
  rand bit [2:0]             cti_bursts[];

  rand wb_rw_e               read_or_write;
  rand int                   len_bursts; //if the request is not classic, it will have the parameter

  int                        address_to_ack_latency;
  const address_bursts_gen {
    if (read_or_write == WB_WRITE ) {
       if (cti == WB_CONST_ADDR_CYCLE) {
         cti_bursts.size() == len_bursts;
       }
    }
  }

  function void post_randomize ();
    begin 
      if (read_or_write == WB_WRITE) begin
        if (cti == WB_CONST_ADDR_CYCLE) begin  
          for (int index =0; index < len_bursts-1; index = index +1) begin 
            cti_bursts [index] = WB_CONST_ADDR_CYCLE;
            addr_bursts[index] = addr;
          end 
          cti_bursts[len_bursts-1] = WB_END_OF_BURST;
          addr_bursts[len_bursts-1]= addr;
        end else if (cti == WB_INCR_BURST_CYCLE) begin 
          if (bte == WB_LINEAR_BURST) begin 
            for (int i =0; i< len_bursts-1; i= i+1) begin 
              addr_bursts[i] = addr + i*4;
              cti_bursts[i]  = cti;
            end 
          end else if (bte == WB_4BEAT_WRAPPER_BURST) begin 
            for (int i=0; i< len_bursts-1; i=i+1) begin 
              addr_bursts [i] = addr + i%4;
              cti_bursts[i]  = cti;
            end 
          end else if (bte == WB_8BEAT_WRAPPER_BURST) begin 
            for (int i=0; i< len_bursts-1; i=i+1) begin 
              addr_bursts [i] = addr + i%8;
              cti_bursts[i]  = cti;
            end 
          end else if (bte == WB_8BEAT_WRAPPER_BURST) begin 
            for (int i=0; i< len_bursts-1; i=i+1) begin 
              addr_bursts [i] = addr + i%16;
              cti_bursts[i]  = cti;
            end 
          end 
          cti_bursts[len_bursts-1] = WB_END_OF_BURST;
        end 
      end 
    end 

  endfunction

endclass 
