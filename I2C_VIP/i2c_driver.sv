`define drv_vif intf.driver
class i2c_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(i2c_driver)
  
  function new(string name="i2c_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual intf vif;

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual intf)::get(this,"","driver",vif))
      `uvm_fatal("No_Vif","Virtual interface not found");
  endfunction

 task reset_phase(uvm_phase phase);
    `drv_vif.sda = 1; 
    `drv_vif.d.scl = 1;
  endtask

byte byte_1;

virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_full_name(), "Driver started", UVM_MEDIUM)
      
      // START condition - when SDA goes HIGH → LOW while SCL is HIGH
      @(posedge `drv_vif.scl);
      `drv_vif.sda = 1;
      #1 `drv_vif.sda = 0;

      // Address phase (7-bit + R/W)
      byte_1 = {req.slv_addr[6:0], req.rd_wr};
      drive_byte(byte_1);

      // Address ACK
      get_ack(req.addr_ack);
      if (req.addr_ack != 0) begin
        generate_stop();
        seq_item_port.item_done();
        continue;
        //Continue is used to skip the remaining part of the current transaction when an error such as NACK occurs. It ensures the driver stops the ongoing transfer and immediately moves to the next sequence item, preventing invalid protocol behavior.
      end

      // Internal address phase
      drive_byte(req.int_addr);

      // Internal address ACK
      get_ack(req.int_ack);
      if (req.int_ack != 0) begin
        generate_stop();
        seq_item_port.item_done();
        continue;
      end

      // WRITE operation
      if (!req.rd_wr) begin
        drive_byte(req.wdata);
        get_ack(req.data_ack);
      end

      // READ operation (FIXED)
      else begin
        read_byte(req.rdata);
        // Master sends ACK/NACK
        put_ack();
      end

      // STOP or REPEATED START
      if (!req.rpt)
        generate_stop();
      else
        generate_restart();

      seq_item_port.item_done();
    end
  endtask


  // Drive 1 byte (MSB first, protocol correct)
  task drive_byte(logic [7:0] dr);
    for (int i = 0; i < 8; i++) begin
      @(negedge vif.d.scl); 
      vif.d.sda = dr[7];
      @(posedge vif.d.scl); // hold during HIGH
          dr = dr << 1;
    end

    // Release SDA for ACK
    @(negedge vif.d.scl);
    vif.d.sda = 1'bz;
  endtask


  // ✅ Read 1 byte from slave (NEW ✅)
  task read_byte(output logic [7:0] data);
    data = 0;

    @(negedge vif.d.scl);
    vif.d.sda = 1'bz; // release line for slave

    for (int i = 0; i < 8; i++) begin
      @(posedge vif.d.scl);
      data = {data[6:0], vif.d.sda}; // sample
    end
  endtask


  // Get ACK from slave
  task get_ack(output logic ack);
    @(negedge `drv_vif.scl); 
    `drv_vif.sda = 1'bz;

    @(posedge vif.d.scl); 
    ack = vif.d.sda;
  endtask


  // ✅ Master sends ACK/NACK
  task put_ack();
    @(negedge vif.d.scl); 
    vif.d.sda = req.m_ack; // 0 = ACK, 1 = NACK

    @(posedge vif.d.scl);
    
    @(negedge vif.d.scl);
    vif.d.sda = 1'bz; // release again
  endtask


  // ✅ STOP condition
  task generate_stop();
    @(negedge vif.d.scl); vif.d.sda = 0;
    @(posedge vif.d.scl); #1 vif.d.sda = 1;
  endtask


  // ✅ REPEATED START condition (FIXED ✅)
  task generate_restart();
    @(posedge vif.d.scl);
    vif.d.sda = 1;
    #1 vif.d.sda = 0;
  endtask

endclass

