`ifndef TEST__SVH
`define TEST__SVH

class wishbone_test extends uvm_test;
  `uvm_component_utils(wishbone_test)
  test_env  m_env;
  wb_cfg_t  m_cfg;
  function new (string name = "wb_test", uvm_component parent );
    super.new(name, parent);
  endfunction 
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    m_env = test_env::type_id::create("m_env", this);
    m_cfg = wb_cfg_t::type_id::create("m_cfg");
    m_env.slv_agent.slv_mon.cfg = m_cfg;
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
    wb_slv_simple_seq_t wb_slv_seq = wb_slv_simple_seq_t::type_id::create("wb_slv_seq");

    phase.raise_objection(this);

    fork 
       wb_slv_seq.start(m_env.slv_agent.slv_sqr);
    join_none
         #1ms;


    phase.drop_objection(this);
  endtask 

endclass : wishbone_test

`endif

