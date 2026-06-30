// collects the data passively and give the data to the scoreboard and subscriber through analysis port
class i2c_monitor extends uvm_monitor;

  `uvm_component_utils(i2c_monitor)

  virtual i2c_inf mon_vif;
  function new(string name = "i2c_monitor" , uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(`uvm_config_db#(virtual i2c_inf)::get(this))
      `uvm_fatal("MONITOR","interface not get")
      
  endfunction

  //start detection 
  forever begin
    @(negedge sda);
      if(scl==1)
        break;
  end
  
  //collecting 7bit address

  
  //1 bit R/W
  //1 bit ACK
  //collecting 8bit internal address 
  //1 bit ACK
  //WRITE : 8 data bits [master] + 1 ACK [slave]
  //read :8 data bits [slave] + 1 ACK [master]
  //stop detection
    forever begin
      @(posedge sda);
      if(scl==1)
        break;
  end
  // package everything into packet/transaction object, write to analysis port.
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass
