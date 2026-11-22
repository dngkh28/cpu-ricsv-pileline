  class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)

    uvm_sequencer#(alu_item) sqr;
    alu_driver  drv;
    alu_monitor mon;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sqr = uvm_sequencer#(alu_item)::type_id::create("sqr", this);
      drv = alu_driver::type_id::create("drv", this);
      mon = alu_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);   // driver <- sequencer
    endfunction
  endclass