module ex_mem_reg(clk, reset,
    alu_result_ex, store_data_ex, pc4_ex, rd_ex,
    mem_we_ex, rw_type_ex, ld_unsigned_ex, reg_we_ex, wb_sel_ex,
    alu_result_mem, store_data_mem, pc4_mem, rd_mem,
    mem_we_mem, rw_type_mem, ld_unsigned_mem, reg_we_mem, wb_sel_mem);
input         clk, reset;
input  [31:0] alu_result_ex, store_data_ex, pc4_ex;
input  [4:0]  rd_ex;
input         mem_we_ex, ld_unsigned_ex, reg_we_ex;
input  [1:0]  rw_type_ex, wb_sel_ex;
output reg [31:0] alu_result_mem, store_data_mem, pc4_mem;
output reg [4:0]  rd_mem;
output reg        mem_we_mem, ld_unsigned_mem, reg_we_mem;
output reg [1:0]  rw_type_mem, wb_sel_mem;
always @(posedge clk or posedge reset)
if(reset)begin
	alu_result_mem <= 32'b0;
	store_data_mem <= 32'b0;
	pc4_mem 			<= 32'b0;
	rd_mem 			<= 5'b0;
	mem_we_mem 		<= 0;
	rw_type_mem 	<= 2'b0;
	ld_unsigned_mem <= 0;
	reg_we_mem 		<= 0;
	wb_sel_mem 		<=2'b0;
end
else begin
	alu_result_mem	 	<= alu_result_ex;
	store_data_mem  	<= store_data_ex;
	pc4_mem 				<= pc4_ex;
	rd_mem 				<= rd_ex;
	mem_we_mem 			<= mem_we_ex;
	rw_type_mem 		<= rw_type_ex;
	ld_unsigned_mem 	<= ld_unsigned_ex ;
	reg_we_mem 			<= reg_we_ex;
	wb_sel_mem 			<= wb_sel_ex;
end
endmodule