module ALU #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 4
) (
    input  logic [DATA_WIDTH-1:0]   a,
    input  logic [DATA_WIDTH-1:0]   b,
    input  logic [OPCODE_WIDTH-1:0] opcode,
    output logic [DATA_WIDTH-1:0]   result,
    output logic                    zero_flag,
    output logic                    carry_flag,
    output logic                    overflow_flag
);

    // ALU operation codes
    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam AND  = 4'b0010;
    localparam OR   = 4'b0011;
    localparam XOR  = 4'b0100;
    localparam NOT  = 4'b0101;
    localparam SLL  = 4'b0110; // Shift Left Logical
    localparam SRL  = 4'b0111; // Shift Right Logical
    localparam SLT  = 4'b1000; // Set Less Than
    localparam MUL  = 4'b1001; // Multiply (lower bits)
    localparam INC  = 4'b1010; // Increment A
    localparam DEC  = 4'b1011; // Decrement A

    logic [DATA_WIDTH:0] temp_result; // Extra bit for carry detection
    logic [2*DATA_WIDTH-1:0] mult_result; // For multiplication

    always_comb begin
        temp_result = '0;
        mult_result = '0;
        carry_flag = 1'b0;
        overflow_flag = 1'b0;
        
        case (opcode)
            ADD: begin
                temp_result = a + b;
                carry_flag = temp_result[DATA_WIDTH];
                overflow_flag = (a[DATA_WIDTH-1] == b[DATA_WIDTH-1]) && 
                               (temp_result[DATA_WIDTH-1] != a[DATA_WIDTH-1]);
            end
            
            SUB: begin
                temp_result = a - b;
                carry_flag = (a < b);
                overflow_flag = (a[DATA_WIDTH-1] != b[DATA_WIDTH-1]) && 
                               (temp_result[DATA_WIDTH-1] != a[DATA_WIDTH-1]);
            end
            
            AND: temp_result[DATA_WIDTH-1:0] = a & b;
            OR:  temp_result[DATA_WIDTH-1:0] = a | b;
            XOR: temp_result[DATA_WIDTH-1:0] = a ^ b;
            NOT: temp_result[DATA_WIDTH-1:0] = ~a;
            
            SLL: temp_result[DATA_WIDTH-1:0] = a << b[2:0]; // Shift by lower 3 bits of b
            SRL: temp_result[DATA_WIDTH-1:0] = a >> b[2:0]; // Shift by lower 3 bits of b
            
            SLT: temp_result[DATA_WIDTH-1:0] = (a < b) ? 1 : 0;
            
            MUL: begin
                mult_result = a * b;
                temp_result[DATA_WIDTH-1:0] = mult_result[DATA_WIDTH-1:0];
                carry_flag = |mult_result[2*DATA_WIDTH-1:DATA_WIDTH]; // Any high bits set
            end
            
            INC: begin
                temp_result = a + 1;
                carry_flag = temp_result[DATA_WIDTH];
                overflow_flag = (a == {DATA_WIDTH{1'b1}});
            end
            
            DEC: begin
                temp_result = a - 1;
                carry_flag = (a == 0);
                overflow_flag = (a == {1'b1, {(DATA_WIDTH-1){1'b0}}});
            end
            
            default: temp_result[DATA_WIDTH-1:0] = '0;
        endcase
        
        result = temp_result[DATA_WIDTH-1:0];
        zero_flag = (result == 0);
    end

endmodule
