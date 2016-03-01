`ifndef TEST__SVH
`define TEST__SVH

class wishbone_test extends uvm_test;
  `uvm_component_utils(wishbone_test)
  test_env  m_env;
  function new (string name = "wb_test", uvm_component parent );
    super.new(name, parent);
  endfunction 
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    m_env = test_env::type_id::create("m_env", this);
      
  endfunction 
  task reset_phase (uvm_phase phase);
    phase.raise_objection(this);
    super.reset_phase(phase);

    `uvm_info("Wishbone_test", "Wait the negedge of the RST_I", UVM_LOW)
    @ (negedge $root.tb.wb_slv_DUT.RST_I);
    @ (posedge $root.tb.wb_slv_DUT.RST_I);
    #10ns;
    phase.drop_objection(this);

  endtask 
  task main_phase (uvm_phase phase);
    wb_mst_simple_seq_t wb_seq = wb_mst_simple_seq_t::type_id::create("wb_seq");

    phase.raise_objection(this);
    wb_seq.start_addr = 32'h100_0000;
    wb_seq.end_addr   = 32'h100_FFFF;
    wb_seq.req_num    = 10;
    wb_seq.max_delay  = 10;
    wb_seq.min_delay  = 1;

    fork 
       begin 
         wb_seq.start(m_env.mst_agent.mst_sqr);
       end 
       begin 
         #1ms;
       end 
    join 


    phase.drop_objection(this);
  endtask 

endclass : wishbone_test

class wishbone_const_addr_test extends wishbone_test;
  `uvm_component_utils(wishbone_const_addr_test)
  function new (string name = "wb_test", uvm_component parent );
    super.new(name, parent);
  endfunction 
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    wb_mst_simple_seq_t::type_id::set_type_override(wb_mst_const_addr_seq_t::get_type());
  endfunction

endclass 


class wishbone_incr_addr_test extends wishbone_test;
  `uvm_component_utils(wishbone_incr_addr_test)
  function new (string name = "wb_test", uvm_component parent );
    super.new(name, parent);
  endfunction 
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    wb_mst_simple_seq_t::type_id::set_type_override(wb_mst_incr_addr_seq_t::get_type());
  endfunction

endclass 
`endif
