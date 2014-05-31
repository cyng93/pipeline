module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//__Stage1 (IF)___________________________________________________
// Below for Mux for jump feature
//wire [32-1:0] PC_src2;						//Mux for Branch & PC+4

// Mux2to1 #(.size(32)) Mux_PC_next(
		// .data0_i(PC_src2),
		// .data1_i(jump_addr),
		// //.data2_i(ReadData1),
		// .select_i(Jump),
		// .data_o(PC_next)
		// );

wire [5-1:0] decoder_3;
wire branchMux_o_2;
wire [32-1:0] PC_plus4_1;					//Adder

wire PCSrc;											//Select for Mux between branch_addr & PC+4
assign PCSrc = decoder_3[2] && branchMux_o_2;
wire [32-1:0] PC_src2;
wire [32-1:0] branch_addr_2;
Mux2to1 #(.size(32)) Mux_branch_PCplus4(
        .data0_i(PC_plus4_1),				//0: PC+4
        .data1_i(branch_addr_2),		//1: branch_addr
        .select_i(PCSrc),
        .data_o(PC_src2)
        );
		
wire Jump_2;
wire flush3reg;
assign flush3reg = ( PCSrc || Jump_2 );

wire [32-1:0] PC_current;					//Program Counter	

wire [32-1:0] jump_addr_3;
wire [32-1:0] PC_next;						//Mux for Jump &  jr & branch_addr(include PC+4)
Mux2to1 #(.size(32)) MuxJumpORBranch(
        .data0_i(PC_src2),				//0: PC+4
        .data1_i(jump_addr_3),		//1: branch_addr
        .select_i(Jump_2),
        .data_o(PC_next)
        );

wire PCWrite;
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(PC_next) ,   
	    .pc_out_o(PC_current),
		.PCWrite( PCWrite )
	    );

