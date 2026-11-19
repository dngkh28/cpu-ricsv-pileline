module mem_wb_reg(clk,reset, alu_result_mem, pc4_mem, r_data_mem,rd_mem,reg_we_mem,wb_sel_mem
								, alu_result_wb, pc4_wb, r_data_wb,rd_wb,reg_we_wb,wb_sel_wb);

input         clk, reset;
input  [31:0] r_data_mem, alu_result_mem, pc4_mem;
input  [4:0]  rd_mem;
input         reg_we_mem;
input  [1:0]  wb_sel_mem;
output reg [31:0] r_data_wb, alu_result_wb, pc4_wb;
output reg [4:0]  rd_wb;
output reg        reg_we_wb;
output reg [1:0]  wb_sel_wb;

always @(posedge clk or posedge reset)begin
	if(reset)begin
		alu_result_wb <= 32'b0;
		pc4_wb        <= 32'b0;
		r_data_wb     <= 32'b0;
		rd_wb         <= 5'b0;
		reg_we_wb     <= 1'b0;
		wb_sel_wb     <= 2'b0;
	end
	else begin
		alu_result_wb 	<= alu_result_mem;
		pc4_wb			<=	pc4_mem;
		r_data_wb		<=	r_data_mem;
		rd_wb				<=	rd_mem;
		reg_we_wb		<=	reg_we_mem;
		wb_sel_wb		<=	wb_sel_mem;
	end
end
endmodule
