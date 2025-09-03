class apb_monitor_cov extends uvm_subscriber#(apb_seq_item);
  
  `uvm_component_utils (apb_monitor_cov)
  
  apb_seq_item _item;
  
  covergroup apb_cov;
    ADDR : coverpoint _item.addr {
      option.auto_bin_max = 128;
      bins slave1_addr = {[0:63]};
      bins slave2_addr = {[256:319]};
      ignore_bins invalid_addr = {[64:255], [320:511]};
    }
    ERROR_ADDR : coverpoint _item.addr {
      option.auto_bin_max = 384;
      bins slave1_addr = {[64:255]};
      bins slave2_addr = {[320:511]};
    }
    DATA : coverpoint _item.data {
      bins lowest_data = {[0:63]};
      bins low_data = {[64:127]};
      bins medium_data = {[128:191]};
      bins high_data = {[192:255]};
    }
    SELECT_RW : coverpoint _item.select {
      bins select_wr = {0};
      bins select_rd = {1};
    }
    ALL : cross ADDR, DATA, SELECT_RW {
    }
  endgroup
  
  function new (string name = "apb_monitor_cov", uvm_component parent = null);
    super.new (name, parent);
    apb_cov = new();
  endfunction
  
  virtual function void write (apb_seq_item t);
    _item = apb_seq_item::type_id::create("_item");
    _item.addr = t.addr;
    _item.data = t.data;
    _item.select = t.select;
    apb_cov.sample();
  endfunction
  
  function void report_phase (uvm_phase phase);
    super.report_phase (phase);
    `uvm_info("COV", $sformatf("Coverage = %0.2f%%", apb_cov.get_inst_coverage()), UVM_LOW)
    `uvm_info("COV", $sformatf("ADDR Coverage = %0.2f%%",apb_cov.ADDR.get_coverage()), UVM_LOW)
    `uvm_info("COV", $sformatf("ERROR ADDR Coverage = %0.2f%%",apb_cov.ERROR_ADDR.get_coverage()), UVM_LOW)
    `uvm_info("COV", $sformatf("DATA Coverage = %0.2f%%",apb_cov.DATA.get_coverage()), UVM_LOW)
    `uvm_info("COV", $sformatf("SELECT R/W Coverage = %0.2f%%",apb_cov.SELECT_RW.get_coverage()), UVM_LOW)
    `uvm_info("COV", $sformatf("ALL Cross Coverage = %0.2f%%",apb_cov.ALL.get_coverage()), UVM_LOW)
  endfunction
  
endclass
