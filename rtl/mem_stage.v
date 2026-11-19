module mem_stage(clk, reset, alu_result, store_data, mem_we, rw_type, ld_unsigned, r_data);
input         clk, reset;
input  [31:0] alu_result, store_data;
input         mem_we, ld_unsigned;
input  [1:0]  rw_type;
output [31:0] r_data;

data_mem dm(.addr(alu_result[6:0]), .mem_we(mem_we), .w_data(store_data),
            .reset(reset), .rw_type(rw_type), .ld_unsigned(ld_unsigned),
            .clk(clk), .r_data(r_data));
endmodule