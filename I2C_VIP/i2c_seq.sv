// random sequence generation for 16times because data depth is 16.

class i2c_seq extends uvm_sequence#(i2c_seq_item);
  `uvm_object_utils(i2c_seq)

  function new(string name ="i2c_master");
    super.new(name);
  endfunction

  task body();
    i2c_seq_item seq;
    repeat(16) begin
      seq=i2c_seq
      _item::type_id::create("seq");
      start_item(seq);
      assert(seq.randomize());
      finish_item(seq);
    end
  endtask
    
endclass
