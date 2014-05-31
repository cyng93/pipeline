module reg_EX_MEM  (clk_i, rst_n, decoder_i, PC_plus4_i, zero_i, FURslt_i, ReadData2_i, instruction_i, jump_addr_i, jump_i,
 decoder_o, PC_plus4_o, zero_o, FURslt_o, ReadData2_o, instruction_o, jump_addr_o, jump_o);

input wire clk_i, rst_n;
input wire [5-1:0] decoder_i;
input wire [32-1:0] PC_plus4_i;
input wire zero_i;
input wire [32-1:0] FURslt_i;
input wire [32-1:0] ReadData2_i;
input wire [5-1:0] instruction_i;
input wire [32-1:0] jump_addr_i;
input wire jump_i;


output wire [5-1:0] decoder_o;
output wire [32-1:0] PC_plus4_o;
output wire zero_o;
output wire [32-1:0] FURslt_o;
output wire [32-1:0] ReadData2_o;
output wire [5-1:0] instruction_o;
output wire [32-1:0] jump_addr_o;
input wire jump_o;


reg [140-1:0] reg1,reg1_w;

always @(*) begin
	reg1_w [139] = jump_i;
	reg1_w [138:107] = jump_addr_i;
	reg1_w [106:102] = decoder_i;
	reg1_w[101:70] = PC_plus4_i;
	reg1_w[69] = zero_i;
	reg1_w[68:37] = FURslt_i;
	reg1_w[36:5] = ReadData2_i;
	reg1_w[4:0] = instruction_i;
end

always @(posedge clk_i or negedge rst_n) begin
	if(rst_n==0) begin
		reg1 <= 0;
	end
	else begin
		reg1 <= reg1_w;
	end
end


assign jump_o = reg1[139];
assign jump_addr_o = reg1[138:107];
assign decoder_o = reg1 [106:102];
assign PC_plus4_o = reg1[101:70];
assign zero_o = reg1[69];
assign FURslt_o = reg1[68:37];
assign ReadData2_o = reg1[36:5];
assign instruction_o = reg1[4:0];

endmodule
