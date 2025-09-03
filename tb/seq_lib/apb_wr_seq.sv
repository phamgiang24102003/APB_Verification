class apb_wr_seq extends apb_base_seq;
  
  `uvm_object_utils (apb_wr_seq)
  
  bit rand_addr;
  bit rand_data;
  
  function new (string name = "apb_wr_seq");
    super.new (name);
  endfunction
  
  virtual task body ();
    if (rand_data) begin
      if (rand_addr)
        `uvm_do_with (_item, {_item.select == wr;})
      else
        `uvm_do_with (_item, {_item.select == wr;
                              _item.addr == local::addr;
                              })
    end
    else begin
      if (rand_addr)
        `uvm_do_with (_item, {_item.select == wr;
                              _item.data == local::data;
                              })
      else
        `uvm_do_with (_item, {_item.select == wr;
                              _item.data == local::data;
                              _item.addr == local::addr;
                              })
    end
  endtask
endclass
