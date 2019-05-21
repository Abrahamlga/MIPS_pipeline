// Memory ram
// Jesus Abraham Lizarraga Banuelos
// March-09-2018
// mem.sv
//

timeunit 1ns;
timeprecision 100ps;
module mem_ram
#(
    parameter BIT_WIDTH=32
)
(
 output logic [BIT_WIDTH-1:0] Read_Data_out, READ_UART,
 input logic  [BIT_WIDTH-1:0] Write_Data_in, Address_in, WRITE_UART,
 input logic [6:0] ADDR_UART,
 input logic  MemWrite,W_UART,clk
);

//logic
//logic [BIT_WIDTH-1:0] register [BIT_WIDTH-1:0];
logic [BIT_WIDTH-1:0] register [128-1:0];


always_comb
begin
 Read_Data_out = register[Address_in];
 READ_UART=register[ADDR_UART];
end

always_ff @(posedge clk) //MIPS
begin
    if(MemWrite) begin
     // write
     register[Address_in]<= Write_Data_in;
    end
end //always

always_ff @(posedge clk) //UART
begin
    if(W_UART) begin
     // write
     register[ADDR_UART]<= WRITE_UART;
    end
end //always

endmodule
