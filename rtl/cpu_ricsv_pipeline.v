// RISC-V pipeline 5 tang: IF - ID - EX - MEM - WB
// Quy uoc ten day: hau to la tang ma gia tri dang nam
//   xxx_id  : dau ra cua id_stage (hoac if_id_reg)
//   xxx_ex  : dau ra cua id_ex_reg, hoac dau ra cua ex_stage
//   xxx_mem : dau ra cua ex_mem_reg
//   xxx_wb  : dau ra cua mem_wb_reg
module cpu_ricsv_pipeline(clk, reset, pc, wb_data);
input         clk, reset;
output [31:0] pc;        // PC dang nap lenh (de quan sat)
output [31:0] wb_data;   // du lieu ghi ve thanh ghi (de quan sat)

// ---------------- day noi nguoc (EX/WB ve cac tang truoc) ----------------
wire [1:0]  pc_sel;                 // ex_stage -> if_stage
wire        pc_en, ifid_en, ifid_flush, idex_flush;   // hazard_detector (trong ex_stage)
wire [31:0] fwd_mem;                // lenh o MEM: alu_result hoac pc+4

// ---------------- IF ----------------
wire [31:0] pc4_if, instr_if;

// ---------------- ID ----------------
wire [31:0] pc_id, pc4_id, instr_id;
wire [31:0] rs1_data_id, rs2_data_id, imm_id;
wire [4:0]  rs1_id, rs2_id, rd_id;
wire [3:0]  alu_control_id;
wire        a_sel_id, b_sel_id, brUn_id;
wire        is_branch_id, is_jal_id, is_jalr_id, is_load_id;
wire        mem_we_id, ld_unsigned_id, reg_we_id;
wire [1:0]  rw_type_id, wb_sel_id;

// ---------------- EX ----------------
wire [31:0] rs1_data_ex, rs2_data_ex, imm_ex, pc_ex, pc4_ex;
wire [4:0]  rs1_ex, rs2_ex, rd_ex;
wire [2:0]  funct3_ex;
wire [3:0]  alu_control_ex;
wire        a_sel_ex, b_sel_ex, brUn_ex;
wire        is_branch_ex, is_jal_ex, is_jalr_ex, is_load_ex;
wire        mem_we_ex, ld_unsigned_ex, reg_we_ex;
wire [1:0]  rw_type_ex, wb_sel_ex;
wire [31:0] alu_result_ex, store_data_ex;
wire        zero_ex;

// ---------------- MEM ----------------
wire [31:0] alu_result_mem, store_data_mem, pc4_mem, r_data_mem;
wire [4:0]  rd_mem;
wire        mem_we_mem, ld_unsigned_mem, reg_we_mem;
wire [1:0]  rw_type_mem, wb_sel_mem;

// ---------------- WB ----------------
wire [31:0] alu_result_wb, pc4_wb, r_data_wb;
wire [4:0]  rd_wb;
wire        reg_we_wb;
wire [1:0]  wb_sel_wb;


// =============================== IF ===============================
// pc_target la alu_result_ex (dia chi nhay tinh o EX)
if_stage ifs(.clk(clk), .reset(reset), .en(pc_en),
             .pc_sel(pc_sel), .pc_target(alu_result_ex),
             .pc(pc), .pc_plus4(pc4_if), .instr(instr_if));

if_id_reg ifid(.clk(clk), .reset(reset), .en(ifid_en), .flush(ifid_flush),
               .pc_in(pc), .pc4_in(pc4_if), .instr_in(instr_if),
               .pc_out(pc_id), .pc4_out(pc4_id), .instr_out(instr_id));


// =============================== ID ===============================
// cong ghi reg_file (wb_result, rd_wb, reg_we_wb) den tu tang WB
id_stage ids(.clk(clk), .reset(reset), .instr(instr_id),
             .wb_result(wb_data), .rd_wb(rd_wb), .reg_we_wb(reg_we_wb),
             .reg_we(reg_we_id), .wb_sel(wb_sel_id),
             .brUn(brUn_id), .a_sel(a_sel_id), .b_sel(b_sel_id),
             .alu_control(alu_control_id), .mem_we(mem_we_id),
             .ld_unsigned(ld_unsigned_id), .rw_type(rw_type_id),
             .rs1(rs1_id), .rs2(rs2_id), .rd(rd_id),
             .rs1_data(rs1_data_id), .rs2_data(rs2_data_id),
             .is_branch(is_branch_id), .is_jal(is_jal_id), .is_jalr(is_jalr_id),
             .imm_out(imm_id), .is_load(is_load_id));

