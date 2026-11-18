module hazard_detector(rs1_id, rs2_id, rd_ex, is_load_ex, pc_sel,
                       pc_en, ifid_en, ifid_flush, idex_flush);
input  [4:0] rs1_id, rs2_id, rd_ex;
input        is_load_ex;
input  [1:0] pc_sel;
output       pc_en, ifid_en, ifid_flush, idex_flush;

wire load_use = is_load_ex && (rd_ex != 5'b0) &&
                ((rd_ex == rs1_id) || (rd_ex == rs2_id));
wire jump = (pc_sel != 2'b00);

assign pc_en      = ~load_use;     // load-use: giữ PC
assign ifid_en    = ~load_use;     // load-use: giữ IF/ID
assign ifid_flush = jump;          // nhảy: xóa IF/ID
assign idex_flush = load_use | jump; // load-use hoặc nhảy: bubble vào ID/EX
endmodule