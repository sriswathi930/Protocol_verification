class i2c_seqr extends uvm_sequencer#(i2c_seq_item);
  
  `uvm_component_utils(i2c_seqr)
  
  function new(string name = "i2c_seqr", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass


  
