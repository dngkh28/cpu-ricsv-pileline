package hazard_pkg;
import uvm_pkg::*; // (2) dùng các class của thư viện UVM(gop cac class ben duoi vao);
`include "uvm_macros.svh" // (3) nạp các macro của UVM
`include "hazard_item.sv"
`include "hazard_seq.sv"
`include "hazard_driver.sv"
`include "hazard_monitor.sv"
class hazard_test extends uvm_test;
	`uvm_component_utils(hazard_test)
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	task run_phase(uvm_phase phase);
		`uvm_info("TEST","khung chay duoc",UVM_NONE)
	endtask
endclass
endpackage