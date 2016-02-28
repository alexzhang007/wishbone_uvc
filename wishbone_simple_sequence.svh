class wb_master_simple_sequence #(
  int WB_ADDR_W = 32,
  int WB_DATA_W = 32,
  int WB_TGD_W  = 8,
  int WB_TGA_W  = 4,
  int WB_TGC_W  = 2
) extends uvm_sequence #(wb_master_rw_txn_t);
  typedef wb_master_simple_sequence#(WB_ADDR_W, WB_DATA_W, WB_TGD_W, WB_TGA_W, WB_TGC_W) wb_master_simple_seq_t;
  `uvm_object_param_utils(wb_master_simple_seq_t)
  function new (string name = "wb_master_simple_sequence");
    super.new(name);
  endfunction 

  virtual task body();


  endtask
endclass
