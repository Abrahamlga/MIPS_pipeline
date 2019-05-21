// Forwarding unit
// Jesus Abraham Lizarraga Banuelos
// May-18-2019
// Forwarding_unit.sv
//


timeunit 1ns;
timeprecision 100ps;

module Forwarding_unit
#(
    parameter BIT_WIDTH=32
)
(
// output logic [BIT_WIDTH-1:0] SrcB_FWDU, SrcA_FWDU,
 output logic [1:0] setA, setB,
 input logic  [BIT_WIDTH-1:0] PC_instruction_IDEX, PC_instruction_EXMEM, PC_instruction_MEMWB, 
 input logic RegWrite_EXMEM,RegWrite_MEMWB
);

always_comb
begin

 setA=2'b00;
 setB=2'b00;
//   .Op(PC_instruction_IDEX[31:26]),
// .Funct(PC_instruction_IDEX[5:0])



 if(PC_instruction_EXMEM[5:0]!=0 || PC_instruction_MEMWB[5:0]!=0)
 begin
   ///Verify read_data 1 (A) at EX forward unit
  if(RegWrite_EXMEM & (PC_instruction_EXMEM[15:11] == PC_instruction_IDEX[25:21]))
  begin
   //PC_instruction_EXMEM[15:11];//RS   -- RD
    setA=2'b10;
  end
    ///Verify read_data 2 (B) at  EX forward unit
  if(RegWrite_EXMEM & (PC_instruction_EXMEM[15:11] == PC_instruction_IDEX[20:16]))
  begin
   //PC_instruction_EXMEM[20:16]; //RT -- RD
   setB=2'b10;
  end

    ///Verify read_data 1 (A) at MEM Forward unit
  if(RegWrite_MEMWB & (PC_instruction_MEMWB[15:11] == PC_instruction_IDEX[25:21]) & ((PC_instruction_EXMEM[15:11] != PC_instruction_IDEX[25:21])))
  begin
   //PC_instruction_MEMWB[15:11];//RS -- RD
    setA=2'b01;
  end
    ///Verify read_data 2 (B) at MEM Forward unit
  if(RegWrite_MEMWB & (PC_instruction_MEMWB[15:11] == PC_instruction_IDEX[20:16]) & ((PC_instruction_EXMEM[15:11] != PC_instruction_IDEX[20:16])))
  begin
   //PC_instruction_MEMWB[20:16];//RT -- RD
    setB=2'b01;
  end
 
 end //(function RD output) 

//-----------------------------------------------------------------------------------------
 
 if(setA==0 && setB==0 && (|PC_instruction_EXMEM[31:26] || |PC_instruction_MEMWB[31:26])) //opcode Rt output
 begin 
  ///Rt--------------------------
  if(RegWrite_EXMEM & (PC_instruction_EXMEM[20:16] == PC_instruction_IDEX[25:21]))
  begin
   //PC_instruction_EXMEM[20:16];//RS   -- RT
    setA=2'b10;
  end
    ///Verify read_data 2 (B) at  EX forward unit
  if(RegWrite_EXMEM & (PC_instruction_EXMEM[20:16] == PC_instruction_IDEX[20:16]))
  begin
   //PC_instruction_EXMEM[20:16]; //RT -- RT
   setB=2'b10;
  end

    ///Verify read_data 1 (A) at MEM Forward unit
  if(RegWrite_MEMWB & (PC_instruction_MEMWB[20:16] == PC_instruction_IDEX[25:21]) & ((PC_instruction_EXMEM[20:16] != PC_instruction_IDEX[25:21])))
  begin
   //PC_instruction_MEMWB[20:16];//RS -- RT
    setA=2'b01;
  end
    ///Verify read_data 2 (B) at MEM Forward unit
  if(RegWrite_MEMWB & (PC_instruction_MEMWB[20:16] == PC_instruction_IDEX[20:16]) & ((PC_instruction_EXMEM[20:16] != PC_instruction_IDEX[20:16])))
  begin
   //PC_instruction_MEMWB[20:16];//RT -- RT
    setB=2'b01;
  end
 end //opcode Rt output

end //always_comb

endmodule



