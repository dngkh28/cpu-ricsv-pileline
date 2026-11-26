package forwarding_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "forwarding_item.sv"
	`include "forwarding_seq.sv"
	`include "forwarding_driver.sv"
	`include "forwarding_monitor.sv"
	`include "forwarding_scoreboard.sv"
	class  forwarding_test extends uvm_test;
		`uvm_component_utils(forwarding_test);
		function new(string  name, uvm_component parent);
			super.new(name,parent);
		endfunction
		task run_phase(uvm_phase phase);
			`uvm_info("TEST","khung chay duoc",	UVM_NONE);
		endtask
	endclass
endpackage