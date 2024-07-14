// Design of encoder for inputs ~ makes use of Behavioural Description
module input_encoder (input [9:0] D_in, output reg [3:0] BCD_out);

    always @(D_in) begin
        casez (D_in)
            10'b0000000001: BCD_out = 4'b0000;  // D_in[0]
            10'b000000001?: BCD_out = 4'b0001;  // D_in[1]
            10'b00000001??: BCD_out = 4'b0010;  // D_in[2]
            10'b0000001???: BCD_out = 4'b0011;  // D_in[3]
            10'b000001????: BCD_out = 4'b0100;  // D_in[4]
            10'b00001?????: BCD_out = 4'b0101;  // D_in[5]
            10'b0001??????: BCD_out = 4'b0110;  // D_in[6]
            10'b001???????: BCD_out = 4'b0111;  // D_in[7]
            10'b01????????: BCD_out = 4'b1000;  // D_in[8]
            10'b1?????????: BCD_out = 4'b1001;  // D_in[9]
            default: BCD_out = 4'bxxxx;  // Default case to handle unknown or invalid states
        endcase
    end

endmodule