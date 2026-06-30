
class i2c_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
  
  function new(string name="Driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual intface vif;

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual intface)::get(this,"","driver",vif))
      `uvm_fatal("No_Vif","Virtual interface not found");
  endfunction
