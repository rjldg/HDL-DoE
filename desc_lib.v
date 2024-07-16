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

// Design of 1-2 Demultiplexer for clocking T flip-flops - makes use of Behavioural Description
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

	always @(posedge clk)
	begin
		if (rst)
			q <= 0;
		else
			case(t)
				1'b0: q <= q;
				1'b1: q <= ~q;
			endcase
	end

    always @(negedge clk)
    begin
        if (rst)
			q <= 0;
    end
endmodule

// Design of a T-FF circuit ~ makes use of Gate-Level Modelling
module t_ff_circuit (output wire q1, q2, q3, qbar1, qbar2, qbar3, input clk, rst, t);

    wire t1_q, t1_qbar;
    
    t_ff t1 (t1_q, t1_qbar, clk, rst, t);
    
    t_ff t2 (q2, qbar2, t1_q, rst, t);

    t_ff t3 (q3, qbar3, t1_qbar, rst, t);
    
    assign q1 = t1_q;
    assign qbar1 = t1_qbar;

endmodule

module t_ff_circuit_upscaled (output wire q1, q2, q3, q4, q5, q6, q7,
    qbar1, qbar2, qbar3, qbar4, qbar5, qbar6, qbar7, input clk, rst, t);

    wire t1_q, t1_qbar, t2_q, t2_qbar, t3_q, t3_qbar;

    t_ff t1 (t1_q, t1_qbar, clk, rst, t);

    t_ff t2 (t2_q, t2_qbar, t1_q, rst, t);

    t_ff t3 (t3_q, t3_qbar, t1_qbar, rst, t);
    
    t_ff t4 (q4, qbar4, t2_q, rst, t);

    t_ff t5 (q5, qbar5, t2_qbar, rst, t);

    t_ff t6 (q6, qbar6, t3_q, rst, t);

    t_ff t7 (q7, qbar7, t3_qbar, rst, t);

    assign q1 = t1_q;
    assign qbar1 = t1_qbar;
    assign q2 = t2_q;
    assign qbar2 = t2_qbar;
    assign q3 = t3_q;
    assign qbar3 = t3_qbar;
    
endmodule

module univ_shift_reg (output reg [3:0] reg_out, input clock, reset, input [1:0] reg_mode, input [3:0] reg_in);

    always @(reset) begin
        case (reset)
            1'b1: reg_out = 4'b0000;
            default: reg_out = reg_out;
        endcase
    end

    always @(posedge clock)
    begin
        if(reset)
        reg_out <= 4'b0000;
        else
        begin
            case(reg_mode)
            2'b00 : reg_out <= reg_out;      // locked mode, do nothing
            2'b01 : reg_out <= {reg_in[0], reg_out[3:1]};//reg_out >> 1; // RFSR
            2'b10 : reg_out <= {reg_out[2:0], reg_in[0]};//reg_out << 1; // LFSR
            2'b11 : reg_out <= reg_in;       // parallel in parallel out
            endcase
        end
    end
  
endmodule

module shift_reg_array (input clk1, clk2, clk3, clk4, clear,
    input [3:0] reg_in1, input [3:0] reg_in2, input [3:0] reg_in3, input [3:0] reg_in4, input [1:0] reg_mode, 
    output [3:0] reg_out1, output [3:0] reg_out2, output [3:0] reg_out3, output [3:0] reg_out4);

    univ_shift_reg reg1(reg_out1, clk1, clear, reg_mode, reg_in1);
    univ_shift_reg reg2(reg_out2, clk2, clear, reg_mode, reg_in2);
    univ_shift_reg reg3(reg_out3, clk3, clear, reg_mode, reg_in3);
    univ_shift_reg reg4(reg_out4, clk4, clear, reg_mode, reg_in4);

endmodule

module shift_reg_array_upscaled (input clk1, clk2, clk3, clk4, clk5, clk6, clear,
    input [3:0] reg_in1, input [3:0] reg_in2, input [3:0] reg_in3, input [3:0] reg_in4, input [3:0] reg_in5, input [3:0] reg_in6, input [1:0] reg_mode, 
    output [3:0] reg_out1, output [3:0] reg_out2, output [3:0] reg_out3, output [3:0] reg_out4, output [3:0] reg_out5, output [3:0] reg_out6);

    univ_shift_reg reg1(reg_out1, clk1, clear, reg_mode, reg_in1);
    univ_shift_reg reg2(reg_out2, clk2, clear, reg_mode, reg_in2);
    univ_shift_reg reg3(reg_out3, clk3, clear, reg_mode, reg_in3);
    univ_shift_reg reg4(reg_out4, clk4, clear, reg_mode, reg_in4);
    univ_shift_reg reg5(reg_out5, clk5, clear, reg_mode, reg_in5);
    univ_shift_reg reg6(reg_out6, clk6, clear, reg_mode, reg_in6);

endmodule