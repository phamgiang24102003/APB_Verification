class apb_env_cfg extends uvm_object;
  
  `uvm_object_utils (apb_env_cfg)
  
  apb_agent_cfg _agent_cfg;
  
  bit has_scb;
  
  function new (string name = "apb_env_cfg");
    super.new (name);
    _agent_cfg = new ("_agent_cfg");
  endfunction
  
endclass
