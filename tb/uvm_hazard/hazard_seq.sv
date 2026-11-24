class hazard_seq extends uvm_sequence#(hazard_item);
`uvm_object_utils(hazard_seq)
int n = 200;
function new(string name = "hazard_seq");
   super.new(name);
endfunction
task body();
repeat(n)begin
	hazard_item it=hazard_item::type_id::create("it");
	start_item(it);
	it.rd_ex 		=($urandom_range(3, 0) == 0) ? 5'd0 : $urandom;
	it.rs1_id      = ($urandom_range(3, 0) == 0) ? it.rd_ex : $urandom;
	it.rs2_id      = ($urandom_range(3, 0) == 0) ? it.rd_ex : $urandom;
	it.is_load_ex  = $urandom_range(1, 0);
	it.pc_sel      = $urandom_range(2, 0);
	finish_item(it);
   end
endtask
endclass