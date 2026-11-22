class alu_item extends uvm_sequence_item;
`uvm_object_utils(alu_item)
bit [31:0]a,b;
bit [3:0]alu_control;
bit [31:0]result;
bit zero;
function new(string name = "alu_item");
   super.new(name);
endfunction
function string convert2string();
	return $sformatf ("op=%b a=%08h b=%08h -> result = %08h zero=%0b",alu_control,a,b,result,zero);
endfunction
endclass