module controller(
input [31:0]instr,
output reg [2:0]imm_sel,//Connect with funct3 : 000(I_TYPE) , 001(S_TYPE)
output reg [3:0]alu_control,
output reg reg_we,//reg_file
output reg b_sel,//mux B
output reg a_sel,//mux A : 0 : rs1, 1 : PC
output reg mem_we,//0 : read, 1 : write
output reg [1:0]wb_sel, //00 : memdata , 01 : aluresult , 10 : PC+4
output reg [1:0]rw_type, //00 : byte, 01 : hw, 10 : w;
output reg brUn,
output reg is_branch,is_jal, is_jalr,
output reg ld_unsigned,//0 : sign extend (LB, LH, LW), 1 : zero extend (LBU, LHU)
output reg is_load
);
localparam I_TYPE = 3'b000;
localparam S_TYPE = 3'b001;
localparam B_TYPE = 3'b010;
localparam J_TYPE = 3'b100;
localparam U_TYPE = 3'b011;
always @(*)begin
    imm_sel       = 0;
    alu_control   = 0;
    reg_we 			= 0;
    b_sel         = 0;
    mem_we        = 0;
    wb_sel        = 1;
    rw_type       = 0;
	 a_sel         = 0;
	 is_branch     = 0;
	 is_jal	  		= 0;
	 is_jalr	  		= 0;
	 brUn       	= 0;
	 is_load 		= 0;
	 ld_unsigned   = 0;
	case(instr[6:0])
		//R-type
		7'b011_0011:
		begin
			reg_we = 1;
			a_sel  = 0;
			b_sel  = 0;
			wb_sel = 2'b01;
			mem_we =	0;
			is_load = 0;
			case(instr[14:12])
				3'b111 : alu_control = 4'b0000;//AND
				3'b110 : alu_control = 4'b0001;//ORR
				3'b000 : begin
				if(instr[31:25]== 7'b0000000 )alu_control = 4'b0010;// ADD
						else if (instr[31:25] ==7'b0100000)alu_control = 4'b0100;//SUB
				end
				3'b011 : alu_control = 4'b1000;//SLTU
				3'b001 : alu_control = 4'b0011;//SLL
				3'b101 : begin
				if(instr[31:25]== 7'b0000000 )alu_control = 4'b0101;//SRL
						else if (instr[31:25] ==7'b0100000)alu_control = 4'b1010;//SRA
				end
				3'b010 : alu_control = 4'b0110;//SLT
				3'b100 : alu_control = 4'b0111;//XOR
			endcase
		end

		//I-type
		7'b001_0011: //calculate with I
		begin
			reg_we = 1;
			imm_sel = I_TYPE;
			b_sel = 1;
			a_sel = 0;
			mem_we = 0;
			wb_sel = 2'b01;
			is_load = 0;
			case(instr[14:12])
				3'b111 : alu_control = 4'b0000;//AND
				3'b110 : alu_control = 4'b0001;//ORR
				3'b000 : alu_control = 4'b0010;// ADD
				3'b011 : alu_control = 4'b1000;//SLTU
				3'b010 : alu_control = 4'b0110;//SLT
				3'b001 : alu_control = 4'b0011;//SLL
				3'b101 : begin
				if(instr[31:25]== 7'b0000000 )alu_control = 4'b0101;//SRL
						else if (instr[31:25] ==7'b0100000)alu_control = 4'b1010;//SRA
				end
				3'b100 : alu_control = 4'b0111;//XOR
			endcase
		end

		7'b000_0011: //load
		begin
			wb_sel = 2'b00;
			reg_we = 1;
			b_sel = 1;
			a_sel = 0;
			mem_we = 0;
			is_load = 1;
			alu_control = 4'b0010;
			imm_sel = I_TYPE;
			case(instr[14:12])
				3'b000 ://byte
					begin
						rw_type = 2'b00; //byte
						ld_unsigned = 0; //LB
					end
				3'b001 : //Half_word
					begin
						rw_type = 2'b01; //half_word
						ld_unsigned = 0; //LH
					end
				3'b010 : //Word
					begin

						rw_type = 2'b10; //word
						ld_unsigned = 0; //LW
					end
				3'b100 : //Byte unsigned
					begin
						rw_type = 2'b00; //byte
						ld_unsigned = 1; //LBU
					end
				3'b101 : //Half_word unsigned
					begin
						rw_type = 2'b01; //half_word
						ld_unsigned = 1; //LHU
					end
				default : reg_we = 0;

			endcase
		end
		//S_TYPE
		7'b010_0011: //store
		begin
			reg_we = 0;
			b_sel= 1;
			a_sel = 0;
			mem_we = 1;
			alu_control = 4'b0010;
			imm_sel = S_TYPE;
			is_load = 0;
			case(instr[14:12])
				3'b000 : begin
					rw_type = 2'b00;//byte
				end
				3'b001 : begin
					rw_type = 2'b01;//half_word
				end
				3'b010 : begin
					rw_type = 2'b10;//word
				end
				default : mem_we = 0;
			endcase
		end
		//B_TYPE
		7'b1100011 : begin
		reg_we     = 0;
		b_sel      = 1;
      a_sel      = 1;
		is_load 	  = 0;
		mem_we 	  = 0;
		alu_control = 4'b0010;
      imm_sel     = B_TYPE;
		is_branch  = 1;
		is_jal	  = 0;
		is_jalr	  = 0;
      case(instr[14:12])
          3'b000 : begin // BEQ
              brUn   = 0;
          end
          3'b001 : begin // BNE
              brUn   = 0;
          end
          3'b100 : begin // BLT (signed)
              brUn   = 0;
          end
          3'b101 : begin // BGE (signed)
              brUn   = 0;
          end
          3'b110 : begin // BLTU (unsigned)
              brUn   = 1;
          end
          3'b111 : begin // BGEU (unsigned)
              brUn   = 1;
          end
          default : begin
              brUn   = 0;

          end
      endcase
		end
		//J_TYPE :JAL
		7'b1101111 : begin
			reg_we		= 1;
			b_sel			= 1;
			is_branch   = 0;
			is_jal	   = 1;
			is_jalr	   = 0;
			a_sel			= 1;
			wb_sel		= 2'b10;
			mem_we		= 0;
			is_load 		= 0;
			alu_control 	= 4'b0010;
			imm_sel     = J_TYPE;

		end
		//I_TYPE :JALR
		7'b1100111 : begin
			if(instr[14:12] == 3'b000) begin
				reg_we     = 1;
				b_sel      = 1;
				a_sel      = 0;
				is_branch  = 0;
				is_jal	  = 0;
				is_jalr	  = 1;
				is_load 	  = 0;
				wb_sel     = 2'b10; // PC+4
				mem_we     = 0;
				alu_control = 4'b0010; // ADD
				imm_sel    = I_TYPE;
			end
		end
		//U_TYPE: LUI
		7'b0110111 : begin
			reg_we		= 1;
			b_sel			= 1;
			a_sel			= 0;
			wb_sel		= 2'b01;
			mem_we		= 0;
			is_load 		= 0;
			alu_control 	= 4'b1001;//PASS_B
			imm_sel     = U_TYPE;
		end
		//U_TYPE : AUIPC
		7'b0010111: begin
			reg_we = 1;
			b_sel  = 1;
			a_sel  = 1;
			wb_sel = 2'b01;
			mem_we = 0;
			is_load = 0;
			alu_control = 4'b0010;// ADD
			imm_sel = U_TYPE;
end
		default: ;
	endcase


end
endmodule
