class apb_base_seq extends uvm_sequence #(apb_seq_item, apb_seq_item);
  
  `uvm_object_utils (apb_base_seq)
  
	bit [8:0] addr;
	bit [7:0] data;
	
	apb_seq_item _item;
  
  function new (string name = "apb_base_seq");
    super.new (name);
  endfunction
  
  virtual task body ();
  
  endtask
  
endclass
