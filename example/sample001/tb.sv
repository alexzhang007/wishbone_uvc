module tb;
  import uvm_pkg::*;
  import test_pkg::*;
  import test_param_pkg::*;
 
  reg wb_clk;
  reg wb_resetn;
   
  initial begin 
    wb_clk = 1'b0;
    forever #2ns wb_clk = ~wb_clk;
  end 

  initial begin 
    wb_resetn = 1'b1;
    #100ns;
    wb_resetn = 1'b0;
    #50ns;
    wb_resetn = 1'b1;
  end 
  ovi_wishbone #(
   .WB_ADDR_W(OVI_WB_ADDR_W),
   .WB_DATA_W(OVI_WB_DATA_W),
   .WB_TGD_W (OVI_WB_TGD_W ),
   .WB_TGA_W (OVI_WB_TGA_W ),
   .WB_TGC_W (OVI_WB_TGC_W )
  ) wb_if (
   .wb_clk (wb_clk),
   .wb_resetn (wb_resetn)
  );
   
  wishbone_slave #(
   .WB_ADDR_W(OVI_WB_ADDR_W),
   .WB_DATA_W(OVI_WB_DATA_W),
   .WB_TGD_W (OVI_WB_TGD_W ),
   .WB_TGA_W (OVI_WB_TGA_W ),
   .WB_TGC_W (OVI_WB_TGC_W )
  ) wb_slv_DUT (
    .CLK_I (wb_if.wb_clk),
    .RST_I (wb_if.wb_resetn),
    .DAT_O (wb_if.wb_dat_i),
    .ADR_I (wb_if.wb_adr_o),
    .DAT_I (wb_if.wb_dat_o),
    .SEL_I (wb_if.wb_sel_o),
    .WE_I  (wb_if.wb_we_o ),
    .STB_I (wb_if.wb_stb_o),
    .ACK_O (wb_if.wb_ack_i),
    .CYC_I (wb_if.wb_cyc_o),
    .TGD_I (wb_if.wb_tgd_o),
    .ERR_O (wb_if.wb_err_i),
    .LOCK_I(wb_if.wb_lock_o),
    .RTY_O (wb_if.wb_rty_i),
    .TGA_I (wb_if.wb_tga_o), 
    .TGC_I (wb_if.wb_tgc_o),
    .CTI_I (wb_if.wb_cti_o),
    .BTE_I (wb_if.wb_bte_o)
  ); 

  initial begin 
    $timeformat(-9, 1, "ns", 12);
    uvm_config_db #(wb_vif_t) ::set(null, "uvm_test_top.*", "WISHBONE_IF", wb_if); 
    run_test();
  end 

endmodule 
