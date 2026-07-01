class i2c_env extends uvm_environment;
  `uvm_component_utils(i2c_env)
i2c_agent agent;
  
  function new(string name = "i2c_env" , uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent=i2c_agent::type_id::create("agent",this);
  endfunction

endclass
