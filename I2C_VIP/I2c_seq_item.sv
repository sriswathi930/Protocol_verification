//Sequence_item: 

class seq_item extends uvm_sequence_item;  

  // -----------------------------  
  // I2C Fields (DUT aligned)  
  // -----------------------------  
  rand bit [6:0] slv_addr;    // 7-bit slave address  
  rand bit       rd_wr;       // 0 = write, 1 = read  
  rand bit [7:0] int_addr;    // internal register (0–15)  
  rand bit [7:0] wdata;       // write data to DUT  
  bit [7:0] rdata;       // read data from DUT  
  // -----------------------------  
  // Control Fields  
  // -----------------------------  
  rand bit start;             // start condition  
  rand bit stop;              // stop condition  
  rand bit rpt;               // repeated start enable  
  // -----------------------------  
  // Status / Observed Fields  
  // -----------------------------  
  bit addr_ack;               // address ACK  
  bit int_ack;                // internal addr ACK  
  bit data_ack;               // data ACK (write)  
  // -----------------------------  
  // Constraints  
  // -----------------------------  
  // Match DUT slave address  
  constraint c_slv_addr {  
     slv_addr dist { 
         7'b0000001 := 70,   // valid DUT address 
         [0:127]    := 30    // invalid addresses 
  }; 
} 
// Internal memory range (DUT: data[15:0])  
 constraint c_int_addr {  
    int_addr < 16;  
  }  
 // Start must be valid for first transaction  
  constraint c_start {  
   start == 1;  
  }  
// Stop condition control  
  constraint c_stop_default {  
    stop dist {1 := 70, 0 := 30}; // allow back-to-back  
  }  
// Read/Write distribution  
  constraint c_rw {  
    rd_wr dist {0 := 50, 1 := 50};  
  }  
// -----------------------------  
// UVM Registration  
// -----------------------------  
  `uvm_object_utils_begin(seq_item)  
    `uvm_field_int(slv_addr , UVM_ALL_ON)  
    `uvm_field_int(rd_wr    , UVM_ALL_ON)  
    `uvm_field_int(int_addr , UVM_ALL_ON)  
    `uvm_field_int(wdata    , UVM_ALL_ON)  
    `uvm_field_int(rdata    , UVM_ALL_ON)  
    `uvm_field_int(start    , UVM_ALL_ON)  
    `uvm_field_int(stop     , UVM_ALL_ON)  
    `uvm_field_int(rpt      , UVM_ALL_ON)  
    `uvm_field_int(addr_ack , UVM_ALL_ON)  
    `uvm_field_int(int_ack  , UVM_ALL_ON)  
    `uvm_field_int(data_ack , UVM_ALL_ON)  
  `uvm_object_utils_end  
// -----------------------------  
// Constructor  
// -----------------------------  
 function new(string name = "seq_item");  
   super.new(name);  
 endfunction  
endclass 

 
