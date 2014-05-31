module reg_MEM_WB  (clk_i, rst_n, decoder_i, MemReadData_i, FURslt_i, instruction_i,
 decoder_o, MemReadData_o, FURslt_o, instruction_o);

input wire clk_i, rst_n;
input wire [2-1:0] decoder_i;
input wire [32-1:0] MemReadData_i;
input wire [32-1:0] FURslt_i;
input wire [5-1:0] instruction_i;


output wire [2-1:0] decoder_o;
output wire [32-1:0] MemReadData_o;
output wire [32-1:0] FURslt_o;
output wire [5-1:0] instruction_o;


reg [71-1:0] reg1,reg1_w;

always @(*) begin
	reg1_w [70:69] = decoder_i;
	reg1_w[68:37] = MemReadData_i;
	reg1_w[36:5] = FURslt_i;
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


assign decoder_o = reg1 [70:69];
assign MemReadData_o = reg1[68:37];
assign FURslt_o = reg1[36:5];
assign instruction_o = reg1[4:0];

endmodule
