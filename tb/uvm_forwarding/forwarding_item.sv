class forwarding_item extends uvm_sequence_item;
	`uvm_object_utils(forwarding_item)
	//sequence fill
	logic [4:0] rs1, rs2, rd_mem, rd_wb;
	logic       reg_we_wb, reg_we_mem;
	//monitor fill
	logic [1:0] fwd_a, fwd_b;

	function new(string name = "forwarding_item");
		super.new(name);
	endfunction

	function string convert2string();
		return $sformatf("rs1=%0d rs2=%0d rd_mem=%0d rd_wb=%0d reg_we_wb=%0b reg_we_mem=%0b fwd_a=%2b fwd_b=%2b",
		                 rs1, rs2, rd_mem, rd_wb, reg_we_wb, reg_we_mem, fwd_a, fwd_b);
	endfunction
endclass