class alu_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(alu_scoreboard)
	uvm_analysis_imp#(alu_item,alu_scoreboard) imp;//Tao bien
	int pass, fail;
	int op_seen[bit [3:0]]; 
	int n_zero_result;
	int n_overflow;
	//tạo cổng nhận item của scoreboard,
	function new(string name, uvm_component parent);
      super.new(name, parent);//Chạy phần việc chung của class cha (uvm_scoreboard). 
										//Luôn viết dòng này đầu tiên
		imp = new("imp", this);	//Tạo đối tượng cổng imp
   endfunction
	function bit [31:0] ref_model(alu_item t);
      case (t.alu_control)
        4'b0000: return t.a & t.b;                                    // AND
        4'b0001: return t.a | t.b;                                    // OR
        4'b0010: return t.a + t.b;                                    // ADD
        4'b0100: return t.a - t.b;                                    // SUB
        4'b1000: return (t.a < t.b) ? 32'd1 : 32'd0;                  // SLTU
        4'b0011: return t.a << t.b[4:0];                              // SLL
        4'b0101: return t.a >> t.b[4:0];                              // SRL
        4'b1010: return $signed(t.a) >>> t.b[4:0];                    // SRA
        4'b0110: return ($signed(t.a) < $signed(t.b)) ? 32'd1 : 32'd0;// SLT
        4'b0111: return t.a ^ t.b;                                    // XOR
        4'b1001: return t.b;                                          // PASS_B
        default: return 32'd0;
      endcase
    endfunction
	 function void write(alu_item t);
      bit [31:0] exp_result = ref_model(t);
      bit        exp_zero   = (exp_result == 32'd0);
      bit [32:0] wide;

      // đếm coverage bằng tay
      if (!op_seen.exists(t.alu_control)) op_seen[t.alu_control] = 0;
      op_seen[t.alu_control]++;
      if (exp_result == 0) n_zero_result++;
      if (t.alu_control == 4'b0010) begin
        wide = {1'b0, t.a} + {1'b0, t.b};
        if (wide[32]) n_overflow++;
      end
      if (t.alu_control == 4'b0100 && t.a < t.b) n_overflow++;

      // so sánh DUT với mô hình
      if (t.result === exp_result && t.zero === exp_zero) begin
        pass++;
      end else begin
        fail++;
        `uvm_error("SB", $sformatf("SAI: %s | mong doi result=%08h zero=%0b",
                                   t.convert2string(), exp_result, exp_zero))
      end
    endfunction
	 function void check_phase(uvm_phase phase);
      if (pass + fail == 0)
        `uvm_error("SB", "scoreboard khong nhan duoc giao dich nao")
    endfunction
	 function void report_phase(uvm_phase phase);
      `uvm_info("SB", $sformatf("pass=%0d fail=%0d | alu_control da gap=%0d/11 | result=0: %0d lan | tran/muon: %0d lan",
                pass, fail, op_seen.size(), n_zero_result, n_overflow), UVM_LOW)
      if (fail == 0 && pass > 0) `uvm_info("SB", "*** TEST PASSED ***", UVM_NONE)
      else                       `uvm_info("SB", "*** TEST FAILED ***", UVM_NONE)
    endfunction
  endclass

	