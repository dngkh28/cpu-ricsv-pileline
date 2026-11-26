class forwarding_driver extends uvm_driver#(forwarding_item);
	`uvm_component_utils(forwarding_driver)
	virtual forwarding_if vif;
	function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
	 
	 function  void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual forwarding_if)::get(this,"","vif",vif))
			`uvm_fatal("DRV", "khong lay duoc vif tu config_db")
	 endfunction
	 
	 task run_phase(uvm_phase phase);
		vif.valid <=0;
		forever begin
			seq_item_port.get_next_item(req);
			@(posedge vif.clk);
			vif.rs1 <=req.rs1;
			vif.rs2 <=req.rs2;
			vif.rd_mem <=req.rd_mem;
			vif.rd_wb <=req.rd_wb;
			vif.reg_we_wb <=req.reg_we_wb;
			vif.reg_we_mem <=req.reg_we_mem;
			vif.valid <=1;
			@(posedge vif.clk);
			vif.valid <=0;
			seq_item_port.item_done();
		end
	 endtask
endclass
	 
	 