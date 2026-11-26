class forwarding_monitor extends uvm_monitor;
	`uvm_component_utils(forwarding_monitor)
	
	virtual forwarding_if vif;
	uvm_analysis_port#(forwarding_item) ap;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		ap = new ("ap",this);
		if(!uvm_config_db#(virtual forwarding_if)::get(this,"","vif",vif))
			`uvm_fatal("MON","khong lay duoc vif tu config_db")
	endfunction
	
	task run_phase(uvm_phase phase);
		forwarding_item it;
		forever begin
			@(posedge vif.clk)
				if(vif.valid ===1'b1) begin
					it = forwarding_item::type_id::create("mon_it");
					it.rs1=vif.rs1;
					it.rs2=vif.rs2;
					it.rd_mem=vif.rd_mem;
					it.rd_wb=vif.rd_wb;
					it.fwd_a = vif.fwd_a;
					it.fwd_b= vif.fwd_b;
					ap.write(it);
				end
		end
	endtask
endclass
				
				