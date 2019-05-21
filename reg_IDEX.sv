// File to generate a register pipeline for IDEX
// Jesus Abraham Lizarraga Banuelos
// May-12-2018
// reg_IDEX.sv
//

timeunit 1ns;
timeprecision 100ps;

module reg_IDEX
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=3
)
(
 output logic [BIT_WIDTH-1:0] Addresult_4_Jaddress_IDEX, Addresult_4_IDEX,PC_instruction_IDEX,reg_2ALUA_IDEX,reg_2ALUB_IDEX, SignImm_IDEX, 

 input logic  [BIT_WIDTH-1:0] Addresult_4_Jaddress_in, Addresult_4_IFID,PC_instruction_IFID,reg_2ALUA_in,reg_2ALUB_in, SignImm_in, 
 input logic clk,rst,PCEn_out_FLUSH,
//control signals
input logic PCEn_in,branch_in, RegWrite_in, MemWrite_in, jump_in,jregister_in,ALUSrcA_in, ALUSrcB_in,MemtoReg_in,
input logic [1:0] RegDst_in,
input logic [BIT_SEL:0] ALUControl_in,
output logic PCEn_IDEX, RegWrite_IDEX, MemWrite_IDEX, jump_IDEX, jregister_IDEX,ALUSrcA_IDEX,ALUSrcB_IDEX,MemtoReg_IDEX,branch_IDEX,
output logic [1:0] RegDst_IDEX,
output logic [BIT_SEL:0] ALUControl_IDEX

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
    Addresult_4_Jaddress_IDEX<= 32'h00000000;
    Addresult_4_IDEX<= 32'h00000000;
    PC_instruction_IDEX<= 32'h00000000;
    reg_2ALUA_IDEX<= 32'h00000000;
    reg_2ALUB_IDEX<= 32'h00000000;
    SignImm_IDEX<= 32'h00000000;
    //control signals
    PCEn_IDEX<=1'b0;
    RegWrite_IDEX<=1'b0;
    MemWrite_IDEX<=1'b0;
    jump_IDEX<=1'b0;
    jregister_IDEX<=1'b0;
    ALUSrcA_IDEX<=1'b0;
    ALUSrcB_IDEX<=1'b0;
    MemtoReg_IDEX<=1'b0;
    RegDst_IDEX<=2'd0;
    ALUControl_IDEX<=4'd0;
    branch_IDEX<=1'b0;
  end
  else
  begin
    Addresult_4_Jaddress_IDEX<= Addresult_4_Jaddress_in;
    Addresult_4_IDEX<= Addresult_4_IFID;
    PC_instruction_IDEX<= PC_instruction_IFID;
    reg_2ALUA_IDEX<= reg_2ALUA_in;
    reg_2ALUB_IDEX<= reg_2ALUB_in;
    SignImm_IDEX<= SignImm_in;
    //control signals
    PCEn_IDEX<=PCEn_in;
    RegWrite_IDEX<=RegWrite_in;
    MemWrite_IDEX<=MemWrite_in;
    jump_IDEX<=jump_in;
    jregister_IDEX<=jregister_in;
    ALUSrcA_IDEX<=ALUSrcA_in;
    ALUSrcB_IDEX<=ALUSrcB_in;
    MemtoReg_IDEX<=MemtoReg_in;
    RegDst_IDEX<=RegDst_in;
    ALUControl_IDEX<=ALUControl_in;
    branch_IDEX<=branch_in;

  end 
end //always

endmodule
