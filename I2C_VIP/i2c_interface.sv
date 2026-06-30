interface intf;
//
  wand scl;
  wand sda;

  modport monitor(input scl,sda);
  modport driver(output scl, inout sda);

endinterface

