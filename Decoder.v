module Decoder( instr_op_i, ALUOp_o, ALUSrc_o, Branch_o, BranchType_o, MemRead_o, MemWrite_o, MemtoReg_o, RegWrite_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;
output wire	[3-1:0] ALUOp_o;
output wire	ALUSrc_o;
output wire	Branch_o;
output wire	BranchType_o;
output wire	MemWrite_o;
output wire	MemRead_o;
output wire	MemtoReg_o;
output  wire	RegWrite_o;
output wire		RegDst_o;
 
//Internal Signals

//Main function
/*your code here*/

assign ALUOp_o = 	(instr_op_i==6'd0)?3'd2 : 										//R-type	: 2(010)
								(instr_op_i == 6'd8)?3'd4:										//addi	: 4(100)
								(instr_op_i == 6'd15)?3'd5:									//lui		: 5(101)
								(instr_op_i == 6'd35||instr_op_i == 6'd43)?3'd0:		//lw,sw	: 0(000)
								(instr_op_i == 6'd4)?3'd1:										//beq		: 1(001)
								(instr_op_i == 6'd5)?3'd6:										//bne		: 6(110)
								//(instr_op_i == 6'd3)?3'd3:										//jal		: 3(011)
								3'd7;																		//default: 7(111)
					
assign ALUSrc_o = (instr_op_i==6'd0 || instr_op_i==6'd4 || instr_op_i==6'd5)?1'd0 : 1'd1;

assign Branch_o = (instr_op_i==6'd4 || instr_op_i==6'd5)?1'd1:1'd0;

assign BranchType_o = 	(instr_op_i==6'd4)?1'd0:	//beq : 0
										(instr_op_i==6'd5)?1'd1:	//bne : 1
										1'd0;								//default : x

assign MemRead_o = (instr_op_i==6'd35)?1'd1 : 1'd0;		//read when lw, 0 otherwise;

assign MemWrite_o = (instr_op_i==6'd43)?1'd1 : 1'd0;		//write when sw, 0 otherwise;

assign MemtoReg_o = (instr_op_i==6'd35)?1'b1:			// lw : 1
									1'b0;												// R-type : 0

assign	RegWrite_o = (instr_op_i==6'd0 || instr_op_i==6'd3 || instr_op_i==6'd8 || instr_op_i==6'd15 || instr_op_i==6'd35 )?1'd1:1'd0;

assign RegDst_o =(instr_op_i==6'd0)?1'd1:					//	regDst : $rd
							1'd0;												//	regDst : $rt


endmodule
   