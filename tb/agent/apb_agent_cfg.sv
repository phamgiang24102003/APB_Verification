class apb_agent_cfg extends uvm_object;
  
  `uvm_object_utils (apb_agent_cfg)
  
  bit on_coverage;
  uvm_active_passive_enum is_active = UVM_PASSIVE;
  bit err;
  
  virtual apb_if _if;
  
  function new (string name = "apb_agent_cfg");
    super.new (name);
  endfunction
  
endclass
