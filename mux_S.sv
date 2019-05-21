// File to select 1 output with 2 inputs (special cases)
// Jesus Abraham Lizarraga Banuelos
// May-19-2018
// mux_S.sv
//

timeunit 1ns;
timeprecision 100ps;

module mux_S
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=3
)
(
//control signals
  output logic PCEn_out_HD,branch_out_HD, RegWrite_out_HD, MemWrite_out_HD, jump_out_HD,jregister_out_HD,ALUSrcA_out_HD, ALUSrcB_out_HD,MemtoReg_out_HD,
  output logic [1:0] RegDst_out_HD,
  output logic [BIT_SEL:0] ALUControl_out_HD,

  input logic PCEn_in_HD,branch_in_HD, RegWrite_in_HD, MemWrite_in_HD, jump_in_HD,jregister_in_HD,ALUSrcA_in_HD, ALUSrcB_in_HD,MemtoReg_in_HD,
  input logic [1:0] RegDst_in_HD,
  input logic [BIT_SEL:0] ALUControl_in_HD,
  input logic sel
 
);

always_comb
begin
 if(sel) begin
  PCEn_out_HD=1'b0;
  branch_out_HD=1'b0 ;
  RegWrite_out_HD=1'b0; 
  MemWrite_out_HD=1'b0; 
  jump_out_HD=1'b0;
  jregister_out_HD=1'b0;
  ALUSrcA_out_HD=1'b0; 
  ALUSrcB_out_HD=1'b0;
  MemtoReg_out_HD=1'b0;
  RegDst_out_HD=2'h0;
  ALUControl_out_HD=3'h0;
 end
 else begin
  PCEn_out_HD=PCEn_in_HD;
  branch_out_HD=branch_in_HD ;
  RegWrite_out_HD=RegWrite_in_HD; 
  MemWrite_out_HD=MemWrite_in_HD; 
  jump_out_HD=jump_in_HD;
  jregister_out_HD=jregister_in_HD;
  ALUSrcA_out_HD=ALUSrcA_in_HD; 
  ALUSrcB_out_HD=ALUSrcB_in_HD;
  MemtoReg_out_HD=MemtoReg_in_HD;
  RegDst_out_HD=RegDst_in_HD;
  ALUControl_out_HD=ALUControl_in_HD;

 end
end

endmodule
