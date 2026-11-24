  class hazard_agent extends uvm_agent;
    `uvm_component_utils(hazard_agent)

    uvm_sequencer#(hazard_item) sqr;
    hazard_driver  drv;
    hazard_monitor mon;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sqr = uvm_sequencer#(hazard_item)::type_id::create("sqr", this);
      drv = hazard_driver::type_id::create("drv", this);
      mon = hazard_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  endclass