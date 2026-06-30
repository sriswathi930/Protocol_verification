
//sequencer just take the transaction from the sequence and give it to the driver. it just act as a mediater b/w sequence & driver

class i2c_seqr extends uvm_sequencer#(i2c_seq_item);
  
  `uvm_component_utils(i2c_seqr)
  
  function new(string name = "i2c_seqr", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass


  
