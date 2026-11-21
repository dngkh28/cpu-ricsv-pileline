module id_stage(clk,reset,instr,wb_result,rd_wb,reg_we,wb_sel,reg_we_wb,
brUn,a_sel,b_sel,alu_control,mem_we,ld_unsigned,rw_type,
rs1,rs2,rd,rs1_data,rs2_data,is_branch,is_jal,is_jalr,imm_out,is_load);
input clk;
input reset;
input [31:0]instr;          // lenh dang o tang ID (tu if_id_reg)

// ---- ghi nguoc reg_file: du lieu den tu tang WB ----
input [31:0]wb_result;      // du lieu ghi (wb_data)
input [4:0]rd_wb;           // thanh ghi dich cua lenh dang o WB
input reg_we_wb;            // cho phep ghi cua lenh dang o WB

// ---- doc reg_file ----
output [4:0]rs1,rs2,rd;     // tach tu instr (rd la cua lenh dang o ID)
output [31:0]rs1_data,rs2_data;
output [31:0]imm_out;       // so tuc thoi da mo rong dau

// ---- tin hieu dieu khien, di tiep qua id_ex_reg ----
// dung o EX
output [3:0]alu_control;
output is_branch, is_jal, is_jalr, a_sel, b_sel;
output brUn;                // so sanh khong dau (BLTU, BGEU)
// dung o MEM
output mem_we;
output [1:0]rw_type;
output ld_unsigned;
output is_load;             // cho hazard_detector (load-use)
// dung o WB
output reg_we;
output [1:0]wb_sel;

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
					.is_load(is_load),
					.brUn(brUn),
					.is_branch(is_branch),.is_jal(is_jal), .is_jalr(is_jalr),
					.ld_unsigned(ld_unsigned)//0 : sign extend (LB, LH, LW), 1 : zero extend (LBU, LHU));
					);
reg_file rf( .rs1(rs1),
				.rs2(rs2),
				.rd(rd_wb),
				.reg_we(reg_we_wb),
				.write_data(wb_result),
				.clk(clk),
				.reset(reset),
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