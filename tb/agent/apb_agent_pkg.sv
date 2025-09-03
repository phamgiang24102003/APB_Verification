package apb_agent_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	typedef enum {wr = 0, rd = 1} type_e;

	`include "apb_seq_item.sv"
	`include "apb_agent_cfg.sv"
	`include "apb_driver.sv"
	`include "apb_monitor.sv"
	`include "apb_seqr.sv"
	`include "apb_monitor_cov.sv"
	`include "apb_agent.sv"
endpackage
