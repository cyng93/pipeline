module Forwarding_Unit( EM_registertowrite, MW_registertowrite, EM_writeback, MW_writeback, IE_rs, IE_rt, forwardA, forwardB, forwardC );

input wire [5-1:0] EM_registertowrite, MW_registertowrite, IE_rs, IE_rt;
input EM_writeback, MW_writeback;

output wire [2-1:0] forwardA, forwardB, forwardC;

assign forwardA = 	
	( EM_writeback && EM_registertowrite!=0 && EM_registertowrite==IE_rs )? 2'b10:
	( (MW_writeback && MW_registertowrite!=0 && MW_registertowrite==IE_rs) && !(EM_writeback && EM_registertowrite!=0 && EM_registertowrite==IE_rs) )? 2'b01:
	2'b00;
	
assign forwardB =
	( EM_writeback && EM_registertowrite!=0 && EM_registertowrite==IE_rt )? 2'b10:
	( (MW_writeback && MW_registertowrite!=0 && MW_registertowrite==IE_rt) && !(EM_writeback && EM_registertowrite!=0 && EM_registertowrite==IE_rt) )? 2'b01:
	2'b00;
	
assign forwardC = 
	( ( IE_rt == EM_registertowrite ) && EM_writeback && EM_registertowrite != 0 )? 2'b10:
	( !( ( IE_rt == EM_registertowrite ) && EM_writeback && EM_registertowrite != 0 ) && ( IE_rt == MW_registertowrite ) && MW_writeback && MW_registertowrite!=0 )? 2'b01:
	2'b00;

endmodule 