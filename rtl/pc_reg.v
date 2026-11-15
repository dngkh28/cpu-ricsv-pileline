module pc_reg(clk, reset, en, pc_in, pc_out, pc_outnext);
input clk, reset, en;
input  [31:0] pc_in;
output [31:0] pc_out, pc_outnext;
reg [31:0] pc;

always @(posedge clk or posedge reset) begin
	if (reset)   pc <= 32'b0;
	else if (en) pc <= pc_in;
end
assign pc_out     = pc;
assign pc_outnext = pc + 4;
endmodule