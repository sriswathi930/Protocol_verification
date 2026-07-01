class i2c_test extends uvm_test;
  `uvm_component(i2c_test)
i2c_env env;
  
  function new(string name = "i2c_test" , uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=i2c_env::type_id::create("env",this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    seq_item seq;
    seq=seq_item::type_id::create("seq");
    
    phase.raise_objection(this);
    seq.start(env.agent.seqr);
    phase.drop_objection(this);
    #100;

  endtask
endclass
    
    
  
