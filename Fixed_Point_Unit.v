`include "Defines.vh"

module Fixed_Point_Unit 
#(
    parameter WIDTH = 32,
    parameter FBITS = 10
)
(
    input wire clk,
    input wire reset,
    
    input wire [WIDTH - 1 : 0] operand_1,
    input wire [WIDTH - 1 : 0] operand_2,
    
    input wire [ 1 : 0] operation,

    output reg [WIDTH - 1 : 0] result,
    output reg ready
);

    always @(*)
    begin
        case (operation)
            `FPU_ADD    : begin result <= operand_1 + operand_2; ready <= 1; end
            `FPU_SUB    : begin result <= operand_1 - operand_2; ready <= 1; end
            `FPU_MUL    : begin result <= product[WIDTH + FBITS - 1 : FBITS]; ready <= product_ready; end
            `FPU_SQRT   : begin result <= root; ready <= root_ready; end
            default     : begin result <= 'bz; ready <= 0; end
        endcase
    end

    always @(posedge reset)
    begin
        if (reset)  ready = 0;
        else        ready = 'bz;
    end
    // ------------------- //
    // Square Root Circuit //
    // ------------------- //
    reg [WIDTH - 1 : 0] root=32'b0;
    reg root_ready;
    reg [WIDTH-1:0]co_oprand1=operand_1;
    reg[1:0]pair;
    reg[31:0]count=16;
    reg[31:0]radicand;
    reg[31:0]sbb=32'b0;
    reg[31:0]sub_result=32'b0
    reg[31:0]co_sub_result;
    always @(*)
    begin
    for(i=0;i < count;i=i+1)
    begin
    pair=co_oprand1[31:30];
    radicand=(sub_result << 2)+pair;
    sbb=(root << 2)+1;
    co_sub_result=sub_result;
    sub_result=radicand-sbb;
    if(sub_result)
    root=(root << 1)+1
    else
    begin
    sub_result=co_sub_result;
    root=(root<<1)
    end
    co_oprand1=co_oprand1 <<2;
    end
    end
    root_ready=1;

    // ------------------ //
    // Multiplier Circuit //
    // ------------------ //   
    reg [64 - 1 : 0] product;
    reg product_ready;

    reg     [15 : 0] multiplierCircuitInput1L = operand_1[15:0];
    reg     [15 : 0] multiplierCircuitInput2L = operand_2[15:0];
    reg     [15 : 0] multiplierCircuitInput1H = operand_1[31:16];
    reg     [15 : 0] multiplierCircuitInput2H = operand_2[31:16];

    reg   [31 : 0] multiplierCircuitResult1;
    reg   [31 : 0] multiplierCircuitResult2;
    reg   [31 : 0] multiplierCircuitResult3;
    reg   [31 : 0] multiplierCircuitResult4;





    reg     [63 : 0] partialProduct1 = 64'b0;
    reg     [63 : 0] partialProduct2 = 64'b0;
    reg     [63 : 0] partialProduct3 = 64'b0;
    reg     [63 : 0] partialProduct4 = 64'b0;

        Multiplier multiplier_circuit1
    (
        .operand_1(multiplierCircuitInput1L),
        .operand_2(multiplierCircuitInput2L),
        .product(multiplierCircuitResult1)
    );
           Multiplier multiplier_circuit2
    (
        .operand_1(multiplierCircuitInput2L),
        .operand_2(multiplierCircuitInput1H),
        .product(multiplierCircuitResult2)
    );
           Multiplier multiplier_circuit3
    (
        .operand_1(multiplierCircuitInput2H),
        .operand_2(multiplierCircuitInput1L),
        .product(multiplierCircuitResult3)
    );
           Multiplier multiplier_circuit4
    (
        .operand_1(multiplierCircuitInput1H),
        .operand_2(multiplierCircuitInput2H),
        .product(multiplierCircuitResult4)

    );

always (*) begin
partialProduct1 = multiplierCircuitResult1 + partialProduct1;
partialProduct2 = multiplierCircuitResult2 + partialProduct2;
partialProduct3 = multiplierCircuitResult3 + partialProduct3;
partialProduct4 = multiplierCircuitResult4 + partialProduct4;

partialProduct1 = multiplierCircuitResult1;
partialProduct2 = multiplierCircuitResult2 << 16;
partialProduct3 = multiplierCircuitResult3 << 16;
partialProduct4 = multiplierCircuitResult4 << 32;

product = partialProduct1 + partialProduct2 + partialProduct3 + partialProduct4;
product_ready =1'b1;
end

         
endmodule

module Multiplier
(
    input wire [15 : 0] operand_1,
    input wire [15 : 0] operand_2,

    output reg [31 : 0] product
);

    always @(*)
    begin
        product <= operand_1 * operand_2;
    end
endmodule