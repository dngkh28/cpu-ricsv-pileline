module if_id_reg(clk, reset, en, flush,
                 pc_in, pc4_in, instr_in,
                 pc_out, pc4_out, instr_out);
input clk,reset,en,flush;
input [31:0]pc_in,pc4_in,instr_in;
output reg [31:0]pc_out,pc4_out,instr_out;

always @(posedge clk or posedge reset)begin
	if(reset || flush)begin
		pc_out <=32'b0;
		pc4_out <=32'b0;
		instr_out <=32'h013;
	end 
	else if (en) begin
		pc_out <=pc_in;
		pc4_out <=pc4_in;
		instr_out <=instr_in;
	end
end


endmodule