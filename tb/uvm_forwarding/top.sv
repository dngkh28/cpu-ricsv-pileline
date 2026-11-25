module top;
	import uvm_pkg::*;
	import forwarding_pkg::*;
	bit clk=0;
	always #5 clk =~clk;
	
	forwarding_if vif(clk);
	forwarding_unit dut(.rs1(vif.rs1),.rs2(vif.rs2),.rd_mem(vif.rd_mem),
							  .rd_wb(vif.rd_wb),.reg_we_wb(vif.reg_we_wb),
							  .reg_we_mem(vif.reg_we_mem),.fwd_a(vif.fwd_a),.fwd_b(vif.fwd_b));
	initial begin
		uvm_config_db#(virtual forwarding_if)::set(null,"*","vif",vif);
		run_test();
	end
endmodule