class apb_rd_seq extends apb_base_seq;
  
  `uvm_object_utils (apb_rd_seq)
  
  bit rand_addr;
  
  function new (string name = "apb_rd_seq");
    super.new (name);
  endfunction
  
  virtual task body ();
    if (rand_addr)
      `uvm_do_with (_item, {_item.select == rd;})
    else
      `uvm_do_with (_item, {_item.select == rd;
                            _item.addr == local::addr;
                            })
  endtask
  
endclass
