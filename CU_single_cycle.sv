// Control unit single cycle
// Jesus Abraham Lizarraga Banuelos
// Mar-22-2018
// CU_single_cycle.sv
//

timeunit 1ns;
timeprecision 100ps;

module CU_single_cycle
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=3,
    parameter BIT_CTRL=6
)
(
 input logic clk, rst,
 input logic [BIT_CTRL-1:0] Op,Funct,
// output logic PCWrite,
 output logic RegWrite, Branch,
 output logic MemWrite,
 output logic jump,jregister,
 output logic ALUSrcA,
 output logic ALUSrcB,
 output logic MemtoReg,
 output logic [1:0] RegDst,
 output logic [BIT_SEL:0] ALUControl
);

localparam I_FETCH= 5'd0,I_DECODE= 5'd1,
	   EXE_LUI= 5'd2,WRITE_BACK= 5'd3,
           EXE_ORI= 5'd4, WRITE_SW= 5'd5,
           EXE_ADDI= 5'd6, EXE_SLL= 5'd7,
	   EXE_SW= 5'd8, EXE_BNE= 5'd9,
	   EXE_BNE1= 5'd10, EXE_BNE2= 5'd11,
	   EXE_JAL= 5'd12, EXE_JAL2= 5'd13,
	   EXE_JUMP= 5'd14, EXE_SLTI= 5'd15,
	   EXE_BEQ= 5'd16, EXE_BEQ1= 5'd17,
	   EXE_BEQ2= 5'd18, EXE_JR= 5'd19,
	   EXE_ADDIU= 5'd20, EXE_LW= 5'd21,
           WAIT_LW= 5'd22, READ_LW= 5'd23,
           EXE_MUL=5'd24, WRITE_MUL=5'd25;

logic [4:0] state;
logic f_Op_or_Funct;

assign f_Op_or_Funct=|Op; //if 1 =Op, 0=Funct

always_comb
begin
   if(f_Op_or_Funct) begin //Op 
    case(Op)
     2: state= EXE_JUMP; //JUMP
     3: state= EXE_JAL; //JAL
     4: state= EXE_BEQ; //BEQ
     5: state= EXE_BNE; //BNE
     8: state= EXE_ADDI; //ADDI
     9: state= EXE_ADDIU; //ADDIU
     10: state= EXE_SLTI; //SLTI
     13: state= EXE_ORI; //ORI
     15: state= EXE_LUI; //LUI
     35: state= EXE_LW; //LW
     28: state= EXE_MUL; // MUL
     43: state= EXE_SW; //SW
     default : state= EXE_ADDI;
    endcase
   end else begin // Funct
    case (Funct)
     0: state= EXE_SLL; //SLL
     2: state= EXE_MUL; // MUL
     8: state= EXE_JR; //JR
     default : state= EXE_SLL;
    endcase// Funct
   end
end


always_comb
begin
 Branch=1'b0; 
// PCWrite=1'b0;
 RegWrite=1'b0;
 MemWrite=1'b0;
 ALUSrcA=1'd0;
 ALUSrcB=1'd0;
 ALUControl= 4'd0;
 MemtoReg=1'b0; 
 RegDst=2'd0; 
 jump=1'b0;
 jregister=1'b0;

 case (state)
   //// This instruction works for lui
  EXE_LUI: begin
   ALUSrcA=1'b0;
   ALUSrcB=1'd1;
   ALUControl= 4'd14;
   RegWrite=1'b1;
//   PCWrite=1'b1; // FETCH
  end // case EXE_LUI

   //// This instruction works for ori
  EXE_ORI: begin
   ALUSrcB=1'd1;
   ALUControl= 4'd3;
   RegWrite=1'b1;
//   PCWrite=1'b1; // FETCH  
  end // case EXE_ORI

   //// This instruction works for ADDI
  EXE_ADDI: begin
   ALUSrcB=1'd1;
   ALUControl= 4'd0;
   RegWrite=1'b1; // Write Back
//   PCWrite=1'b1; // FETCH  
  end // case EXE_ADDI

  EXE_MUL: begin
   ALUControl= 4'd9;
   RegDst=2'd1;
   RegWrite=1'b1; // Write Back
//   PCWrite=1'b1; // FETCH  
  end // case EXE_MUL

  EXE_ADDIU: begin
   ALUSrcB=1'd1;
   ALUControl= 4'd0;
   RegWrite=1'b1; // Write Back
//   PCWrite=1'b1; // FETCH  
  end // case EXE_ADDIU

   //// This instruction works for SW
  EXE_SW: begin
   ALUSrcB=1'd1;
   ALUControl= 4'd0; //ADD rs+ imm
   MemWrite=1'b1; // Store RAM
//   PCWrite=1'b1; // FETCH  

  end // case EXE_SW

  EXE_LW: begin
   ALUSrcB=1'd1;
   ALUControl= 4'd0;//ADD rs+ imm
   MemtoReg=1'b1;
   RegWrite=1'b1; // Write Back
//   PCWrite=1'b1; // FETCH  
  end // case EXE_LW

   //// This instruction works for SLL
  EXE_SLL: begin
   ALUSrcA=1'd1;
   ALUControl= 4'd5;
   RegWrite=1'b1; // Write Back
//   PCWrite=1'b1; // FETCH  
   RegDst=2'd1;
  end // case EXE_SLL

  EXE_BNE: begin
//   PCWrite=1'b1;
   Branch=1'b1;
   ALUControl= 4'd11;
  end //  case EXE_BNE

  EXE_BEQ: begin
   Branch=1'b1;
   ALUControl= 4'd10;
//   PCWrite=1'b1;
  end //  case EXE_BEQ

  EXE_JR: begin
   ALUControl= 4'd13;
   jregister=  1'b1;
//   PCWrite=    1'b1;
  end // case EXE_JR

  EXE_JUMP: begin
//   PCWrite=1'b1;
   jump=1'b1; 
  end // case EXE_JUMP

  EXE_JAL:begin
   jump=1'b1; 
//   PCWrite=1'b1;
   RegDst=2'd2;
   RegWrite=1'b1; // Write Back
  end // case EXE_JAL

  EXE_SLTI: begin
   ALUControl= 4'd4;
   ALUSrcB=1'b1;
   RegWrite=1'b1;
//   PCWrite=1'b1; // FETCH  
  end // case EXE_SLTI

//   RegDst={1'b0,~|Op} ; //I = 0 , R = 1

  endcase
 end //always

endmodule

