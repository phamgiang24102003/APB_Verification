`uvm_analysis_imp_decl(_drv2scb)
`uvm_analysis_imp_decl(_mntr2scb)

class apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils (apb_scoreboard)
  
  apb_seq_item exp_q[$];
  apb_seq_item act_q[$];
  
  uvm_analysis_imp_drv2scb#(apb_seq_item, apb_scoreboard) _drv2scb;
  uvm_analysis_imp_mntr2scb#(apb_seq_item, apb_scoreboard) _mntr2scb;
  
  function new (string name = "apb_scoreboard", uvm_component parent = null);
    super.new (name, parent);
    _drv2scb = new ("_drv2scb", this);
    _mntr2scb = new ("_mntr2scb", this);
  endfunction

  function void write_drv2scb (apb_seq_item item);
    `uvm_info("SCB", $sformatf("Seq_item written from driver: \n"), UVM_HIGH)
    item.print();
  endfunction
  
  function void write_mntr2scb (apb_seq_item item);
    apb_seq_item act;
    
    `uvm_info("SCB", $sformatf("Seq_item written from monitor: \n"), UVM_HIGH)
    item.print();
    
    if (item.select == rd) begin
      if (((item.addr >= 64 && item.addr < 256) || (item.addr >= 320 && item.addr < 512)) && (item.data == 8'h00))
        `uvm_info("ERROR", $sformatf("Read from invalid ADDR = 0x%h returned 0x%h", item.addr, item.data), UVM_LOW)
      
      act = apb_seq_item::type_id::create("act");
      act.copy(item);
      act_q.push_back(act);
    end
  endfunction
  
  function void construct_nd_push_exp_pkt (input reg [8:0] addr, input reg [7:0] data);
    apb_seq_item exp = apb_seq_item::type_id::create("exp");
    exp.addr = addr;
    exp.data = data;
    exp.select = rd;
    exp_q.push_back(exp);
  endfunction
  
  function void compare_pkt (
    input apb_seq_item exp,
    input apb_seq_item act
  );
    if (exp.addr != act.addr)
      `uvm_error("ADDR MISMATCH ERROR", $sformatf("SCB:: Expected ADDR: 0x%h But received ADDR: 0x%h", exp.addr, act.addr))
    else if (exp.data != act.data)
      `uvm_error("DATA MISMATCH ERROR", $sformatf("SCB:: For ADDR: 0x%h Expect DATA: 0x%h but Got: 0x%h", exp.addr, exp.data, act.data))
    else
      `uvm_info("SCB", $sformatf("MATCH: ADDR = 0x%h, DATA = 0x%h, Slave%0d", act.addr[7:0], act.data, (act.addr[8] + 1)), UVM_LOW)
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    apb_seq_item exp, act;
    super.run_phase(phase);
    
    forever begin
      wait (exp_q.size() > 0 && act_q.size() > 0);
      #0;
      exp = exp_q.pop_front();
      act = act_q.pop_front();
      compare_pkt(exp, act);
    end
  endtask
  
endclass
