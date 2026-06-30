// collects the data passively and give the data to the scoreboard and subscriber through analysis port
`define MON_VIF mon_vif.driver
class i2c_monitor extends uvm_monitor;

  `uvm_component_utils(i2c_monitor)
  uvm_analysis_port#(seq_item) mon_ap;
  seq_item seq;
  
  virtual i2c_inf mon_vif;
  function new(string name = "i2c_monitor" , uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(`uvm_config_db#(virtual i2c_inf)::get(this,"","vif",mon_vif)))
      `uvm_error("MONITOR","interface not get",UVM_HIGH)
      mon_ap=new("mon_ap",this); //analysis port object creation
    seq=seq_item::type_id::create("seq");
  endfunction

  //start detection 
  forever begin
    @(negedge sda);
    if(`MON_VIF.scl==1)
        break;
  end
  
  //collecting 7bit address
  reg [6:0] temp_addr;
    for(int i=6;i>=0;i--)begin
      @(posedge `MON_VIF.scl);
      temp_addr[i]=`MON_VIF.sda;
  end
  seq.slv_addr=temp_addr;
  
  //1 bit R/W
  @(posedge `MON_VIF.scl);
  seq.rd_wr=`MON_VIF.sda;
  
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
