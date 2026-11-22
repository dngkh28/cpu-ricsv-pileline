class alu_driver extends uvm_driver#(alu_item);
	`uvm_component_utils(alu_driver)
	virtual alu_if vif;
	function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif))
			`uvm_fatal("DRV", "khong lay duoc vif tu config_db")
   endfunction
	task run_phase(uvm_phase phase);
		vif.valid<=0;
		forever begin
			seq_item_port.get_next_item(req);  // xin item từ sequencer
			@(posedge vif.clk)
				vif.a           <= req.a;
				vif.b           <= req.b;
				vif.alu_control <= req.alu_control;
				vif.valid       <= 1;              // báo "có giao dịch"
			@(posedge vif.clk);
				vif.valid       <= 0;
				seq_item_port.item_done();         // báo đã xong, xin item kế
      end
    endtask
  endclass