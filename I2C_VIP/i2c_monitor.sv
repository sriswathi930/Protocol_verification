// collects the data passively and give the data to the scoreboard and subscriber through analysis port
class i2c_monitor extends uvm_monitor;

  `uvm_component_utils(i2c_monitor)

  function new(string name = "i2c_monitor" , uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass
