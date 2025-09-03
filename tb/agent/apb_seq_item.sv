class apb_seq_item extends uvm_sequence_item;

  rand bit [8:0] addr;
  rand bit [7:0] data;
  rand type_e select;
  
  `uvm_object_utils_begin (apb_seq_item)
    `uvm_field_int (addr, UVM_ALL_ON)
    `uvm_field_int (data, UVM_ALL_ON)
    `uvm_field_enum (type_e, select, UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint addr_constr {
    addr inside {[0:63], [256:319]};
  }
  
  constraint select_constr {
    select inside {wr, rd};
  }
  
  function new (string name = "apb_seq_item");
    super.new(name);
  endfunction
  
endclass
