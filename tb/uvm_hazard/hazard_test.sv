class hazard_test extends uvm_test;
    `uvm_component_utils(hazard_test)

    hazard_env env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = hazard_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
      hazard_seq seq = hazard_seq::type_id::create("seq");
      phase.raise_objection(this);
      seq.n = 2000;
      seq.start(env.agt.sqr);
      repeat (3) @(posedge env.agt.drv.vif.clk);
      phase.drop_objection(this);
    endtask
  endclass
