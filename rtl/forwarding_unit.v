module forwarding_unit(rs1,rs2,rd_mem,rd_wb,reg_we_wb,reg_we_mem,fwd_a,fwd_b);
input [4:0]rs1,rs2,rd_mem,rd_wb;
input reg_we_wb, reg_we_mem;
output [1:0]fwd_a, fwd_b;
assign fwd_a=(reg_we_mem && rd_mem != 5'b0 && rd_mem == rs1) ? 2'b10 :
				 (reg_we_wb&& rd_wb !=5'b0 && rd_wb == rs1 ) ? 2'b01 :2'b00; 			 
assign fwd_b =(reg_we_mem && rd_mem != 5'b0 && rd_mem == rs2) ? 2'b10 :
						(reg_we_wb && rd_wb != 5'b0 && rd_wb == rs2) ? 2'b01 : 2'b00;
endmodule