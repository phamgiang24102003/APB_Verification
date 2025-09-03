class apb_agent extends uvm_agent;
  
  `uvm_component_utils (apb_agent)
  
  apb_agent_cfg _agent_cfg;
  apb_driver _driver;
  apb_monitor _monitor;
  apb_seqr _seqr;
  apb_monitor_cov _monitor_cov;
  
  function new (string name = "apb_agent", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(apb_agent_cfg)::get(this, "", "apb_agent_cfg", _agent_cfg))
      `uvm_fatal("AGENT CONFIG OBJECT NOT FOUND ERROR", $sformatf("ERROR:: Unable to retrieve _agent_cfg from uvm_config_db"))
      
    _monitor = apb_monitor::type_id::create("_monitor", this);
    
    if (_agent_cfg.is_active == UVM_ACTIVE) begin
      _driver = apb_driver::type_id::create("_driver", this);
      _seqr = apb_seqr::type_id::create("_seqr", this);
    end
      
    if (_agent_cfg.on_coverage)
      _monitor_cov = apb_monitor_cov::type_id::create("_monitor_cov", this);        
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
    if (_agent_cfg.is_active == UVM_ACTIVE) begin
      _driver._agent_cfg = _agent_cfg;
      _driver._if = _agent_cfg._if;
      _driver.seq_item_port.connect(_seqr.seq_item_export);
    end
    
    if (_agent_cfg.on_coverage)
      _monitor.mnt2cover.connect(_monitor_cov.analysis_export);
      
    _monitor._if = _agent_cfg._if;
    _monitor._agent_cfg = _agent_cfg;
  endfunction
  
endclass
