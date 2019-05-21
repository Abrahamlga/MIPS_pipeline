
// File to generate a register pipeline for IFID
// Jesus Abraham Lizarraga Banuelos
// May-12-2018
// reg_IFID.sv
//

timeunit 1ns;
timeprecision 100ps;

module reg_IFID
#(
    parameter BIT_WIDTH=32
)
(
 output logic [BIT_WIDTH-1:0] Addresult_4_IFID, PC_instruction_IFID,
 input logic  [BIT_WIDTH-1:0] Addresult_4_in, PC_instruction_in,
 input logic clk,rst,Write_IFID,PCEn_out_FLUSH
);

always_ff @(negedge clk, negedge rst) // pipeline is negedge
begin
  if (!rst) //PCEn_out_FLUSH
   begin
     Addresult_4_IFID <= 32'h00000000;
     PC_instruction_IFID <= 32'h00000000;
   end
   else if (Write_IFID)
   begin
      Addresult_4_IFID<= Addresult_4_in;
      PC_instruction_IFID<=PC_instruction_in;
   end 
end //always

endmodule
