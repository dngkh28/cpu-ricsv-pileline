module wb_stage(wb_sel, r_data, alu_result, pc4, wb_data);
input  [1:0]  wb_sel;
input  [31:0] r_data, alu_result, pc4;
output [31:0] wb_data;

mux3 wb_mux(.sel(wb_sel),
            .b0(r_data),
            .b1(alu_result),
            .b2(pc4),
            .result(wb_data));
endmodule