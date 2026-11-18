module mux4(input [1:0]sel,
				input [31:0]b0,
				input [31:0]b1,
				input [31:0]b2,
				input [31:0]b3,
				output [31:0]result);
assign result = (sel == 2'b00) ? b0 : 
					 (sel == 2'b01) ? b1 :
					 (sel == 2'b10) ? b2 : b3;
								
endmodule