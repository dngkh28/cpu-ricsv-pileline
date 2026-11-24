class hazard_monitor extends uvm_monitor;
	`uvm_component_utils(hazard_monitor)
	virtual hazard_if vif;
	uvm_analysis_port#(hazard_item) ap;
function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction
function void build_phase (uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap".this);
	if(!uvm_config_db#(virtual hazard_if)::get(this,"","vif",vif))
		`uvm_fatal("MON","khong lay duoc vif tu config_db" )
endfunction
task run_phase(uvm_phase phase);
	hazard_item it;
	forever begin
		@(posedge vif.clk);
		if (vif.valid === 1'b1) begin
          it = hazard_item::type_id::create("mon_it");
          it.rs1_id     = vif.rs1_id;
          it.rs2_id     = vif.rs2_id;
          it.rd_ex      = vif.rd_ex;
          it.is_load_ex = vif.is_load_ex;
          it.pc_sel     = vif.pc_sel;
          it.pc_en      = vif.pc_en;
          it.ifid_en    = vif.ifid_en;
          it.ifid_flush = vif.ifid_flush;
          it.idex_flush = vif.idex_flush;
          ap.write(it);
       end
     end
endtask
endclass

		