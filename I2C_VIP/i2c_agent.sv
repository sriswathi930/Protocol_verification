class i2c_agent extends uvm_agent;
  `uvm_component_utils(i2c_agent)
  
  i2c_seqr seqr;
  i2c_driver drv;
  i2c_monitor mon;
  
  function new(string name="i2c_agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active==UVM_ACTIVE) begin
      seqr=i2c_seqr::type_id::create("seqr",this);
      drv=driver::type_id::create("drv",this);
    end
    mon=monitor::type_id::create("mon",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active==UVM_ACTIVE)
      dri.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass
