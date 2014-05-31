module reg_ID_EX (clk_i, rst_n, flushreg_i, decoder_i, PC_plus4_i, ReadData1_i, ReadData2_i, signed_extension_i, zero_filled_i, instruction_i, rs_i , jump_addr_i,
 decoder_o, PC_plus4_o, ReadData1_o, ReadData2_o, signed_extension_o, zero_filled_o, instruction_o, rs_o, jump_addr_o);

input wire clk_i, rst_n, flushreg_i;
input wire [11-1:0] decoder_i;
input wire [32-1:0] PC_plus4_i;
input wire [32-1:0] ReadData1_i, ReadData2_i, signed_extension_i, zero_filled_i;
input wire [21-1:0] instruction_i;
input wire [5-1:0] rs_i;		//Forwarding Unit ( IE_rs ) need rs value
input wire [32-1:0] jump_addr_i;

output wire [11-1:0] decoder_o;
output wire [32-1:0] PC_plus4_o;
output wire [32-1:0] ReadData1_o, ReadData2_o, signed_extension_o, zero_filled_o;
output wire [21-1:0] instruction_o;
output wire [5-1:0] rs_o;	//Forwarding Unit need rs value
output wire [32-1:0] jump_addr_o;

reg [229-1:0] reg1,reg1_w;

always @(*) begin
	if( flushreg_i ) reg1_w = 229'd0;
	else begin
		reg1_w[228:197] = jump_addr_i;
		reg1_w[196:192] = rs_i;
		reg1_w[191:181] = decoder_i;
		reg1_w[180:149] = PC_plus4_i;
		reg1_w[148:117] = ReadData1_i;
		reg1_w[116:85] = ReadData2_i;
		reg1_w[84:53] = signed_extension_i;
		reg1_w[52:21] = zero_filled_i;
		reg1_w[20:0] = instruction_i;
	end
end
	
always @(posedge clk_i or negedge rst_n) begin
	if(rst_n==0) begin
		reg1 <= 0;
	end
	else begin
		reg1 <= reg1_w;
	end
end

assign jump_addr_o = reg1[228:197];
assign rs_o = reg1[196:192];
assign decoder_o = reg1 [191:181];
assign PC_plus4_o = reg1[180:149];
assign ReadData1_o = reg1[148:117];
assign ReadData2_o = reg1[116:85];
assign signed_extension_o = reg1[84:53];
assign zero_filled_o = reg1[52:21];
assign instruction_o = reg1[20:0];
endmodule