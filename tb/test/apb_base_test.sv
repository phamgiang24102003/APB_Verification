class apb_base_test extends uvm_test;
  
  `uvm_component_utils (apb_base_test)
  
  apb_env_cfg _env_cfg;
  apb_env _env;
  
  function new (string name = "apb_base_test", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    _env_cfg = apb_env_cfg::type_id::create ("_env_cfg");
    _env = apb_env::type_id::create ("_env", this);
    
    super.build_phase (phase);
    
    if(!uvm_config_db#(virtual apb_if)::get(this,"","apb_if", _env_cfg._agent_cfg._if))
      `uvm_fatal("INTERFACE NOT FOUND ERROR", $sformatf("Could not retrieve apb_if from uvm_config_db"))
      
    _env_cfg.has_scb = 1;
    _env_cfg._agent_cfg.on_coverage = 1;
    _env_cfg._agent_cfg.is_active = UVM_ACTIVE;
    
    uvm_config_db#(apb_env_cfg)::set(null, "", "_env_cfg", _env_cfg);
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase (phase);
  endtask
  
  task rd_data_to_compare (
    input [8:0] addr,
    input [7:0] exp_data
  );
  
    apb_rd_seq _rd_seq;
    _rd_seq = apb_rd_seq::type_id::create ("_rd_seq", this);
    
    _rd_seq.addr = addr;
    _rd_seq.start (_env._agent._seqr);
    
    _env._scoreboard.construct_nd_push_exp_pkt (addr, exp_data);
    
  endtask
  
  task rd_data_from_mem (
    input [8:0] addr,
    input bit rand_addr
  );
    
    apb_rd_seq _rd_seq;
    _rd_seq = apb_rd_seq::type_id::create ("_rd_seq", this);
    
    _rd_seq.addr = addr;
    _rd_seq.rand_addr = rand_addr;
    
    _rd_seq.start (_env._agent._seqr);
    
  endtask
  
  task wr_data_to_mem (
    input [8:0] addr,
    input [7:0] data,
    input bit rand_addr, rand_data
  );
  
    apb_wr_seq _wr_seq;
    _wr_seq = apb_wr_seq::type_id::create ("_wr_seq", this);
    
    _wr_seq.addr = addr;
    _wr_seq.data = data;
    _wr_seq.rand_addr = rand_addr;
    _wr_seq.rand_data = rand_data;
    
    _wr_seq.start (_env._agent._seqr);
    
    _env._scoreboard.construct_nd_push_exp_pkt(addr, _wr_seq.data);
    
  endtask
  
  task reset_dut ();
    _env_cfg._agent_cfg._if.resetn_if();
    @(_env_cfg._agent_cfg._if.cb);
  endtask
  
  task rd_data_err (
    input [8:0] addr,
    input bit rand_addr
  );
  
    apb_err_rd_seq _err_rd_seq;
    _err_rd_seq = apb_err_rd_seq::type_id::create ("_err_rd_seq", this);
    
    _err_rd_seq.addr = addr;
    _err_rd_seq.rand_addr = rand_addr;
    
    _err_rd_seq.start (_env._agent._seqr);
    
  endtask
  
  task wr_data_err (
    input [8:0] addr,
    input [7:0] data,
    input bit rand_addr, rand_data
  );
  
    apb_err_wr_seq _err_wr_seq;
    _err_wr_seq = apb_err_wr_seq::type_id::create ("_err_wr_seq", this);
    
    _err_wr_seq.addr = addr;
    _err_wr_seq.data = data;
    _err_wr_seq.rand_addr = rand_addr;
    _err_wr_seq.rand_data = rand_data;
    
    _err_wr_seq.start (_env._agent._seqr);
    
  endtask

endclass
