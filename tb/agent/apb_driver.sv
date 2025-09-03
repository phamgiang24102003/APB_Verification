class apb_driver extends uvm_driver #(apb_seq_item);
  
  `uvm_component_utils (apb_driver)
  
  apb_agent_cfg _agent_cfg;
  virtual apb_if _if;
  uvm_analysis_port#(apb_seq_item) drv2scb;
  
  function new (string name = "apb_driver", uvm_component parent = null);
    super.new (name, parent);
    drv2scb = new ("drv2scb", this);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
  endfunction
  
  task wr_data (input apb_seq_item _item);
    _if.cb.READ_WRITE <= 0;
    _if.cb.apb_write_paddr <= _item.addr;
    _if.cb.apb_write_data <= _item.data;
    _if.cb.transfer <= 0;
    @(_if.cb);
    _if.cb.transfer <= 1;
    @(_if.cb);
    @(_if.cb);
    _if.cb.transfer <= 0;
    @(_if.cb);
  endtask
  
  task rd_data (input apb_seq_item _item);
    _if.cb.READ_WRITE <= 1;
    _if.cb.apb_read_paddr <= _item.addr;
    _if.cb.transfer <= 0;
    @(_if.cb);
    _if.cb.transfer <= 1;
    @(_if.cb);
    @(_if.cb);
    _if.cb.transfer <= 0;
    @(_if.cb);
  endtask

  virtual task run_phase (uvm_phase phase);
    apb_seq_item _item;
    _if.resetn_if();
      
    forever begin
      @(_if.cb);
      seq_item_port.get_next_item (_item);
      if (_item.select == wr) begin
        wr_data(_item);
        drv2scb.write(_item);
      end
      else if (_item.select == rd) begin
        rd_data(_item);
      end
      seq_item_port.item_done();
    end
  endtask
  
endclass
