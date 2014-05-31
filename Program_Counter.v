module Program_Counter( clk_i, rst_n, pc_in_i, pc_out_o, PCWrite );
     
//I/O ports
input           clk_i;
input	        rst_n;
input	wire PCWrite;
input  [32-1:0] pc_in_i;
output [32-1:0] pc_out_o;
 
//Internal Signals
reg    [32-1:0] pc_out_o, pc_out_w;

//Main function
always @(posedge clk_i or negedge rst_n) begin
    if(~rst_n)	pc_out_o <= 0;
	else	 pc_out_o <= pc_in_w;
end

always @(*) begin
	if(PCWrite)	pc_out_w = pc_out_i;
	else	pc_out_w = pc_out_o;
end

endmodule