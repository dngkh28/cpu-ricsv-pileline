class hazard_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(hazard_scoreboard)
	 uvm_analysis_imp#(hazard_item,hazard_scoreboard) imp;//uvm_analysis_imp#(type ,received class) variant;
	 int pass, fail;
    // coverage
    int n_stall;            // số lần load-use
    int n_stall_rs1_only;   // trùng rs1, không trùng rs2
    int n_stall_rs2_only;   // trùng rs2, không trùng rs1
    int n_stall_both;       // trùng cả hai
    int n_rd0_match;        // load, rd = x0, có trùng rs: KHÔNG được stall
    int n_nonload_match;    // không phải load, có trùng rs: KHÔNG được stall
    int n_jump;             // số lần nhảy
    int n_stall_and_jump;   // load-use và nhảy cùng lúc
    int pc_sel_seen[bit [1:0]];
	 function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      imp = new("imp", this);
    endfunction
	 function void write(hazard_item t);
		bit match1, match2, hazard, taken;
		bit exp_pc_en, exp_ifid_en, exp_ifid_flush, exp_idex_flush;
		match1 = (t.rs1_id == t.rd_ex);
      match2 = (t.rs2_id == t.rd_ex);
      hazard = t.is_load_ex && (t.rd_ex != 5'd0) && (match1 || match2);
      taken  = (t.pc_sel != 2'b00);
		
		exp_pc_en      = !hazard;
      exp_ifid_en    = !hazard;
      exp_ifid_flush = taken;
      exp_idex_flush = hazard || taken;
		// coverage
      if (!pc_sel_seen.exists(t.pc_sel)) pc_sel_seen[t.pc_sel] = 0;
      pc_sel_seen[t.pc_sel]++;
		if (hazard) begin
        n_stall++;
        if (match1 && !match2) n_stall_rs1_only++;
        if (!match1 && match2) n_stall_rs2_only++;
        if (match1 && match2)  n_stall_both++;
      end
		if (t.is_load_ex && t.rd_ex == 5'd0 && (match1 || match2)) n_rd0_match++;
		if (!t.is_load_ex && (match1 || match2) && t.rd_ex != 5'd0) n_nonload_match++;
		if (taken) n_jump++;
      if (hazard && taken) n_stall_and_jump++;
		 // so sánh
      if (t.pc_en === exp_pc_en && t.ifid_en === exp_ifid_en &&
          t.ifid_flush === exp_ifid_flush && t.idex_flush === exp_idex_flush) begin
        pass++;
      end else begin
        fail++;
        `uvm_error("SB", $sformatf("SAI: %s | mong doi pc_en=%0b ifid_en=%0b ifid_flush=%0b idex_flush=%0b",
                                   t.convert2string(), exp_pc_en, exp_ifid_en, exp_ifid_flush, exp_idex_flush))
      end
    endfunction
	 function void check_phase(uvm_phase phase);
      if (pass + fail == 0) `uvm_error("SB", "scoreboard khong nhan duoc giao dich nao")
    endfunction
	 function void report_phase(uvm_phase phase);
      `uvm_info("SB", $sformatf("pass=%0d fail=%0d", pass, fail), UVM_LOW)
      `uvm_info("SB", $sformatf("coverage: stall=%0d (rs1 only=%0d, rs2 only=%0d, ca hai=%0d) | rd=x0 co trung=%0d | khong phai load co trung=%0d",
                n_stall, n_stall_rs1_only, n_stall_rs2_only, n_stall_both, n_rd0_match, n_nonload_match), UVM_LOW)
      `uvm_info("SB", $sformatf("coverage: nhay=%0d | stall va nhay cung luc=%0d | pc_sel da gap=%0d/3",
                n_jump, n_stall_and_jump, pc_sel_seen.size()), UVM_LOW)
      if (fail == 0 && pass > 0) `uvm_info("SB", "*** TEST PASSED ***", UVM_NONE)
      else                       `uvm_info("SB", "*** TEST FAILED ***", UVM_NONE)
    endfunction
  endclass

