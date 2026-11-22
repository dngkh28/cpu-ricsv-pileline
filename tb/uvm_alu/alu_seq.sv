class alu_seq extends uvm_sequence#(alu_item);
	`uvm_object_utils(alu_seq)
	int n=200;
	function new(string name = "alu_seq");
		super.new(name);
	endfunction
	
	function bit [31:0] pick_operand();
	case ($urandom_range(7, 0))
		0: return 32'h0;
		1: return 32'h1;
		2: return 32'hFFFFFFFF;
		3: return 32'h80000000;
		default: return $urandom;
	endcase
	endfunction
	task body();
	bit[3:0] ops[11]= '{4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b1000, 4'b0011,
                            4'b0101, 4'b1010, 4'b0110, 4'b0111, 4'b1001};
	repeat (n)begin 
	alu_item it = alu_item :: type_id ::create("it");
	start_item(it);
	it.a           = pick_operand();
   it.b           = pick_operand();
	it.alu_control = ops[$urandom_range(10, 0)];
	finish_item(it);
	end
	endtask
endclass
	