id_ex_reg idex(.clk(clk), .reset(reset), .flush(idex_flush),
               .rs1_data_id(rs1_data_id), .rs2_data_id(rs2_data_id),
               .imm_id(imm_id), .pc_id(pc_id), .pc4_id(pc4_id),
               .rs1_id(rs1_id), .rs2_id(rs2_id), .rd_id(rd_id),
               .funct3_id(instr_id[14:12]),
               .alu_control_id(alu_control_id), .a_sel_id(a_sel_id),
               .b_sel_id(b_sel_id), .brUn_id(brUn_id),
               .is_branch_id(is_branch_id), .is_jal_id(is_jal_id), .is_jalr_id(is_jalr_id),
               .mem_we_id(mem_we_id), .rw_type_id(rw_type_id), .ld_unsigned_id(ld_unsigned_id),
               .reg_we_id(reg_we_id), .wb_sel_id(wb_sel_id), .is_load_id(is_load_id),

               .rs1_data_ex(rs1_data_ex), .rs2_data_ex(rs2_data_ex),
               .imm_ex(imm_ex), .pc_ex(pc_ex), .pc4_ex(pc4_ex),
               .rs1_ex(rs1_ex), .rs2_ex(rs2_ex), .rd_ex(rd_ex),
               .funct3_ex(funct3_ex),
               .alu_control_ex(alu_control_ex), .a_sel_ex(a_sel_ex),
               .b_sel_ex(b_sel_ex), .brUn_ex(brUn_ex),
               .is_branch_ex(is_branch_ex), .is_jal_ex(is_jal_ex), .is_jalr_ex(is_jalr_ex),
               .mem_we_ex(mem_we_ex), .rw_type_ex(rw_type_ex), .ld_unsigned_ex(ld_unsigned_ex),
               .reg_we_ex(reg_we_ex), .wb_sel_ex(wb_sel_ex), .is_load_ex(is_load_ex));


// =============================== EX ===============================
// ex_stage chua forwarding_unit va hazard_detector.
// rs1_id, rs2_id: nguon cua lenh dang o ID (cho hazard_detector)
// rs1, rs2: nguon cua lenh dang o EX (cho forwarding_unit)
ex_stage exs(.rs1_data(rs1_data_ex), .rs2_data(rs2_data_ex),
             .imm_ex(imm_ex), .pc_ex(pc_ex),
             .is_branch(is_branch_ex), .is_jal(is_jal_ex), .is_jalr(is_jalr_ex),
             .alu_control(alu_control_ex), .a_sel(a_sel_ex), .b_sel(b_sel_ex),
             .brUn(brUn_ex), .alu_result(alu_result_ex), .funct3(funct3_ex),
             .wb_data(wb_data),
             .pc_sel(pc_sel), .pc_en(pc_en),
             .store_data(store_data_ex), .fwd_mem(fwd_mem), .zero(zero_ex),
             .rs1(rs1_ex), .rs2(rs2_ex), .rs1_id(rs1_id), .rs2_id(rs2_id),
             .is_load_ex(is_load_ex),
             .rd_mem(rd_mem), .rd_wb(rd_wb),
             .reg_we_mem(reg_we_mem), .reg_we_wb(reg_we_wb), .rd_ex(rd_ex),
             .ifid_en(ifid_en), .ifid_flush(ifid_flush), .idex_flush(idex_flush));

// JAL va JALR ghi pc+4, khong phai alu_result (la dia chi dich)
assign fwd_mem = (wb_sel_mem == 2'b10) ? pc4_mem : alu_result_mem;

ex_mem_reg exmem(.clk(clk), .reset(reset),
                 .alu_result_ex(alu_result_ex), .store_data_ex(store_data_ex),
                 .pc4_ex(pc4_ex), .rd_ex(rd_ex),
                 .mem_we_ex(mem_we_ex), .rw_type_ex(rw_type_ex),
                 .ld_unsigned_ex(ld_unsigned_ex), .reg_we_ex(reg_we_ex),
                 .wb_sel_ex(wb_sel_ex),

                 .alu_result_mem(alu_result_mem), .store_data_mem(store_data_mem),
                 .pc4_mem(pc4_mem), .rd_mem(rd_mem),
                 .mem_we_mem(mem_we_mem), .rw_type_mem(rw_type_mem),
                 .ld_unsigned_mem(ld_unsigned_mem), .reg_we_mem(reg_we_mem),
                 .wb_sel_mem(wb_sel_mem));


// =============================== MEM ===============================
mem_stage mems(.clk(clk), .reset(reset),
               .alu_result(alu_result_mem), .store_data(store_data_mem),
               .mem_we(mem_we_mem), .rw_type(rw_type_mem),
               .ld_unsigned(ld_unsigned_mem), .r_data(r_data_mem));

mem_wb_reg memwb(.clk(clk), .reset(reset),
                 .alu_result_mem(alu_result_mem), .pc4_mem(pc4_mem),
                 .r_data_mem(r_data_mem), .rd_mem(rd_mem),
                 .reg_we_mem(reg_we_mem), .wb_sel_mem(wb_sel_mem),

                 .alu_result_wb(alu_result_wb), .pc4_wb(pc4_wb),
                 .r_data_wb(r_data_wb), .rd_wb(rd_wb),
                 .reg_we_wb(reg_we_wb), .wb_sel_wb(wb_sel_wb));


// =============================== WB ===============================
wb_stage wbs(.wb_sel(wb_sel_wb), .r_data(r_data_wb),
             .alu_result(alu_result_wb), .pc4(pc4_wb), .wb_data(wb_data));

endmodule