Adder Adder1(
       .src1_i(PC_current),     
	    .src2_i(32'd4),
	    .sum_o(PC_plus4_1)    
	    );
	
wire [32-1:0] instr_1;
Instr_Memory IM(
		.pc_addr_i(PC_current),  
		.instr_o(instr_1)
);

wire [32-1:0] instr_2;					//Instruction Memory
wire [32-1:0] PC_plus4_2;
wire IIWrite;
reg_IF_ID REG1(
        .clk_i(clk_i),      
	    .rst_n(rst_n),  
		.flushreg_i( flush3reg ),
		.IIWrite( IIWrite ),
		.PC_plus4_i(PC_plus4_1),
		.instruction_i(instr_1),
		.PC_plus4_o(PC_plus4_2),
		.instruction_o(instr_2)
		);

//__Stage2 ( ID )___________________________________________________
wire [11-1:0] decoder_1;
Decoder Decoder(
        .instr_op_i(instr_2[31:26]),
		
		.RegWrite_o(decoder_1[0]), 
		.MemtoReg_o(decoder_1[1]),
		
		.Branch_o(decoder_1[2]),
		.MemRead_o(decoder_1[3]),
		.MemWrite_o(decoder_1[4]),
		
		.ALUSrc_o(decoder_1[5]),
		.ALUOp_o(decoder_1[8:6]),
	    .RegDst_o(decoder_1[9]),
		.BranchType_o(decoder_1[10])
		);

wire ControlFlush;
wire [11-1:0] decoder_2;
wire [21-1:0] instr_3;
HazardDectection_Unit HazardDectectionUnit(
	.IE_memread( decoder_2[3] ) , 
	.IE_rt( instr_3[20:16] ), 
	.II_rs( instr_2[25:21] ), 
	.II_rt( instr_2[20:16] ), 
	.PCWrite( PCWrite ), 
	.IIWrite( IIWrite ), 
	.ControlFlush( ControlFlush )
	);

wire [11-1:0] MuxControlFlush_o;
Mux2to1 #(.size(11)) MuxContorlFlush(
        .data0_i(decoder_1),				
        .data1_i(11'd0),	
        .select_i( ControlFlush ),
        .data_o( MuxControlFlush_o )
        );
		
		
wire [2-1:0] decoder_4;
wire [32-1:0] ReadData1_1, ReadData2a_1;
wire [32-1:0] DataToWrite;
wire [5-1:0] instr_5;
Reg_File RF(
        .clk_i(clk_i),      
	     .rst_n(rst_n) ,     
        .RSaddr_i(instr_2[25:21]) ,  
        .RTaddr_i(instr_2[20:16]) ,  
        .Wrtaddr_i(instr_5) , 
        .Wrtdata_i(DataToWrite) , 
        .RegWrite_i(decoder_4[0]),
        .RSdata_o(ReadData1_1) ,  
        .RTdata_o(ReadData2a_1)   
        );

wire [32-1:0] ReadData2b_1;
Sign_Extend SE(
        .data_i(instr_2[15:0]),
        .data_o(ReadData2b_1)
        );
		
		
wire [32-1:0] zerofilled_result_1;
Zero_Filled ZF(
        .data_i(instr_2[15:0]),
        .data_o(zerofilled_result_1)
        );

wire [32-1:0] jump_addr_1, jump_addr_2;
	assign jump_addr_1 =  {PC_plus4_2[31:28],instr_2[25:0],2'b00};	
wire [5-1:0]	rs_o;
wire [32-1:0] PC_plus4_3;
wire [32-1:0] ReadData1_2, ReadData2a_2, ReadData2b_2, zerofilled_result_2;
reg_ID_EX REG2(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
		.flushreg_i( flush3reg ),
		.decoder_i(MuxControlFlush_o), 
		.PC_plus4_i(PC_plus4_2), 
		.ReadData1_i(ReadData1_1),
		.ReadData2_i(ReadData2a_1),
		.signed_extension_i(ReadData2b_1),
		.zero_filled_i(zerofilled_result_1), 
		.instruction_i(instr_2[20:0]),
		.rs_i( instr_2[25:21] ),
		.jump_addr_i( jump_addr_1 ),
		.decoder_o(decoder_2), 
		.PC_plus4_o(PC_plus4_3), 
		.ReadData1_o(ReadData1_2), 
		.ReadData2_o(ReadData2a_2),
		.signed_extension_o(ReadData2b_2), 
		.zero_filled_o(zerofilled_result_2),
		.instruction_o(instr_3),
		.rs_o( rs_o ),
		.jump_addr_o( jump_addr_2 )
);

 //__Stage3 ( EX )___________________________________________________



wire [32-1:0] immed_x4;					//shiftleft2	
assign immed_x4 = ReadData2b_2 << 2;
wire [32-1:0] branch_addr_1;
Adder Adder2(
       .src1_i(PC_plus4_3),     
	   .src2_i(immed_x4),
	   .sum_o(branch_addr_1)    
	    );


wire [5-1:0] ALU_operation;				//ALU Control(5bit)
wire [2-1:0] FURslt;
wire shamt_mux;								//Mux of shift amount		
wire Jump_1;
 ALU_Ctrl AC(
        .funct_i(instr_3[5:0]),   
        .ALUOp_i(decoder_2[8:6]),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt),
		.shamt_o(shamt_mux),
		.Jump_o(Jump_1)
        );

wire [32-1:0] shifter_result;				//Shifter
wire [32-1:0] shifter_amt;					//Shift amount
wire [32-1:0] new_shamt;
assign new_shamt = {27'd0,instr_3[10:6]};
Mux2to1 #(.size(32)) Mux_ShiftAmt_Reg(
        .data0_i(ReadData1_2),				//0: rs
        .data1_i(new_shamt),					//1: shamt
        .select_i(shamt_mux),
        .data_o(shifter_amt)
        );



wire [2-1:0] forwardA, forwardB, forwardC;
wire [5-1:0] instr_4;
Forwarding_Unit ForwardingUnit( 
	.EM_registertowrite(instr_4), 
	.MW_registertowrite(instr_5), 
	.EM_writeback(decoder_3[0]), 
	.MW_writeback(decoder_4[0]), 
	.IE_rs( rs_o ), 
	.IE_rt( instr_3[20:16] ), 
	.forwardA( forwardA ), 
	.forwardB( forwardB ),
	.forwardC( forwardC )
	);

wire [32-1:0] FUmux_o_2;	
wire [32-1:0] MuxforwardA_o;
Mux3to1 #(.size(32)) MuxforwardA(
      .data0_i(ReadData1_2),
	  .data1_i(DataToWrite),
      .data2_i(FUmux_o_2),
      .select_i(forwardA),
      .data_o(MuxforwardA_o)
        );		
		

wire [32-1:0] MuxforwardB_o;
Mux3to1 #(.size(32)) MuxforwardB(
      .data0_i(ReadData2a_2),
	  .data1_i(DataToWrite),
      .data2_i(FUmux_o_2),
      .select_i( forwardB ),
      .data_o( MuxforwardB_o )
        );			
		
