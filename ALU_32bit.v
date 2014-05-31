module ALU_32bit( result, carryOut, aluSrc1, aluSrc2, invertA, invertB, nullAdd, aluOp, carryIn, less );
  
  output wire[31:0] result, carryOut;
  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire nullAdd;
  input wire[1:0] aluOp;
	input wire carryIn;
	input wire less;
	ALU_1bit ALU0(result[0],carryOut[0],aluSrc1[0],aluSrc2[0],invertA,invertB,nullAdd,aluOp,carryIn,less);
	ALU_1bit ALU1(result[1],carryOut[1],aluSrc1[1],aluSrc2[1],invertA,invertB,nullAdd,aluOp,carryOut[0],1'b0);
	ALU_1bit ALU2(result[2],carryOut[2],aluSrc1[2],aluSrc2[2],invertA,invertB,nullAdd,aluOp,carryOut[1],1'b0);
	ALU_1bit ALU3(result[3],carryOut[3],aluSrc1[3],aluSrc2[3],invertA,invertB,nullAdd,aluOp,carryOut[2],1'b0);
	ALU_1bit ALU4(result[4],carryOut[4],aluSrc1[4],aluSrc2[4],invertA,invertB,nullAdd,aluOp,carryOut[3],1'b0);
	ALU_1bit ALU5(result[5],carryOut[5],aluSrc1[5],aluSrc2[5],invertA,invertB,nullAdd,aluOp,carryOut[4],1'b0);
	ALU_1bit ALU6(result[6],carryOut[6],aluSrc1[6],aluSrc2[6],invertA,invertB,nullAdd,aluOp,carryOut[5],1'b0);
	ALU_1bit ALU7(result[7],carryOut[7],aluSrc1[7],aluSrc2[7],invertA,invertB,nullAdd,aluOp,carryOut[6],1'b0);
	ALU_1bit ALU8(result[8],carryOut[8],aluSrc1[8],aluSrc2[8],invertA,invertB,nullAdd,aluOp,carryOut[7],1'b0);
	ALU_1bit ALU9(result[9],carryOut[9],aluSrc1[9],aluSrc2[9],invertA,invertB,nullAdd,aluOp,carryOut[8],1'b0);
	ALU_1bit ALU10(result[10],carryOut[10],aluSrc1[10],aluSrc2[10],invertA,invertB,nullAdd,aluOp,carryOut[9],1'b0);	
	ALU_1bit ALU11(result[11],carryOut[11],aluSrc1[11],aluSrc2[11],invertA,invertB,nullAdd,aluOp,carryOut[10],1'b0);
	ALU_1bit ALU12(result[12],carryOut[12],aluSrc1[12],aluSrc2[12],invertA,invertB,nullAdd,aluOp,carryOut[11],1'b0);
	ALU_1bit ALU13(result[13],carryOut[13],aluSrc1[13],aluSrc2[13],invertA,invertB,nullAdd,aluOp,carryOut[12],1'b0);
	ALU_1bit ALU14(result[14],carryOut[14],aluSrc1[14],aluSrc2[14],invertA,invertB,nullAdd,aluOp,carryOut[13],1'b0);
	ALU_1bit ALU15(result[15],carryOut[15],aluSrc1[15],aluSrc2[15],invertA,invertB,nullAdd,aluOp,carryOut[14],1'b0);
	ALU_1bit ALU16(result[16],carryOut[16],aluSrc1[16],aluSrc2[16],invertA,invertB,nullAdd,aluOp,carryOut[15],1'b0);
	ALU_1bit ALU17(result[17],carryOut[17],aluSrc1[17],aluSrc2[17],invertA,invertB,nullAdd,aluOp,carryOut[16],1'b0);
	ALU_1bit ALU18(result[18],carryOut[18],aluSrc1[18],aluSrc2[18],invertA,invertB,nullAdd,aluOp,carryOut[17],1'b0);
	ALU_1bit ALU19(result[19],carryOut[19],aluSrc1[19],aluSrc2[19],invertA,invertB,nullAdd,aluOp,carryOut[18],1'b0);
	ALU_1bit ALU20(result[20],carryOut[20],aluSrc1[20],aluSrc2[20],invertA,invertB,nullAdd,aluOp,carryOut[19],1'b0);	
	ALU_1bit ALU21(result[21],carryOut[21],aluSrc1[21],aluSrc2[21],invertA,invertB,nullAdd,aluOp,carryOut[20],1'b0);
	ALU_1bit ALU22(result[22],carryOut[22],aluSrc1[22],aluSrc2[22],invertA,invertB,nullAdd,aluOp,carryOut[21],1'b0);
	ALU_1bit ALU23(result[23],carryOut[23],aluSrc1[23],aluSrc2[23],invertA,invertB,nullAdd,aluOp,carryOut[22],1'b0);
	ALU_1bit ALU24(result[24],carryOut[24],aluSrc1[24],aluSrc2[24],invertA,invertB,nullAdd,aluOp,carryOut[23],1'b0);
	ALU_1bit ALU25(result[25],carryOut[25],aluSrc1[25],aluSrc2[25],invertA,invertB,nullAdd,aluOp,carryOut[24],1'b0);
	ALU_1bit ALU26(result[26],carryOut[26],aluSrc1[26],aluSrc2[26],invertA,invertB,nullAdd,aluOp,carryOut[25],1'b0);
	ALU_1bit ALU27(result[27],carryOut[27],aluSrc1[27],aluSrc2[27],invertA,invertB,nullAdd,aluOp,carryOut[26],1'b0);
	ALU_1bit ALU28(result[28],carryOut[28],aluSrc1[28],aluSrc2[28],invertA,invertB,nullAdd,aluOp,carryOut[27],1'b0);
	ALU_1bit ALU29(result[29],carryOut[29],aluSrc1[29],aluSrc2[29],invertA,invertB,nullAdd,aluOp,carryOut[28],1'b0);
	ALU_1bit ALU30(result[30],carryOut[30],aluSrc1[30],aluSrc2[30],invertA,invertB,nullAdd,aluOp,carryOut[29],1'b0);	
	ALU_1bit ALU31(result[31],carryOut[31],aluSrc1[31],aluSrc2[31],invertA,invertB,nullAdd,aluOp,carryOut[30],1'b0);

endmodule