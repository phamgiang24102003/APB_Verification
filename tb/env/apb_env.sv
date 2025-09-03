class apb_env extends uvm_env;
  
  `uvm_component_utils(apb_env)
  
  apb_agent _agent;
  apb_scoreboard _scoreboard;
  apb_env_cfg _env_cfg;
  
  function new (string name = "apb_env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(apb_env_cfg)::get(this, "", "_env_cfg", _env_cfg))
      `uvm_fatal("ENV_CFG Not Found ERROR", $sformatf("Unable to retrieve _env_cfg from uvm_config_db"))
      
    _agent = apb_agent::type_id::create("_agent", this);
    
    if (_env_cfg.has_scb)
      _scoreboard = apb_scoreboard::type_id::create("_scoreboard", this);
      
    uvm_config_db#(apb_agent_cfg)::set(null, "*", "apb_agent_cfg", _env_cfg._agent_cfg);
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
    if (_env_cfg.has_scb) begin
      _agent._monitor._ap.connect(_scoreboard._mntr2scb);
      _agent._driver.drv2scb.connect(_scoreboard._drv2scb);
    end
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase (phase);
  endtask
  
endclass
