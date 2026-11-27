module top;
    import uvm_pkg::*;
    import brancomp_pkg::*;
    bit clk=0;
    always #5 clk =~clk;
    brancomp_if vif(clk);
    branch_comp dut(.a(vif.a), .b(vif.b),.brUn(vif.brUn),.brlt(vif.brlt), .beq(vif.beq));
    initial begin
        uvm_config_db#(virtual brancomp_if)::set(null,"*","vif",vif);
        run_test();
    end

endmodule