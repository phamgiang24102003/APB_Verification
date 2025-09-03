class apb_seqr extends uvm_sequencer #(apb_seq_item, apb_seq_item);
  
  `uvm_component_utils (apb_seqr)
  
  function new (string name = "apb_seqr", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
  endfunction
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
  endfunction
  
endclass
