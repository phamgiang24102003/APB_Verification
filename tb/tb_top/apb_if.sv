interface apb_if (input PCLK);

	logic PRESETn;
	logic transfer;
	logic READ_WRITE;
	logic [8:0] apb_write_paddr;
	logic [7:0] apb_write_data;
	logic [8:0] apb_read_paddr;
	logic [7:0] apb_read_data_out;
	logic PSLVERR;
	
	clocking cb @(posedge PCLK);
	  default input #1ns output #1ns;
    output transfer;
    output READ_WRITE;
    output apb_write_paddr;
    output apb_write_data;
    output apb_read_paddr;
    input apb_read_data_out;
    input PSLVERR;
  endclocking
  
  modport DUT (
    output PRESETn,
    clocking cb
  );
  
  property apb_read_seq_prop;
    @(posedge PCLK) disable iff (!PRESETn)
    transfer && READ_WRITE && apb_read_paddr != 'bx |=> ##[1:$] !PSLVERR && apb_read_data_out !== 'bx;
  endproperty
  
  property apb_write_seq_prop;
    @(posedge PCLK) disable iff (!PRESETn)
    transfer && (!READ_WRITE) && apb_write_paddr != 'bx |=> ##[1:$] !PSLVERR && apb_write_data !== 'bx;
  endproperty
  
  assert property (apb_read_seq_prop);
  assert property (apb_write_seq_prop);
  
  task resetn_if();
    PRESETn = 0;
    transfer = 0;
    READ_WRITE = 1;
    repeat (2) @(posedge PCLK);
    PRESETn = 1;
    @(posedge PCLK);
  endtask

endinterface
