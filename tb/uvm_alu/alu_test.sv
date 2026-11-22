class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)

    alu_env env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = alu_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
      alu_seq seq = alu_seq::type_id::create("seq");
      phase.raise_objection(this);                  // giữ run_phase, chưa cho kết thúc
      seq.n = 500;
      seq.start(env.agt.sqr);                       // chạy sequence trên sequencer
      repeat (3) @(posedge env.agt.drv.vif.clk);    // chờ giao dịch cuối qua monitor
      phase.drop_objection(this);                   // xong, cho phép kết thúc
    endtask
  endclass