
// MIPS Architecture Single-Cycle Processor
// Jesus Abraham Lizarraga Banuelos
// Apr-17-2019
// MIPS_arch_single.sv
//

timeunit 1ns;
timeprecision 100ps;

module MIPS_arch_pipeline
#(
   parameter BIT_WIDTH=32,
   parameter REG_WIDTH = $clog2(BIT_WIDTH),
   parameter BIT_SEL=3,
   parameter BIT_CTRL=5
)
(
  input logic clk, rst,
  input logic W_UART,
  input logic [BIT_WIDTH-1:0] UART_DATA,
  output logic [BIT_WIDTH-1:0] UART_RX
);

logic [BIT_WIDTH-1:0] pc_rom, Addresult_4, Addresult2_j,PC_instruction, mux4_Add1,mux8_mux3PC,mux3_PC, reg_2ALUA,reg_2ALUB,mux_regWD3,mux7_selregWD3, SignImm, Jaddress, Shifl2_out, mux_bench_out, SrcB,SrcA,ALUResult, Read_Data_RAM,FWDU_SrcB,FWDU_SrcA;

//pipeline IFID
logic [BIT_WIDTH-1:0] Addresult_4_IFID, PC_instruction_IFID;
//pipeline IDEX
logic [BIT_WIDTH-1:0] Addresult_4_Jaddress_IDEX, Addresult_4_IDEX,PC_instruction_IDEX,reg_2ALUA_IDEX,reg_2ALUB_IDEX, SignImm_IDEX, mux_regWriteA3_IDEX,PC_instruction_EXMEM,PC_instruction_MEMWB;
  //control signals
logic PCEn_IDEX, RegWrite_IDEX, MemWrite_IDEX, jump_IDEX, jregister_IDEX,ALUSrcA_IDEX,ALUSrcB_IDEX,MemtoReg_IDEX;
logic [1:0] RegDst_IDEX;
logic [BIT_SEL:0] ALUControl_IDEX;
//pipeline EXMEM
logic [BIT_WIDTH-1:0] Addresult_4_EXMEM,Addresult_4_Jaddress_EXMEM,Addresult2_j_EXMEM,SrcA_EXMEM,ALUResult_EXMEM,Zero_EXMEM,reg_2ALUB_EXMEM,mux_regWriteA3_EXMEM;
logic PCEn_EXMEM, RegWrite_EXMEM, MemWrite_EXMEM, jump_EXMEM, jregister_EXMEM,MemtoReg_EXMEM;
logic [1:0] RegDst_EXMEM;
//pipeline MEMWB
logic [BIT_WIDTH-1:0] Addresult_4_MEMWB,Read_Data_RAM_MEMWB, ALUResult_MEMWB, mux_regWriteA3_MEMWB,mux_regWriteA3_MEMWB_j;
logic  RegWrite_MEMWB, MemtoReg_MEMWB;
logic [1:0] RegDst_MEMWB;

logic [REG_WIDTH-1:0] mux_regWriteA3;
logic PCEn,RegWrite,MemtoReg,ALUSrcA, ALUSrcB;
logic [1:0] RegDst;
logic jump,jregister;
logic MemWrite, PCWrite;
logic Zero, branch,branch_IDEX,branch_EXMEM;
logic [BIT_SEL:0] ALUControl;

//FWDU
logic [1:0] setA, setB;
//Branch FLUSHES
logic PCEn_out_FLUSH;

//Hazard detection unit
 logic PCEn_out_HD,branch_out_HD, RegWrite_out_HD, MemWrite_out_HD, jump_out_HD,jregister_out_HD,ALUSrcA_out_HD, ALUSrcB_out_HD,MemtoReg_out_HD,set_HDU;
 logic [1:0] RegDst_out_HD;
 logic [BIT_SEL:0] ALUControl_out_HD;
 logic Write_IFID;


pc_reg pc
(
 .Read_Data(pc_rom),
 .Write_Data(mux3_PC),
 .en(PCWrite), //ignore PCWrite pending
 .clk(clk),
 .rst(rst)
);

