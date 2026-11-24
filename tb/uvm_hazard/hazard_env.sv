class hazard_env extends uvm_env;
    `uvm_component_utils(hazard_env)

    hazard_agent      agt;
    hazard_scoreboard sb;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = hazard_agent::type_id::create("agt", this);
      sb  = hazard_scoreboard::type_id::create("sb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      agt.mon.ap.connect(sb.imp);
    endfunction
  endclass