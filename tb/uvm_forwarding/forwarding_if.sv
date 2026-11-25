interface forwarding_if(input logic clk);
logic [4:0]rs1,rs2,rd_mem,rd_wb;
logic reg_we_wb, reg_we_mem;
logic  [1:0]fwd_a, fwd_b;
logic valid;
endinterface