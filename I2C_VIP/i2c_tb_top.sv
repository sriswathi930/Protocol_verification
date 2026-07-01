//i2c_tb_top.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "design.sv"
//`include "Slave_10b.sv"
`include "i2c_interface.sv"
`include "tb_pkg.sv"

module top;
  
  intf vif();
  Slave_7b#(4) sl1(vif.sda, vif.scl);
  //Slave_10b#(8) sl2(intf.sda, intf.scl);
/*  assign vif.sda=1;
  assign vif.scl=1;*/
  initial begin
    uvm_config_db#(virtual intf)::set(uvm_root::get(),"*","driver",vif);
    uvm_config_db#(virtual intf)::set(uvm_root::get(),"*","mon_vif",vif);
  end
  
  initial run_test("i2c_test");
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
//     #500 $finish;
  end
  /*
  // To check clock streching
  initial begin
    #62 @(negedge vif.scl);
    force vif.scl=0;
    #11 release vif.scl;
    #185 @(negedge vif.scl);
    force vif.scl=0;
    #16 release vif.scl;
  end
  */
endmodule
