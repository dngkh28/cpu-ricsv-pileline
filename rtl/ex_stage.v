module ex_stage(rs1_data,rs2_data,imm_out,pc_out,is_branch,is_jal
					,is_jalr,alu_control,a_sel,b_sel,BrUn,alu_result,funct3,wb_data
					,pc_sel,pc_en,store_data,fwd_mem,zero
					,rs1,rs2,rd_mem,rd_wb,reg_we_mem,reg_we_wb
					,ifid_en,ifid_flush,idex_flush);
					
input [31:0]rs1_data,rs2_data,imm_out;
input [31:0]pc_out;
input 		is_branch,is_jal,is_jalr;
input 		BrUn;
input [3:0]	alu_control;
input 		a_sel,b_sel;
input [31:0]wb_data,fwd_mem;
input [4:0] rs1, rs2,rs1_id,rs2_id;               // số hiệu thanh ghi của lệnh ở EX
input [4:0] rd_mem, rd_wb;
input       reg_we_mem, reg_we_wb;
input [2:0]	funct3;
output [31:0]alu_result;
output [1:0]pc_sel;
output [31:0]store_data;
output zero;
output pc_en,ifid_en,ifid_flush,idex_flush;
wire beq, brlt;
wire decision;
wire take;
wire [1:0] forward_a, forward_b;
wire [31:0]fwda_data,fwdb_data,alu_a,alu_b;
assign decision = funct3==3'b000 ? beq : 
						  (funct3==3'b001) ? !beq : 
						  (funct3==3'b100 || funct3 == 3'b110) ? brlt :
						  (funct3==3'b101 || funct3 == 3'b111) ? !brlt : 1'b0;
assign take = is_jal || (decision & is_branch);
assign pc_sel = is_jalr ? 2'b10 : take ? 2'b01: 2'b00;					  
assign store_data = fwdb_data;
mux3 fwda(.sel(forward_a),
		.b0(rs1_data),
		.b1(wb_data),
		.b2(fwd_mem),
		.result(fwda_data)
		);
mux3 fwdb(.sel(forward_b),
		.b0(rs2_data),
		.b1(wb_data),
		.b2(fwd_mem),
		.result(fwdb_data)
		);
mux A(.sel(a_sel),
		.b0(fwda_data),
		.b1(pc_out),
		.result(alu_a));
mux B(.sel(b_sel),
		.b0(fwdb_data),
		.b1(imm_out),
		.result(alu_b));
forwarding_unit fu(.rs1(rs1), 
						 .rs2(rs2),
                   .rd_mem(rd_mem), 
						 .reg_we_mem(reg_we_mem),
                   .rd_wb(rd_wb),   
						 .reg_we_wb(reg_we_wb),
                   .fwd_a(forward_a), 
						 .fwd_b(forward_b)
						 );
hazard_detector(.rs1_id(rs1_id),
					 .rs2_id(rs2_id),
					 .rd_ex(rd_mem), 
					 .is_load_ex(is_load_ex), 
					 .pc_sel(pc_sel),
                .pc_en(pc_en), 
					 .ifid_en(ifid_en), 
					 .ifid_flush(ifid_flush), 
					 .idex_flush(idex_flush)
					 );
alu alua(.a(alu_a),
			.b(alu_b),
			.alu_control(alu_control),
			.result(alu_result),
			.zero(zero)
);
branch_comp bc(.a(fwda_data),
   				.b(fwdb_data),
					.BrUn(BrUn),
					.beq(beq),
					.brlt(brlt)
);


endmodule