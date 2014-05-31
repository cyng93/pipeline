module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//IO ports
	input [31:0] aluSrc1;
	input [31:0] aluSrc2;
	input [5-1:0] ALU_operation_i;

	output [31:0] result;
	output zero;
	output overflow;
  
 //Internal Signal
	wire [31:0] result;
	wire zero;
	wire overflow;

  /*your code here*/
	wire invertA;
	wire invertB;
	wire nullAdd;
	wire[2-1:0] aluOp;

	wire[31:0] carryOut;
	wire set;
	wire carryIn;

	assign invertA = ALU_operation_i[4];
	assign invertB = ALU_operation_i[3];
	assign nullAdd = ALU_operation_i[2];
	assign aluOp = ALU_operation_i[1:0];
	assign carryIn = (invertB==1)?1:0;							//Logic Not
	//assign carryIn = (invertA==1||invertB==1)?1:0;			//Arithmetic Not
	

  /* get subtraction */
	wire[31:0] result_t,carryOut_t;
	ALU_32bit ALU32t(result_t,carryOut_t,aluSrc1,aluSrc2,invertA,1'd1,nullAdd,2'b10,carryIn,1'd0);
	assign set = ((aluSrc1[31]==1)&&(aluSrc2[31]==0))?1:
							 ((aluSrc1[31]==0)&&(aluSrc2[31]==1))?0:
							 ((aluSrc1[31]==aluSrc2[31])&&(result_t[31]==1))?1:0;

	/* main */
	ALU_32bit ALU32(result,carryOut,aluSrc1,aluSrc2,invertA,invertB,nullAdd,aluOp,carryIn,set);
	
	assign zero = (result==32'd0)?1:0;
	xor x1(overflow,carryOut[31],carryOut[30]);

endmodule