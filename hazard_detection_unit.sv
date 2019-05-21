// Hazard detection unit
// Jesus Abraham Lizarraga Banuelos
// May-18-2019
// hazard_detection_unit.sv
//


timeunit 1ns;
timeprecision 100ps;

module hazard_detection_unit
#(
    parameter BIT_WIDTH=32
)
(
 output logic set_HDU,PCWrite,Write_IFID,
 input logic  [BIT_WIDTH-1:0] PC_instruction_IDEX, PC_instruction_IFID,
 input logic MemtoReg_IDEX
);

always_comb
begin

 set_HDU=1'b0;
 PCWrite=1'b1;
 Write_IFID=1'b1;
// Condition for Hazard detection unit
 if(MemtoReg_IDEX & ((PC_instruction_IDEX[20:16] == PC_instruction_IFID[25:21]) | (PC_instruction_IDEX[20:16] == PC_instruction_IFID[20:16])))
 begin
  set_HDU=1'b1; //sent 0 to all the control units around the pipe
  PCWrite=1'b0;
  Write_IFID=1'b0;
 end

end

endmodule



