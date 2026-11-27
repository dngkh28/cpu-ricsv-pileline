package brancomp_pkg ;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class brancomp_test extends uvm_test;
    `uvm_component_utils(brancomp_test)
        function new(string name, uvm_component parent);
            super.new(name,parent);    
        endfunction //new()
        task run_phase(uvm_phase phase);
        `uvm_info("TEST", "khung chay duoc", UVM_NONE)
        endtask
    endclass // bancomp_test extends uvm_test
    
endpackage