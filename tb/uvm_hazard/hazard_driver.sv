class hazard_driver extends uvm_driver#(hazard_item);
`uvm_component_utils(hazard_driver)
virtual hazard_if vif;
function new(string name, uvm_component parent);
   super.new(name, parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db#(virtual hazard_if)::get(this, "", "vif", vif))
     `uvm_fatal("DRV", "khong lay duoc vif tu config_db")
endfunction
task run_phase(uvm_phase phase);
vif.valid <= 0;
forever begin
	seq_item_port.get_next_item(req);
	@(posedge vif.clk);
		vif.rs1_id <= req.rs1_id;
		vif.rs2_id <= req.rs2_id;
		vif.rd_ex <= req.rd_ex;
		vif.is_load_ex <=req.is_load_ex;
		vif.pc_sel     <= req.pc_sel;
		vif.valid      <= 1;
	@(posedge vif.clk);
		vif.valid      <= 0;
		seq_item_port.item_done();
end
endtask
endclass