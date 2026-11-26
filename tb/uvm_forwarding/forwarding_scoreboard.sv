class forwarding_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(forwarding_scoreboard)

	uvm_analysis_imp#(forwarding_item, forwarding_scoreboard) imp;

	int pass, fail;
	// coverage: số lần mỗi mã fwd xuất hiện (00 thanh ghi, 01 WB, 10 MEM)
	int fwd_a_seen[bit [1:0]];
	int fwd_b_seen[bit [1:0]];
	int n_rd0_we;       // lệnh trước có ghi, rd = x0, trùng rs: KHÔNG được forward
	int n_nowe_match;   // lệnh trước không ghi (reg_we = 0), trùng rs: KHÔNG được forward
	int n_both_match;   // rs trùng cả rd_mem và rd_wb: MEM phải thắng

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		imp = new("imp", this);
	endfunction

	// mô hình đúng theo đặc tả: MEM mới hơn WB nên được ưu tiên
	function bit [1:0] expect_fwd(forwarding_item t, bit [4:0] rs);
		if (t.reg_we_mem && t.rd_mem != 5'd0 && t.rd_mem == rs) return 2'b10;
		if (t.reg_we_wb  && t.rd_wb  != 5'd0 && t.rd_wb  == rs) return 2'b01;
		return 2'b00;
	endfunction

	// coverage cho một toán hạng
	function void sample_cov(forwarding_item t, bit [4:0] rs);
		if ((t.reg_we_mem && t.rd_mem == 5'd0 && rs == 5'd0) ||
		    (t.reg_we_wb  && t.rd_wb  == 5'd0 && rs == 5'd0)) n_rd0_we++;
		if ((!t.reg_we_mem && t.rd_mem != 5'd0 && rs == t.rd_mem) ||
		    (!t.reg_we_wb  && t.rd_wb  != 5'd0 && rs == t.rd_wb))  n_nowe_match++;
		if (t.reg_we_mem && t.reg_we_wb && t.rd_mem != 5'd0 &&
		    rs == t.rd_mem && rs == t.rd_wb) n_both_match++;
	endfunction

	function void write(forwarding_item t);
		bit [1:0] exp_a, exp_b;
		exp_a = expect_fwd(t, t.rs1);
		exp_b = expect_fwd(t, t.rs2);

		if (!fwd_a_seen.exists(t.fwd_a)) fwd_a_seen[t.fwd_a] = 0;
		fwd_a_seen[t.fwd_a]++;
		if (!fwd_b_seen.exists(t.fwd_b)) fwd_b_seen[t.fwd_b] = 0;
		fwd_b_seen[t.fwd_b]++;
		sample_cov(t, t.rs1);
		sample_cov(t, t.rs2);

		if (t.fwd_a === exp_a && t.fwd_b === exp_b) begin
			pass++;
		end else begin
			fail++;
			`uvm_error("SB", $sformatf("SAI: %s | mong doi fwd_a=%2b fwd_b=%2b",
			                           t.convert2string(), exp_a, exp_b))
		end
	endfunction

	function void check_phase(uvm_phase phase);
		if (pass + fail == 0) `uvm_error("SB", "scoreboard khong nhan duoc giao dich nao")
	endfunction

	function void report_phase(uvm_phase phase);
		`uvm_info("SB", $sformatf("pass=%0d fail=%0d", pass, fail), UVM_LOW)
		`uvm_info("SB", $sformatf("coverage: fwd_a da gap=%0d/3 fwd_b da gap=%0d/3 | rd=x0 co trung=%0d | reg_we=0 co trung=%0d | trung ca MEM va WB=%0d",
		          fwd_a_seen.size(), fwd_b_seen.size(), n_rd0_we, n_nowe_match, n_both_match), UVM_LOW)
		if (fail == 0 && pass > 0) `uvm_info("SB", "*** TEST PASSED ***", UVM_NONE)
		else                       `uvm_info("SB", "*** TEST FAILED ***", UVM_NONE)
	endfunction
endclass