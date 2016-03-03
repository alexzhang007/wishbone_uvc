package test_param_pkg;

parameter OVI_WB_ADDR_W =  32;
parameter OVI_WB_DATA_W =  32;
parameter OVI_WB_TGD_W  =  8 ;
parameter OVI_WB_TGA_W  =  4 ;
parameter OVI_WB_TGC_W  =  2 ;

typedef virtual ovi_wishbone #(
  .WB_ADDR_W (OVI_WB_ADDR_W),
  .WB_DATA_W (OVI_WB_DATA_W),
  .WB_TGD_W  (OVI_WB_TGD_W ),
  .WB_TGA_W  (OVI_WB_TGA_W ),
  .WB_TGC_W  (OVI_WB_TGC_W )
) wb_vif_t;

endpackage 
