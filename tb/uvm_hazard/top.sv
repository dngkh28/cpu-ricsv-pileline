module top;
import uvm_pkg::*;
import hazard_pkg::*;
bit clk=0;
always #5 clk=~clk;
hazard_if vif(clk);
hazard_detector dut(.rs1_id(vif.rs1_id), .rs2_id(vif.rs2_id), .rd_ex(vif.rd_ex),
                        .is_load_ex(vif.is_load_ex), .pc_sel(vif.pc_sel),
                        .pc_en(vif.pc_en), .ifid_en(vif.ifid_en),
                        .ifid_flush(vif.ifid_flush), .idex_flush(vif.idex_flush));
initial begin
uvm_config_db#(virtual hazard_if)::set(null,"*","vif",vif);
run_test();
end  
endmodule