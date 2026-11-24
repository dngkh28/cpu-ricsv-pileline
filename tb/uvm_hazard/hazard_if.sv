interface hazard_if(input logic clk);
logic  [4:0] rs1_id, rs2_id, rd_ex;
logic        is_load_ex;
logic  [1:0] pc_sel;
logic       pc_en, ifid_en, ifid_flush, idex_flush;
logic  valid;
endinterface
