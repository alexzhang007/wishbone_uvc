`ifndef ENV__SVH
`define ENV__SVH

class test_env extends uvm_env;

  `uvm_component_utils(test_env)
  wb_slv_agent_t slv_agent;
  function new(string name, uvm_component parent );
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase  phase);
    super.build_phase (phase);
    slv_agent = wb_slv_agent_t::type_id::create("slv_agent", this);
  endfunction 

endclass 


`endif
