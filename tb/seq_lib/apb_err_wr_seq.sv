class apb_err_wr_seq extends apb_base_seq;
  
  `uvm_object_utils (apb_err_wr_seq)
  
  bit rand_addr;
  bit rand_data;
  
  function new (string name = "apb_err_wr_seq");
    super.new (name);
  endfunction
  
  virtual task body();
    _item = apb_seq_item::type_id::create("_item");
    
    start_item(_item);
    if (rand_data) begin
      if (rand_addr) begin
        _item.addr_constr.constraint_mode(0);
        assert (_item.randomize() with {_item.select == wr;
                                        _item.addr inside {[64:255], [320:511]};
                                        });
      end
      else begin
        _item.addr_constr.constraint_mode(0);
        assert (_item.randomize() with {_item.select == wr;
                                        _item.addr == local::addr;
                                        });
      end
    end
    else begin
      if (rand_addr) begin
        _item.addr_constr.constraint_mode(0);
        assert (_item.randomize() with {_item.select == wr;
                                        _item.addr inside {[64:255], [320:511]};
                                        _item.data == local::data;
                                        });
      end
      else begin
        _item.addr_constr.constraint_mode(0);
        assert (_item.randomize() with {_item.select == wr;
                                        _item.addr == local::addr;
                                        _item.data == local::data;
                                        });
      end
    end
    
    finish_item(_item);
  endtask

endclass
