// File to generate a register pipeline for EXMEM
// Jesus Abraham Lizarraga Banuelos
// May-12-2018
// reg_EXMEM.sv
//

timeunit 1ns;
timeprecision 100ps;

module reg_EXMEM
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=3
)
(
 output logic [BIT_WIDTH-1:0] Addresult_4_Jaddress_EXMEM,Addresult2_j_EXMEM,SrcA_EXMEM,ALUResult_EXMEM,Zero_EXMEM,reg_2ALUB_EXMEM,mux_regWriteA3_EXMEM,PC_instruction_EXMEM,Addresult_4_EXMEM,
 input logic  [BIT_WIDTH-1:0] Addresult_4_IDEX,Addresult_4_Jaddress_IDEX,Addresult2_j_in,SrcA_in,ALUResult_in,Zero_in,reg_2ALUB_IDEX,mux_regWriteA3_in, PC_instruction_IDEX,
 input logic clk,rst,PCEn_out_FLUSH,

//control signals
input logic PCEn_IDEX, RegWrite_IDEX, MemWrite_IDEX, jump_IDEX,jregister_IDEX,MemtoReg_IDEX,branch_IDEX,
input logic [1:0] RegDst_IDEX,
output logic PCEn_EXMEM, RegWrite_EXMEM, MemWrite_EXMEM, jump_EXMEM, jregister_EXMEM,MemtoReg_EXMEM,branch_EXMEM,
output logic [1:0] RegDst_EXMEM

);
logic reset;

always_comb
 begin
  reset=!rst | PCEn_out_FLUSH;
 end
 
always_ff @(negedge clk) // pipeline is negedge
begin
 if (reset)
  begin
    PC_instruction_EXMEM<= 32'h00000000;
    Addresult_4_Jaddress_EXMEM<= 32'h00000000;
    Addresult2_j_EXMEM<= 32'h00000000;
    SrcA_EXMEM<= 32'h00000000;
    ALUResult_EXMEM<= 32'h00000000;
    Zero_EXMEM<= 32'h00000000;
    reg_2ALUB_EXMEM<= 32'h00000000;
    mux_regWriteA3_EXMEM<= 32'h00000000;
    Addresult_4_EXMEM<= 32'h00000000;
    //control signals
    PCEn_EXMEM<=1'b0;
    RegWrite_EXMEM<=1'b0;
    MemWrite_EXMEM<=1'b0;
    jump_EXMEM<=1'b0;
    jregister_EXMEM<=1'b0;
    MemtoReg_EXMEM<=1'b0;
    RegDst_EXMEM<=2'd0;
    branch_EXMEM<=1'b0;
  end
  else
  begin
    Addresult_4_Jaddress_EXMEM<= Addresult_4_Jaddress_IDEX;
    Addresult2_j_EXMEM<= Addresult2_j_in;
    SrcA_EXMEM<= SrcA_in;
    ALUResult_EXMEM<= ALUResult_in;
    Zero_EXMEM<= Zero_in;
    reg_2ALUB_EXMEM<=reg_2ALUB_IDEX;
    mux_regWriteA3_EXMEM<=mux_regWriteA3_in;
    Addresult_4_EXMEM<=Addresult_4_IDEX;
    //control signals
    PCEn_EXMEM<=PCEn_IDEX;
    RegWrite_EXMEM<=RegWrite_IDEX;
    MemWrite_EXMEM<=MemWrite_IDEX;
    jump_EXMEM<=jump_IDEX;
    jregister_EXMEM<=jregister_IDEX;
    MemtoReg_EXMEM<=MemtoReg_IDEX;
    RegDst_EXMEM<=RegDst_IDEX;
    branch_EXMEM<=branch_IDEX;
    PC_instruction_EXMEM<=PC_instruction_IDEX;
  end 
end //always

endmodule
