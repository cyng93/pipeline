module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o,shamt_o, Jump_o);

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output  wire	[5-1:0] ALU_operation_o;  
output  wire	[2-1:0] FURslt_o;
output  wire	shamt_o;
output	wire	Jump_o;

//Internal Signals

//Main function
/*your code here*/
assign FURslt_o =	(ALUOp_i == 3'd5)?2'd2:										//lui: 2
							((ALUOp_i==3'd2)&&(funct_i == 6'd0 || funct_i == 6'd2 || funct_i==6'd4 || funct_i==6'd6||funct_i==6'd8))?2'd1:	 //Shifting: 1
							((ALUOp_i==3'd0) || (ALUOp_i == 3'd4) || ((ALUOp_i==3'd2)&&(funct_i!=6'd0 && funct_i!=6'd2 && funct_i!=6'd4 && funct_i!=6'd6 && funct_i!=6'd8)))?2'd0://other R-type exclude shifting, jr
							2'd3;			//default: 3

assign	ALU_operation_o =	(ALUOp_i==3'd0||ALUOp_i==3'd4 || funct_i==6'd32)?5'b00010:		//lw,sw,addi
											(ALUOp_i==3'd1||ALUOp_i==3'd6||funct_i==6'd34)?5'b01010:			//beq, bne, sub
											(funct_i==6'd36)?5'b00000:
											(funct_i==6'd37)?5'b00001:
											(funct_i==6'd47)?5'b10110:
											(funct_i==6'd42)?5'b01011:
											(funct_i==6'd0||funct_i==6'd4||funct_i==6'd8)?5'd1:		//1 (represent leftRight when fucntion is sll/srl) left //6'b000100=left 6'b000110=right
											(funct_i==6'd2||funct_i==6'd6)?5'd0:		//0 (represent leftRight when fucntion is sll/srl) right
											5'b11111;//default
									
assign 	shamt_o = (funct_i==6'b000110||funct_i==6'b000100)?0:1;		//sllv, srlv: 0 (Advancedshift<BONUS>)

assign	Jump_o = 	//(ALUOp_i==3'd2 && funct_i==6'd8)?2'd2:					//PC = $ra (reg[$rs])
								(ALUOp_i==3'd3 || ALUOp_i==3'd7)?1'd1:					//jal, jump: PC = instruction[31:28]:...
								1'd0;																			//defualt : 0
							

						
endmodule     
