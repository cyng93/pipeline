module ALU_1bit( result, carryOut, a, b, invertA, invertB, nullAdd, aluOp, carryIn, less );
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire nullAdd;
  input wire[1:0] aluOp;
  input wire carryIn;
  input wire less;
  
  /* addition + subtraction + not */ 
	wire F1_sum, F1_cout;
	wire Not_a,Not_b,a_t,b_t,b_tt;
	not Not1(Not_a,a);
	not Not2(Not_b,b);
	assign a_t = (invertA==1)?Not_a:a;
	assign b_t = (invertB==1)?Not_b:b;
	assign b_tt = (nullAdd==1)?0:b_t;
	Full_adder F1(F1_sum,F1_cout,carryIn,a_t,b_tt);

	/* And */
	wire And1_and;
	and And1(And1_and,a,b);

	/* Or */
	wire Or1_or;
	or Or1(Or1_or,a,b);
	
  assign result=(aluOp==2'b00)?And1_and:
								(aluOp==2'b01)?Or1_or:
								(aluOp==2'b10)?F1_sum:
								less; //set on less than
	assign carryOut=(aluOp==2'b10)?F1_cout:0;

endmodule