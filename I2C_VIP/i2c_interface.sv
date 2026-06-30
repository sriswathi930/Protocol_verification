interface intf;
  
// logic can't be used here since sda is inout and driven by multiple 
// components (master/slave); only net types (wire/wand) support multiple drivers
  
  wand scl;
  wand sda;

  modport monitor(input scl,sda);
  modport driver(output scl, inout sda);

endinterface

