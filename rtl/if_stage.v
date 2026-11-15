module if_stage(clk, reset, en, pc_sel, pc_target, pc, pc_plus4, instr);
input clk, reset, en;//en used for stall
input [1:0]  pc_sel;
input [31:0] pc_target;
output [31:0] pc, pc_plus4, instr;

wire [31:0] pc_in = (pc_sel == 2'b01) ? pc_target :
                    (pc_sel == 2'b10) ? {pc_target[31:1], 1'b0} :
                                        pc_plus4;

pc_reg  PCR(.clk(clk), .reset(reset), .en(en), .pc_in(pc_in),
            .pc_out(pc), .pc_outnext(pc_plus4));
INSTR_MEM IM(.PC(pc), .reset(reset), .instruction_code(instr));
endmodule