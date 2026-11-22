module top;
	import uvm_pkg::*;
	import alu_pkg::*;
	bit  clk=0;
	always  #5 clk =~clk;
	alu_if vif(clk);
	alu dut(.a(vif.a), .b(vif.b), .alu_control(vif.alu_control),
            .result(vif.result), .zero(vif.zero));
	initial begin
	uvm_config_db #(virtual alu_if)::set(null, "*","vif",vif);
	run_test();
	end
endmodule