Add Add1_4
(
 .AddResult(Addresult_4),
 .SrcA(pc_rom),
 .SrcB(32'h4)
);

mux_2 mux3_bench
(
 .Mux_out(mux3_PC),
 .Mux_in0(Addresult_4),
 .Mux_in1(mux8_mux3PC),
 .sel(PCEn)
);

mem_arch_ROM mem_arch_ROM1
(
 .Read_Data_out(PC_instruction),
 .Address_in(pc_rom)
);

//PIPELINE IF/ID
reg_IFID pipeline_reg_IFID
(
 .Addresult_4_IFID(Addresult_4_IFID),
 .PC_instruction_IFID(PC_instruction_IFID),
 .Addresult_4_in(Addresult_4),
 .PC_instruction_in(PC_instruction),
 .clk(clk),
 .rst(rst),
 .Write_IFID(Write_IFID),
 .PCEn_out_FLUSH(1'b0)
);

register_file reg_file
(
 .Read_Data_1(reg_2ALUA),
 .Read_Data_2(reg_2ALUB),		
 .Write_Data(mux7_selregWD3),
 .Write_reg(mux_regWriteA3_MEMWB_j),
 .Read_reg1(PC_instruction_IFID[25:21]),
 .Read_reg2(PC_instruction_IFID[20:16]),
 .write(RegWrite_MEMWB),
 .clk(clk),
 .rst(rst)

);

signextend sign_ext
(
 .SignImm(SignImm),
 .half_sign_in(PC_instruction_IFID[15:0])
);

Shiftl2 shft_Jaddress
(
 .Shifl2_out(Jaddress),
 .SignImm({6'd0,PC_instruction_IFID[25:0]})
);

Shiftl2 shftl2
(
 .Shifl2_out(Shifl2_out),
 .SignImm(SignImm_IDEX)
);

mux_S mux_S_HZDU
(
 .PCEn_out_HD(PCEn_out_HD),
 .branch_out_HD(branch_out_HD), 
 .RegWrite_out_HD(RegWrite_out_HD), 
 .MemWrite_out_HD(MemWrite_out_HD),
 .jump_out_HD(jump_out_HD),
 .jregister_out_HD(jregister_out_HD),
 .ALUSrcA_out_HD(ALUSrcA_out_HD),
 .ALUSrcB_out_HD(ALUSrcB_out_HD),
 .MemtoReg_out_HD(MemtoReg_out_HD),
 .RegDst_out_HD(RegDst_out_HD),
 .ALUControl_out_HD(ALUControl_out_HD),

 .PCEn_in_HD(PCEn),
 .branch_in_HD(branch),
 .RegWrite_in_HD(RegWrite), 
 .MemWrite_in_HD(MemWrite), 
 .jump_in_HD(jump),
 .jregister_in_HD(jregister),
 .ALUSrcA_in_HD(ALUSrcA), 
 .ALUSrcB_in_HD(ALUSrcB),
 .MemtoReg_in_HD(MemtoReg),
 .RegDst_in_HD(RegDst),
 .ALUControl_in_HD(ALUControl),
 .sel(set_HDU)
 
);

//hazard detection unit
 hazard_detection_unit HZDU1
(
 .set_HDU(set_HDU),
 .PCWrite(PCWrite),
 .PC_instruction_IDEX(PC_instruction_IDEX),
 .PC_instruction_IFID(PC_instruction_IFID),
 .MemtoReg_IDEX(MemtoReg_IDEX),
 .Write_IFID(Write_IFID)
);



///// PIPELINE ID/EX
reg_IDEX pipeline_reg_IDEX
(
 .Addresult_4_Jaddress_IDEX(Addresult_4_Jaddress_IDEX),
 .Addresult_4_IDEX(Addresult_4_IDEX),
 .PC_instruction_IDEX(PC_instruction_IDEX),
 .reg_2ALUA_IDEX(reg_2ALUA_IDEX),
 .reg_2ALUB_IDEX(reg_2ALUB_IDEX),
 .SignImm_IDEX(SignImm_IDEX),
 .branch_IDEX(branch_IDEX),
 .Addresult_4_Jaddress_in({Addresult_4[31:28],Jaddress[27:0]}),
 .Addresult_4_IFID(Addresult_4_IFID),
 .PC_instruction_IFID(PC_instruction_IFID),
 .reg_2ALUA_in(reg_2ALUA),
 .reg_2ALUB_in(reg_2ALUB), 
 .branch_in(branch_out_HD),
 .SignImm_in(SignImm),
 .clk(clk),
 .rst(rst),
 //control signals
 .PCEn_in(PCEn_out_HD),
 .RegWrite_in(RegWrite_out_HD),
 .MemWrite_in(MemWrite_out_HD), 
 .jump_in(jump_out_HD),
 .jregister_in(jregister_out_HD),
 .ALUSrcA_in(ALUSrcA_out_HD), 
 .ALUSrcB_in(ALUSrcB_out_HD),
 .MemtoReg_in(MemtoReg_out_HD),
 .RegDst_in(RegDst_out_HD),
 .ALUControl_in(ALUControl_out_HD),
 .PCEn_IDEX(PCEn_IDEX), 
 .RegWrite_IDEX(RegWrite_IDEX), 
 .MemWrite_IDEX(MemWrite_IDEX), 
 .jump_IDEX(jump_IDEX), 
 .jregister_IDEX(jregister_IDEX),
 .ALUSrcA_IDEX(ALUSrcA_IDEX),
 .ALUSrcB_IDEX(ALUSrcB_IDEX),
 .MemtoReg_IDEX(MemtoReg_IDEX),
 .RegDst_IDEX(RegDst_IDEX),
 .ALUControl_IDEX(ALUControl_IDEX),
 .PCEn_out_FLUSH(PCEn_out_FLUSH)
);

mux_2 mux9_A3
(
 .Mux_out(mux_regWriteA3),
 .Mux_in0({27'h0,PC_instruction_IDEX[20:16]}),
 .Mux_in1({27'h0,PC_instruction_IDEX[15:11]}),
 .sel(RegDst_IDEX[0])
);

Add Add2_j
(
 .AddResult(Addresult2_j),
 .SrcA(Addresult_4_IDEX),
 .SrcB(Shifl2_out)
);

mux_2 mux4_jal
(
 .Mux_out(mux4_Add1),
 .Mux_in0(Addresult2_j_EXMEM),
 .Mux_in1(Addresult_4_Jaddress_EXMEM),
 .sel(jump_EXMEM)
);

mux_2 mux8_jregister
(
 .Mux_out(mux8_mux3PC),
 .Mux_in0(mux4_Add1),
 .Mux_in1(SrcA_EXMEM),
 .sel(jregister_EXMEM)
);

mux_2 mux2_regALU
(
 .Mux_out(FWDU_SrcB),
 .Mux_in0(reg_2ALUB_IDEX),
 .Mux_in1(SignImm_IDEX),
 .sel(ALUSrcB_IDEX)
);

mux_2 mux6_regALU
(
 .Mux_out(FWDU_SrcA),
 .Mux_in0(reg_2ALUA_IDEX),
 .Mux_in1(PC_instruction_IDEX[10:6]),
 .sel(ALUSrcA_IDEX)
);

mux_2 mux7_WD
(
 .Mux_out(mux7_selregWD3),
 .Mux_in0(mux_regWD3),
 .Mux_in1(Addresult_4_MEMWB),
 .sel(RegDst_MEMWB[1])
);

/// PIPELINE EX/MEM
reg_EXMEM pipeline_reg_EXMEM
(
  .Addresult_4_Jaddress_EXMEM(Addresult_4_Jaddress_EXMEM),
  .Addresult2_j_EXMEM(Addresult2_j_EXMEM),
  .SrcA_EXMEM(SrcA_EXMEM),
  .ALUResult_EXMEM(ALUResult_EXMEM),
  .Zero_EXMEM(Zero_EXMEM),
  .reg_2ALUB_EXMEM(reg_2ALUB_EXMEM),
  .mux_regWriteA3_EXMEM(mux_regWriteA3_EXMEM),
  .Addresult_4_Jaddress_IDEX(Addresult_4_Jaddress_IDEX),
  .Addresult2_j_in(Addresult2_j),
  .SrcA_in(FWDU_SrcA),
  .ALUResult_in(ALUResult),
  .Zero_in(Zero),
  .reg_2ALUB_IDEX(reg_2ALUB_IDEX),
  .branch_IDEX(branch_IDEX),
  .mux_regWriteA3_in(mux_regWriteA3),
  .Addresult_4_EXMEM(Addresult_4_EXMEM),
  .Addresult_4_IDEX(Addresult_4_IDEX),
  .clk(clk),
  .rst(rst),
  .PCEn_IDEX(PCEn_IDEX),
  .RegWrite_IDEX(RegWrite_IDEX), 
  .MemWrite_IDEX(MemWrite_IDEX), 
  .jump_IDEX(jump_IDEX),
  .jregister_IDEX(jregister_IDEX),
  .MemtoReg_IDEX(MemtoReg_IDEX),
  .RegDst_IDEX(RegDst_IDEX),
  .PC_instruction_IDEX(PC_instruction_IDEX),
  .PCEn_EXMEM(PCEn_EXMEM), 
  .RegWrite_EXMEM(RegWrite_EXMEM), 
  .MemWrite_EXMEM(MemWrite_EXMEM), 
  .jump_EXMEM(jump_EXMEM), 
  .branch_EXMEM(branch_EXMEM),
  .jregister_EXMEM(jregister_EXMEM),
  .MemtoReg_EXMEM(MemtoReg_EXMEM),
  .RegDst_EXMEM(RegDst_EXMEM),
  .PC_instruction_EXMEM(PC_instruction_EXMEM),
  .PCEn_out_FLUSH(PCEn_out_FLUSH)
);

Forwarding_unit fwud
(
 .setA(setA), 
 .setB(setB),
 .PC_instruction_IDEX(PC_instruction_IDEX), 
 .PC_instruction_EXMEM(PC_instruction_EXMEM), 
 .PC_instruction_MEMWB(PC_instruction_MEMWB), 
 .RegWrite_EXMEM(RegWrite_EXMEM),
 .RegWrite_MEMWB(RegWrite_MEMWB)
);

mux_3 muxA_FWDU
(
 .Mux_out(SrcA),
 .Mux_in0(FWDU_SrcA), 
 .Mux_in1(mux_regWD3), 
 .Mux_in2(ALUResult_EXMEM),
 .sel(setA)
);
mux_3 muxB_FWDU
(
 .Mux_out(SrcB),
 .Mux_in0(FWDU_SrcB), 
 .Mux_in1(mux_regWD3), 
 .Mux_in2(ALUResult_EXMEM),
 .sel(setB)
);
ALU ALU1
(
 .ALUResult(ALUResult),
 .SrcA(SrcA),
 .SrcB(SrcB),
 .ALUControl(ALUControl_IDEX),
 .Zero(Zero)
);

mem_arch_RAM mem_arch_RAM1
(
 .Read_Data_out(Read_Data_RAM),
 .Write_Data_in(reg_2ALUB_EXMEM),
 .Address_in(ALUResult_EXMEM),
 .MemWrite(MemWrite_EXMEM),
 .clk(clk),
 .WRITE_UART(UART_DATA),
 .W_UART(W_UART),
 .READ_UART(UART_RX)
);

/// PIPELINE MEM/WB
reg_MEMWB pipeline_reg_MEMWB
(
 .Read_Data_RAM_MEMWB(Read_Data_RAM_MEMWB),
 .ALUResult_MEMWB(ALUResult_MEMWB),
 .mux_regWriteA3_MEMWB(mux_regWriteA3_MEMWB),
 .Read_Data_RAM_in(Read_Data_RAM),
 .ALUResult_EXMEM(ALUResult_EXMEM), 
 .mux_regWriteA3_EXMEM(mux_regWriteA3_EXMEM),
 .clk(clk),
 .rst(rst),
 .Addresult_4_EXMEM(Addresult_4_EXMEM),
 //control signals
 .RegWrite_EXMEM(RegWrite_EXMEM), 
 .MemtoReg_EXMEM(MemtoReg_EXMEM),
 .RegDst_EXMEM(RegDst_EXMEM),
 .RegWrite_MEMWB(RegWrite_MEMWB), 
 .MemtoReg_MEMWB(MemtoReg_MEMWB),
 .RegDst_MEMWB(RegDst_MEMWB),
 .PC_instruction_MEMWB(PC_instruction_MEMWB),
 .PC_instruction_EXMEM(PC_instruction_EXMEM),
 .Addresult_4_MEMWB(Addresult_4_MEMWB)
);

mux_2 mux5_RAMOUT
(
 .Mux_out(mux_regWD3),
 .Mux_in0(ALUResult_MEMWB),
 .Mux_in1(Read_Data_RAM_MEMWB),
 .sel(MemtoReg_MEMWB)
);

mux_2 mux10_A3j
(
 .Mux_out(mux_regWriteA3_MEMWB_j),
 .Mux_in0(mux_regWriteA3_MEMWB),
 .Mux_in1(32'h1F),
 .sel(RegDst_MEMWB[1])
);

misc_logic mlogic1
(
 .jump(jump_EXMEM),
 .alu_zero(Zero_EXMEM),
 .branch(branch_EXMEM),
 .jregister(jregister_EXMEM),
 .PCEn(PCEn)
);

Branch_flush bflush
(
 .PCEn_in(PCEn),
 .PCEn_out_FLUSH(PCEn_out_FLUSH)
);

//Control unit pending in pipeline
CU_single_cycle control_unit
(
 .clk(clk),
 .rst(rst),
 .MemWrite(MemWrite),
 .Op(PC_instruction_IFID[31:26]),
 .Funct(PC_instruction_IFID[5:0]),
 .RegWrite(RegWrite),
 .ALUSrcA(ALUSrcA),
 .ALUSrcB(ALUSrcB),
 .ALUControl(ALUControl),
 .Branch(branch),
// .PCWrite(PCWrite), 
 .MemtoReg(MemtoReg),
 .RegDst(RegDst),
 .jump(jump),
 .jregister(jregister)
);

endmodule
