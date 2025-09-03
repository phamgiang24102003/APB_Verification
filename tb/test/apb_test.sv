class apb_test extends apb_base_test;
  
  `uvm_component_utils (apb_test)
  
  function new (string name = "apb_test", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase (phase);
    phase.raise_objection(this);

    //Check Read/Write with direction data = [0:31]
    //Slave 1
    for (int i = 0; i < 32; i++) begin
      wr_data_to_mem (i, i + 8'h00, 0, 0);
      rd_data_from_mem (i, 0);
    end
    //Check Read/Write with direction data = [192:255]
    //Slave 2
    for (int i = 256; i < 288; i++) begin
      wr_data_to_mem (i, i + 8'hC0 - 256, 0, 0);
      rd_data_from_mem (i, 0);
    end
    //Check Read/Write with random data = [128:191]
    //Slave 2
    for (int i = 288; i < 320; i++) begin
      wr_data_to_mem(i, $urandom_range(128, 191), 0, 0);
      rd_data_from_mem(i, 0);
    end
    //Check Read/Write with random data = [32:127]
    //Slave 1
    for (int i = 32; i < 64; i++) begin
      wr_data_to_mem(i, $urandom_range(64, 127), 0, 0);
      rd_data_from_mem(i, 0);
    end
    //Check Read/Write with random data for slave error
    _env_cfg._agent_cfg.err = 1;
    for (int i = 64; i < 256; i++) begin
      wr_data_err(i, 0, 0, 1);
      rd_data_err(i, 0);
    end
    for (int i = 320; i < 512; i++) begin
      wr_data_err(i, 0, 0, 1);
      rd_data_err(i, 0);
    end
    
    phase.drop_objection(this);
    
  endtask
  
endclass
