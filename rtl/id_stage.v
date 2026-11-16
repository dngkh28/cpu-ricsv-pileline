module id_stage(clk,rst,instr,wb_result,rd_wb,reg_we,wb_sel,reg_we_wb,
brUn,a_sel,b_sel,alu_control,mem_we,ld_unsigned,rw_type,
rs1,rs2,rd,rs1_data,rs2_data,is_branch,is_jal,is_jalr,imm_out);
input clk;
input rst;
input [31:0]instr;
//fetch

output is_branch, is_jal, is_jalr,a_sel, b_sel;
output brUn;
//de
output [31:0]imm_out;
output [4:0]rs1,rs2,rd;
output [31:0]rs1_data,rs2_data;
output reg_we;
//ex
output [3:0]alu_control;
//mem
output [1:0]rw_type;
output mem_we;
output ld_unsigned;
//wb
output [1:0]wb_sel;
input [31:0]wb_result;
input [4:0]rd_wb;
input reg_we_wb;

wire [2:0] imm_sel;

controller con(.instr(instr),
					.imm_sel(imm_sel),//connect with IMM_GEN
					.alu_control(alu_control),
					.reg_we(reg_we),//reg_file
					.b_sel(b_sel),//mux B
					.a_sel(a_sel),//mux A : 0 : rs1, 1 : PC
					.mem_we(mem_we),//0 : read, 1 : write
					.wb_sel(wb_sel), //00 : memdata , 01 : aluresult , 10 : PC+4
					.rw_type(rw_type), //00 : byte, 01 : hw, 10 : w;
					.BrUn(brUn),
					.is_branch(is_branch),.is_jal(is_jal), .is_jalr(is_jalr),
					.ld_unsigned(ld_unsigned)//0 : sign extend (LB, LH, LW), 1 : zero extend (LBU, LHU));
					);
reg_file rf( .rs1(rs1),
				.rs2(rs2),
				.rd(rd_wb),
				.reg_write(reg_we_wb),
				.write_data(wb_result),
				.clk(clk),
				.reset(rst),
				.read_data1(rs1_data),
				.read_data2(rs2_data)
				);
IMM_GEN im( .instr(instr[31:7]),
				.imm_sel(imm_sel),
				.imm_out(imm_out));
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];

endmodule