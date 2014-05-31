module HazardDectection_Unit ( IE_memread, IE_rt, II_rs, II_rt, PCWrite, IIWrite, ControlFlush );

input wire IE_memread;
input wire [5-1:0] IE_rt, II_rs, II_rt;

output wire PCWrite, IIWrite, ControlFlush;

assign PCWrite = ( IE_memread && (IE_rt==II_rs || IE_rt==II_rt ) )? 0 : 1;
assign IIWrite = ( IE_memread && (IE_rt==II_rs || IE_rt==II_rt ) )? 0 : 1;
assign ControlFlush = ( IE_memread && (IE_rt==II_rs || IE_rt==II_rt ) )? 1 : 0;

endmodule 