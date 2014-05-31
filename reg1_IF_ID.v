module reg_IF_ID (clk_i, rst_n, IIWrite, PC_plus4_i, instruction_i, PC_plus4_o, instruction_o);

input wire clk_i, rst_n, IIWrite;
input wire [32-1:0] PC_plus4_i, instruction_i;
output wire[32-1:0] PC_plus4_o, instruction_o;
reg [64-1:0] reg1, reg1_w;

always @(*) begin
	if(IIWrite) begin
		reg1_w[63:32] = PC_plus4_i;
		reg1_w[31:0] = instruction_i;
	end
	
	else	reg1_w = reg1;
end
	
always @(posedge clk_i or negedge rst_n) begin
	if(rst_n==0) begin
		reg1 <= 0;
	end
	else begin
		reg1 <= reg1_w;
	end
end


assign PC_plus4_o = reg1[63:32];
assign instruction_o = reg1[31:0


endmodule
