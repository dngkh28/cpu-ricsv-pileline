class forwarding_seq extends uvm_sequence #(forwarding_item);
	`uvm_object_utils(forwarding_seq)
	int n=200;
	function bit [4:0] pick_src(bit [4:0] a, bit [4:0] b);
			case ($urandom_range(3, 0))     // tung MỘT lần
				0: return a;                  // 25% trùng a (rd_mem)
				1: return b;                  // 25% trùng b (rd_wb)
				default: return $urandom;     // 50% ngẫu nhiên
			endcase
		endfunction
	function new (string name ="forwarding_seq");
		super.new(name);
	endfunction
	task body();
		repeat(n)begin
		forwarding_item it = forwarding_item::type_id::create("it");
		start_item(it);
		it.rd_mem= ($urandom_range(3, 0) == 0) ? 5'd0 : $urandom;
		it.rd_wb = ($urandom_range(3, 0) == 0) ? 5'd0 : $urandom;
		

		// trong body():
		it.rs1 = pick_src(it.rd_mem, it.rd_wb);
		it.rs2 = pick_src(it.rd_mem, it.rd_wb);
		it.reg_we_wb = $urandom_range(1, 0);
		it.reg_we_mem = $urandom_range(1, 0);
		finish_item(it);
		end
	endtask
endclass