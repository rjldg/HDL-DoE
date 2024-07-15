// Design of encoder for inputs ~ makes use of Behavioural Description
module input_encoder (input [9:0] D_in, output reg [4:0] BCD_out);

    always @(D_in) begin
        casez (D_in)
            10'b0000000001: BCD_out = 5'b10000;  // D_in[0]
            10'b000000001?: BCD_out = 5'b10001;  // D_in[1]
            10'b00000001??: BCD_out = 5'b10010;  // D_in[2]
            10'b0000001???: BCD_out = 5'b10011;  // D_in[3]
            10'b000001????: BCD_out = 5'b10100;  // D_in[4]
            10'b00001?????: BCD_out = 5'b10101;  // D_in[5]
            10'b0001??????: BCD_out = 5'b10110;  // D_in[6]
            10'b001???????: BCD_out = 5'b10111;  // D_in[7]
            10'b01????????: BCD_out = 5'b11000;  // D_in[8]
            10'b1?????????: BCD_out = 5'b11001;  // D_in[9]
            default: BCD_out = 5'b00000;  // Default case to handle no-input states
        endcase

    end

endmodule

// Design of 1-2 Demultiplexer for clocking JK flip-flops - makes use of Behavioural Description
module demux1_2 (output reg [1:0] Mode_out, input Press_in, input select);

    always @(Press_in, select) begin
        Mode_out = 2'b00;
        case (select)
            1'b0: Mode_out[0] = Press_in;
            1'b1: Mode_out[1] = Press_in;
            default: Mode_out = 2'b00;
        endcase
    end

endmodule

// Design of a T flipflops for clocking the memory for inputs sequentially - makes use of Behavioural Description
module t_ff (output reg q, output qbar, input clk, rst, t);

	assign qbar = ~q;

	always @(clk)
	begin
		if (rst)
			q <= 0;
		else
			case(t)
				1'b0: q <= q;
				1'b1: q <= ~q;
			endcase
	end
endmodule

// Design of a T-FF circuit ~ makes use of Gate-Level Modelling
module t_ff_circuit (output wire q1, q2, q3, qbar1, qbar2, qbar3, input clk, rst, t);

    // Internal wires for clock connections
    wire t1_q, t1_qbar;
    
    // Instantiate the first T flip-flop
    t_ff t1 (t1_q, t1_qbar, clk, rst, t);
    
    // Instantiate the second T flip-flop, clocked by q of the first flip-flop
    t_ff t2 (q2, qbar2, t1_q, rst, t);
    
    // Instantiate the third T flip-flop, clocked by qbar of the first flip-flop
    t_ff t3 (q3, qbar3, t1_qbar, rst, t);
    
    // Output assignments
    assign q1 = t1_q;
    assign qbar1 = t1_qbar;

endmodule