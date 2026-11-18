module id_ex_reg(clk, reset, flush,
    rs1_data_id, rs2_data_id, imm_id, pc_id, pc4_id,
    rs1_id, rs2_id, rd_id, funct3_id,
    alu_control_id, a_sel_id, b_sel_id, brUn_id,
    is_branch_id, is_jal_id, is_jalr_id,
    mem_we_id, rw_type_id, ld_unsigned_id,
    reg_we_id, wb_sel_id, is_load_id,
    rs1_data_ex, rs2_data_ex, imm_ex, pc_ex, pc4_ex,
    rs1_ex, rs2_ex, rd_ex, funct3_ex,
    alu_control_ex, a_sel_ex, b_sel_ex, brUn_ex,
    is_branch_ex, is_jal_ex, is_jalr_ex,
    mem_we_ex, rw_type_ex, ld_unsigned_ex,
    reg_we_ex, wb_sel_ex, is_load_ex);

input        clk, reset, flush;

// vao tu tang ID
input [31:0] rs1_data_id, rs2_data_id, imm_id;
input [31:0] pc_id, pc4_id;
input [4:0]  rs1_id, rs2_id, rd_id;
input [2:0]  funct3_id;
input [3:0]  alu_control_id;
input        a_sel_id, b_sel_id, brUn_id;
input        is_branch_id, is_jal_id, is_jalr_id;
input        mem_we_id, ld_unsigned_id;
input [1:0]  rw_type_id;
input        reg_we_id, is_load_id;
input [1:0]  wb_sel_id;

// ra sang tang EX
output reg [31:0] rs1_data_ex, rs2_data_ex, imm_ex;
output reg [31:0] pc_ex, pc4_ex;
output reg [4:0]  rs1_ex, rs2_ex, rd_ex;
output reg [2:0]  funct3_ex;
output reg [3:0]  alu_control_ex;
output reg        a_sel_ex, b_sel_ex, brUn_ex;
output reg        is_branch_ex, is_jal_ex, is_jalr_ex;
output reg        mem_we_ex, ld_unsigned_ex;
output reg [1:0]  rw_type_ex;
output reg        reg_we_ex, is_load_ex;
output reg [1:0]  wb_sel_ex;

always @(posedge clk or posedge reset) begin
    if (reset || flush) begin
        rs1_data_ex    <= 32'b0;
        rs2_data_ex    <= 32'b0;
        imm_ex         <= 32'b0;
        pc_ex          <= 32'b0;
        pc4_ex         <= 32'b0;
        rs1_ex         <= 5'b0;
        rs2_ex         <= 5'b0;
        rd_ex          <= 5'b0;
        funct3_ex      <= 3'b0;
        alu_control_ex <= 4'b0;
        a_sel_ex       <= 1'b0;
        b_sel_ex       <= 1'b0;
        brUn_ex        <= 1'b0;
        is_branch_ex   <= 1'b0;
        is_jal_ex      <= 1'b0;
        is_jalr_ex     <= 1'b0;
        mem_we_ex      <= 1'b0;
        rw_type_ex     <= 2'b0;
        ld_unsigned_ex <= 1'b0;
        reg_we_ex      <= 1'b0;
        wb_sel_ex      <= 2'b0;
        is_load_ex     <= 1'b0;
    end
    else begin
        rs1_data_ex    <= rs1_data_id;
        rs2_data_ex    <= rs2_data_id;
        imm_ex         <= imm_id;
        pc_ex          <= pc_id;
        pc4_ex         <= pc4_id;
        rs1_ex         <= rs1_id;
        rs2_ex         <= rs2_id;
        rd_ex          <= rd_id;
        funct3_ex      <= funct3_id;
        alu_control_ex <= alu_control_id;
        a_sel_ex       <= a_sel_id;
        b_sel_ex       <= b_sel_id;
        brUn_ex        <= brUn_id;
        is_branch_ex   <= is_branch_id;
        is_jal_ex      <= is_jal_id;
        is_jalr_ex     <= is_jalr_id;
        mem_we_ex      <= mem_we_id;
        rw_type_ex     <= rw_type_id;
        ld_unsigned_ex <= ld_unsigned_id;
        reg_we_ex      <= reg_we_id;
        wb_sel_ex      <= wb_sel_id;
        is_load_ex     <= is_load_id;
    end
end

endmodule
