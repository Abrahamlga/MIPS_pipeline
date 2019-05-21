// File to generate a register pipeline for MEMWB
// Jesus Abraham Lizarraga Banuelos
// May-12-2018
// reg_MEMWB.sv
//

timeunit 1ns;
timeprecision 100ps;

module reg_MEMWB
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=3
)
(
 output logic [BIT_WIDTH-1:0] Read_Data_RAM_MEMWB, ALUResult_MEMWB, mux_regWriteA3_MEMWB,PC_instruction_MEMWB,Addresult_4_MEMWB,
 input logic  [BIT_WIDTH-1:0] Read_Data_RAM_in, ALUResult_EXMEM, mux_regWriteA3_EXMEM,PC_instruction_EXMEM,Addresult_4_EXMEM,
 input logic clk,rst,

//control signals
input logic RegWrite_EXMEM, MemtoReg_EXMEM,
input logic [1:0] RegDst_EXMEM,
output logic  RegWrite_MEMWB, MemtoReg_MEMWB,
output logic [1:0] RegDst_MEMWB

);

always_ff @(negedge clk, negedge rst) // pipeline is negedge
begin
 if (!rst)
  begin
    PC_instruction_MEMWB<= 32'h00000000;
    Read_Data_RAM_MEMWB<= 32'h00000000;
    ALUResult_MEMWB<= 32'h00000000;
    mux_regWriteA3_MEMWB<= 32'h00000000;
    Addresult_4_MEMWB<=32'h00000000;

    //control signals
    RegWrite_MEMWB<=1'b0;
    MemtoReg_MEMWB<=1'b0;
    RegDst_MEMWB<=2'd0;
  end
  else
  begin
    Read_Data_RAM_MEMWB<= Read_Data_RAM_in;
    ALUResult_MEMWB<= ALUResult_EXMEM;
    mux_regWriteA3_MEMWB<= mux_regWriteA3_EXMEM;
    Addresult_4_MEMWB<=Addresult_4_EXMEM;
   //controls signals
    RegWrite_MEMWB<=RegWrite_EXMEM;
    MemtoReg_MEMWB<=MemtoReg_EXMEM;
    RegDst_MEMWB<=RegDst_EXMEM;
    PC_instruction_MEMWB<=PC_instruction_EXMEM;
  end 
end //always

endmodule
