class hazard_item extends uvm_sequence_item;
`uvm_object_utils(hazard_item)//đăng ký class hazard_item với factory của UVM
bit [4:0] rs1_id, rs2_id, rd_ex;
bit       is_load_ex;
bit [1:0] pc_sel;
// đầu ra (monitor điền)
bit       pc_en, ifid_en, ifid_flush, idex_flush;
function new(string name = "hazard_item");
   super.new(name);
endfunction
function string convert2string();
  return $sformatf("rs1=%0d rs2=%0d rd_ex=%0d load=%0b pc_sel=%0d -> pc_en=%0b ifid_en=%0b ifid_flush=%0b idex_flush=%0b",
                   rs1_id, rs2_id, rd_ex, is_load_ex, pc_sel, pc_en, ifid_en, ifid_flush, idex_flush);
endfunction
endclass