class apb_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_monitor)
  
  apb_agent_cfg _agent_cfg;
  virtual apb_if _if;
  uvm_analysis_port #(apb_seq_item) _ap;
  uvm_analysis_port #(apb_seq_item) mnt2cover;
  
  function new (string name = "apb_monitor", uvm_component parent = null);
    super.new (name, parent);
    _ap = new ("_ap", this);
    mnt2cover = new ("mnt2cover", this);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", _if))
      `uvm_fatal("MON", "Could not get _if")
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    apb_seq_item _item;
    super.run_phase (phase);
    
    forever begin
      @(_if.cb);
      if (_if.transfer) begin
        @(_if.cb);
        _item = apb_seq_item::type_id::create ("_item");
        if (_if.READ_WRITE == 0) begin
          if (_if.PSLVERR) begin
            if (_agent_cfg.err)
              `uvm_info("DUT_ERROR_TEST","DUT raised PSLVERR as expected for write", UVM_NONE)
            else
              `uvm_error("DUT_OP_ERROR","DUT reported PSLVERR during write")
          end
          else begin
            _item.select = wr;
            _item.addr = _if.apb_write_paddr;
            _item.data = _if.apb_write_data;
            @(_if.cb);
            mnt2cover.write(_item);
          end
        end
        else begin
          if (_if.PSLVERR) begin
            if (_agent_cfg.err)
              `uvm_info("DUT_ERROR_TEST","DUT raised PSLVERR as expected for read", UVM_NONE)
            else
              `uvm_error("DUT_OP_ERROR","DUT reported PSLVERR during read")
          end
          else begin
            _item.select = rd;
            _item.addr = _if.apb_read_paddr;
            _item.data = _if.apb_read_data_out;
            @(_if.cb);
            _ap.write(_item);
            mnt2cover.write(_item);
          end
        end
        @(_if.cb);
        while (_if.transfer) @(_if.cb);
      end
    end
  endtask
  
endclass
