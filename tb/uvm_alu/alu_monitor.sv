class alu_monitor extends uvm_monitor;
   `uvm_component_utils(alu_monitor)
	virtual alu_if vif;
	uvm_analysis_port#(alu_item) ap;
	function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
	 function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap = new("ap",this);
		if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
		`uvm_fatal("MON", "khong lay duoc vif tu config_db")
    endfunction
	 task run_phase (uvm_phase phase);
	 alu_item it;
	 forever begin
		@(posedge vif.clk);
        if (vif.valid === 1'b1) begin      // có giao dịch thật
          it = alu_item::type_id::create("mon_it");
          it.a           = vif.a;
          it.b           = vif.b;
          it.alu_control = vif.alu_control;
          it.result      = vif.result;
          it.zero        = vif.zero;
          ap.write(it);                    // gửi cho scoreboard
        end
	 end
    endtask
endclass