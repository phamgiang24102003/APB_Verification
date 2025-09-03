module tb_top();
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import apb_test_pkg::*;

  bit PCLK;
  always #10 PCLK = ~PCLK;
  
  apb_if if_inst(PCLK);
  
  apb_protocol dut (
    .PCLK             (PCLK),
    .PRESETn          (if_inst.PRESETn),
    .transfer         (if_inst.transfer),
    .READ_WRITE       (if_inst.READ_WRITE),
    .apb_write_paddr  (if_inst.apb_write_paddr),
    .apb_write_data   (if_inst.apb_write_data),
    .apb_read_paddr   (if_inst.apb_read_paddr),
    .apb_read_data_out(if_inst.apb_read_data_out),
    .PSLVERR          (if_inst.PSLVERR)
  );
  
  initial begin
    PCLK = 0;
    uvm_config_db#(virtual apb_if)::set(null, "*", "apb_if", if_inst);
    run_test("apb_test");
  end
  
endmodule
