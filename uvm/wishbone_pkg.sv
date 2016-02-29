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
package wishbone_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
   
  `include "wishbone_types.svh"

  `include "wishbone_master_sequence_items.svh"

  `include "wishbone_simple_sequence.svh"

  `include "wishbone_driver.svh"

  `include "wishbone_sequencer.svh"
  
  `include "wishbone_agent.svh"
  
endpackage
