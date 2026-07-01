// collects the data passively and give the data to the scoreboard and subscriber through analysis port
`define MON_VIF mon_vif.monitor
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
    if(!uvm_config_db#(virtual i2c_inf)::get(this,"","vif",mon_vif))begin
      `uvm_fatal("MONITOR","interface not get")
    end
      mon_ap=new("mon_ap",this); //analysis port object creation
    
  endfunction

  task mon_run();
    
    bit [6:0] temp_addr; //to collect the address
    bit [7:0] iaddr_q; //to collect internal address
    bit [7:0] data_q; //data capturing
    bit nack; //to track early exit
    nack=0;
     seq=seq_item::type_id::create("seq");
  //start detection 
  forever begin
    @(negedge `MON_VIF.sda);
    if(`MON_VIF.scl==1)
        break;
  end
  
  //collecting 7bit address
  
    for(int i=6;i>=0;i--)begin
      @(posedge `MON_VIF.scl);
      temp_addr[i]=`MON_VIF.sda;
  end
  seq.slv_addr=temp_addr;
  
  //1 bit R/W
  @(posedge `MON_VIF.scl);
  seq.rd_wr=`MON_VIF.sda;
  
  //1 bit ADDR_ACK
  @(posedge `MON_VIF.scl);
    seq.addr_ack = (`MON_VIF.sda==0);
    if(!seq.addr_ack) begin
      nack = 1;
      `uvm_info("MON","ADDR NACK received - skipping to STOP",UVM_LOW);
    end
  
  //collecting 8bit internal address 
  
    if(!nack) begin
  for(int i=7;i>=0;i--)begin
   @(posedge `MON_VIF.scl);
    iaddr_q[i]=`MON_VIF.sda;
  end
  seq.int_addr=iaddr_q;
  
  //1 bit internal address ACK
  @(posedge `MON_VIF.scl);
  seq.int_ack = (`MON_VIF.sda==0);
      if(!seq.int_ack) begin
      nack =1;
      `uvm_info("MON","INT_ADDR NACK received go to STOP",UVM_LOW)
    end
    end
    
  //capturing data
  
    if(!nack) begin
  for(int i=7;i>=0;i--) begin
    @(posedge `MON_VIF.scl);
    data_q[i] = `MON_VIF.sda;
  end
  //WRITE : 8 data bits [master] + 1 ACK [slave]
  if(seq.rd_wr==0)
    seq.wdata =data_q;
  //read :8 data bits [slave] + 1 ACK [master]
  else
    seq.rdata =data_q;
    //data ack
  @(posedge `MON_VIF.scl);
    seq.data_ack = (`MON_VIF.sda == 0);
    end
  //stop detection
    forever begin
      @(posedge `MON_VIF.sda);
      if(`MON_VIF.scl==1)
        break;
    end
  
  // package everything into packet/transaction object, write to analysis port.
  mon_ap.write(seq);
  endtask
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    mon_run();
    end
  endtask

endclass
