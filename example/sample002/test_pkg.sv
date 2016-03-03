package test_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import wishbone_pkg::*;
  import test_param_pkg::*;

  typedef wb_slave_agent #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
  ) wb_slv_agent_t;
  typedef wb_slave_simple_sequence #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
   ) wb_slv_simple_eq_t;

  typedef wb_cfg #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
   ) wb_cfg_t;

  `include "env.svh"

  `include "test.svh"

endpackage 
