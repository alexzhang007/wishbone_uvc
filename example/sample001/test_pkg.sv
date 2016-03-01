package test_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import wishbone_pkg::*;
  import test_param_pkg::*;

  typedef wb_master_agent #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
  ) wb_mst_agent_t;
  typedef wb_master_simple_sequence #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
  ) wb_mst_simple_seq_t;
  typedef wb_master_const_addr_sequence #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
  ) wb_mst_const_addr_seq_t;
  typedef wb_master_incr_addr_sequence #(
    .WB_ADDR_W (OVI_WB_ADDR_W),
    .WB_DATA_W (OVI_WB_DATA_W),
    .WB_TGD_W  (OVI_WB_TGD_W ),
    .WB_TGA_W  (OVI_WB_TGA_W ),
    .WB_TGC_W  (OVI_WB_TGC_W )
  ) wb_mst_incr_addr_seq_t;
  `include "env.svh"

  `include "test.svh"

endpackage 
