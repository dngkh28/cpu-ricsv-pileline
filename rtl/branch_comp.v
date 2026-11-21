module branch_comp(
    input [31:0] a,
    input [31:0] b,
    input brUn,

    output beq,
    output brlt
);

assign beq = (a == b);

assign brlt =
    brUn ?
    (a < b) :
    ($signed(a) < $signed(b));

endmodule