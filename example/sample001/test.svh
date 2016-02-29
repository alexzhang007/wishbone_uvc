`ifndef TEST__SVH
`define TEST__SVH

class wishbone_test extends uvm_test;
  `uvm_component_utils(wishbone_test)
  test_env  m_env;
  //wb_vif_t  wb_if;
  wb_mst_simple_seq_t wb_seq;
  function new (string name = "wb_test", uvm_component parent );
    super.new(name, parent);
  endfunction 
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    m_env = test_env::type_id::create("m_env", this);
    wb_seq = wb_mst_simple_seq_t::type_id::create("wb_seq");
    //uvm_config_db #(wb_vif_t)::get(this, "", "WISHBONE_IF", wb_if);
    //if (wb_if == null)
    //  `uvm_error("Wishbone_test", "Interface for the wb_driver is no set before use")
    //else 
      
  endfunction 
  task run_phase (uvm_phase phase);
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

endclass 

`endif