wire [32-1:0] MuxforwardC_o;
Mux3to1 #(.size(32)) MuxforwardC(
      .data0_i( ReadData2a_2 ),
	  .data1_i( DataToWrite ),
      .data2_i( FUmux_o_2 ),
      .select_i( forwardC ),
      .data_o( MuxforwardC_o )
        );
		
wire [32-1:0] ALUSrc2;						//Mux for ALU Source2		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(MuxforwardB_o),
        .data1_i(ReadData2b_2),
        .select_i(decoder_2[5]),
        .data_o(ALUSrc2)
        );	
		
Shifter shifter( 
		.result(shifter_result), 
		.leftRight(ALU_operation[0]),
		.shamt(shifter_amt),
		.sftSrc(ALUSrc2)
		);

wire [32-1:0] ALU_result;					//ALU (32bit)
wire ALU_zero, ALU_overflow;			//ALU (1bit)		
ALU ALU(
		.aluSrc1(MuxforwardA_o),
	    .aluSrc2( ALUSrc2 ),
	    .ALU_operation_i(ALU_operation),
		.result(ALU_result),
		.zero(ALU_zero),
		.overflow(ALU_overflow)
	    );

wire [32-1:0] FUmux_o_1;						//Mux for ALUresult, shifter result, signedextend
Mux3to1 #(.size(32)) Mux_FU(
      .data0_i(ALU_result),
      .data1_i(shifter_result),
	  .data2_i(zerofilled_result_2),
      .select_i(FURslt),
      .data_o(FUmux_o_1)
        );			

wire [5-1:0] RegisterToWrite;				//Mux for Write Register
wire RegDst;
 Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_3[20:16]),	//0: rt
        .data1_i(instr_3[15:11]),	//1: rd
       // .data2_i(5'd31),					//1: $ra
        .select_i(decoder_2[9]),
        .data_o(RegisterToWrite)
        );
 

wire branchMux_o_1;								//Mux for beq & bne
Mux2to1 #(.size(1)) Mux_branchtype(
      .data0_i(ALU_zero),
      .data1_i(!ALU_zero),
      .select_i(decoder_2[10]),
      .data_o(branchMux_o_1)
        );		

wire [32-1:0] ReadData2a_3;
 reg_EX_MEM  REG3(
        .clk_i(clk_i),      
	    .rst_n(rst_n),    
		.flushreg_i( flush3reg ),
		.decoder_i(decoder_2[4:0]),
		.PC_plus4_i(branch_addr_1), 
		.zero_i(branchMux_o_1), 
		.FURslt_i(FUmux_o_1), 
		.ReadData2_i(MuxforwardC_o), 
		.instruction_i(RegisterToWrite),
		.jump_addr_i( jump_addr_2 ),
		.jump_i( Jump_1 ),
		.decoder_o(decoder_3),
		.PC_plus4_o(branch_addr_2), 
		.zero_o(branchMux_o_2), 
		.FURslt_o(FUmux_o_2), 
		.ReadData2_o(ReadData2a_3), 
		.instruction_o(instr_4),
		.jump_addr_o ( jump_addr_3 ),
		.jump_o( Jump_2 )
);
 
  //__Stage4 ( Mem )___________________________________________________
  
wire [32-1:0]	MemMuxSrc1_1;				//Mux for PC+4, Data from memory, FUTslt
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(FUmux_o_2),
		.data_i(ReadData2a_3),
		.MemRead_i(decoder_3[3]),
		.MemWrite_i(decoder_3[4]),
		.data_o(MemMuxSrc1_1)
		);


wire [32-1:0] MemMuxSrc1_2;
wire [32-1:0] MemMuxSrc0;
reg_MEM_WB  REG4(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
		.decoder_i(decoder_3[1:0]), 
		.MemReadData_i(MemMuxSrc1_1), 
		.FURslt_i(FUmux_o_2),
		.instruction_i(instr_4),
		.decoder_o(decoder_4),
		.MemReadData_o(MemMuxSrc1_2), 
		.FURslt_o(MemMuxSrc0),
		.instruction_o(instr_5) 
);
		

 //__Stage5 ( WB )___________________________________________________

Mux2to1 #(.size(32)) Mux_DataToWrite(
        .data0_i(MemMuxSrc0),
        .data1_i(MemMuxSrc1_2),	
        //.data2_i(PC_plus4),					
        .select_i(decoder_4[1]),
        .data_o(DataToWrite)
        );	
		
endmodule