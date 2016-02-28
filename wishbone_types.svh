typedef enum bit[2:0] {
  WB_CLASSIC_CYCLE    = 3'b000,
  WB_CONST_ADDR_CYCLE = 3'b001,
  WB_INCR_ADDR_CYCLE  = 3'b010,
  WB_END_OF_BURST     = 3'b111
} wb_cti_type_e;

typedef enum bit[1:0] {
  WB_LINEAR_BURST        = 2'b00,
  WB_4BEAT_WRAPPER_BURST = 2'b01,
  WB_8BEAT_WRAPPER_BURST = 2'b10,
  WB_16BEAT_WRAPPER_BURST= 2'b11
} wb_bte_type_e;

typedef enum bit {
  WB_WRITE = 1'b0,
  WB_READ  = 1'b1
} wb_rw_e;
