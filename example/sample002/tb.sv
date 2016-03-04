module tb;
  import uvm_pkg::*;
  import test_pkg::*;
  import test_param_pkg::*;
 
  reg wb_clk;
  reg wb_resetn;
  reg[31:0] reg_ctrl;
  reg[OVI_WB_ADDR_W-1:0] reg_addr;
  reg                    start_req;
   
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
    #100us;
    reg_addr  = 'h200_1000;
    reg_ctrl  = {'h3,10'ha, 1'b0,2'b0, 3'b0};
    #1us;
    start_req = 1'b1;
    #200us;
    start_req = 1'b0;
   
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
   
  wishbone_master #(
   .WB_ADDR_W(OVI_WB_ADDR_W),
   .WB_DATA_W(OVI_WB_DATA_W),
   .WB_TGD_W (OVI_WB_TGD_W ),
   .WB_TGA_W (OVI_WB_TGA_W ),
   .WB_TGC_W (OVI_WB_TGC_W )
  ) wb_mst_DUT (
    .CLK_I (wb_if.wb_clk),
    .RST_I (wb_if.wb_resetn),
    .DAT_I (wb_if.wb_dat_o),
    .ADR_O (wb_if.wb_adr_i),
    .DAT_O (wb_if.wb_dat_i),
    .SEL_O (wb_if.wb_sel_i),
    .WE_O  (wb_if.wb_we_i ),
    .STB_O (wb_if.wb_stb_i),
    .ACK_I (wb_if.wb_ack_o),
    .CYC_O (wb_if.wb_cyc_i),
    .TGD_O (wb_if.wb_tgd_i),
    .ERR_I (wb_if.wb_err_o),
    .LOCK_O(wb_if.wb_lock_i),
    .RTY_I (wb_if.wb_rty_o),
    .TGA_O (wb_if.wb_tga_i), 
    .TGC_O (wb_if.wb_tgc_i),
    .CTI_O (wb_if.wb_cti_i),
    .BTE_O (wb_if.wb_bte_i),
    .reg_ctrl(reg_ctrl    ),
    .reg_addr(reg_addr    ),
    .start_req(start_req  )
  ); 

  initial begin 
    $timeformat(-9, 1, "ns", 12);
    uvm_config_db #(wb_vif_t) ::set(null, "uvm_test_top.*", "WISHBONE_IF", wb_if); 
    run_test();
  end 

endmodule 
