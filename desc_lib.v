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
module demux1_2 (output reg [1:0] Mode_out, input Press_in, input [1:0] select);

    always @(Press_in, select) begin
        Mode_out = 2'b00;
        case (select)
            2'b00: Mode_out[0] = Press_in;
            2'b01: Mode_out[1] = Press_in;
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

// Design of a T-FF circuit for 4-bit storage clocking ~ makes use of Gate-Level and Dataflow Modeling
module t_ff_circuit (output wire q1, q2, q3, qbar1, qbar2, qbar3, input clk, rst, t);

    wire t1_q, t1_qbar;
    t_ff t1 (t1_q, t1_qbar, clk, rst, t);
    t_ff t2 (q2, qbar2, t1_q, rst, t);
    t_ff t3 (q3, qbar3, t1_qbar, rst, t);
    
    assign q1 = t1_q;
    assign qbar1 = t1_qbar;

endmodule

// Design of a T-FF circuit for 8-bit storage clocking ~ makes use of Gate-Level and Dataflow Modeling
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

// Design of a universal shift register for BCD memory storage ~ makes use of Behavioural Modeling
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

// Design of a univeral shift register array for 4-digit BCD storage ~ makes use of Gate-level Modeling
module shift_reg_array (input clk1, clk2, clk3, clk4, clear,
    input [3:0] reg_in1, input [3:0] reg_in2, input [3:0] reg_in3, input [3:0] reg_in4, input [1:0] reg_mode, 
    output [3:0] reg_out1, output [3:0] reg_out2, output [3:0] reg_out3, output [3:0] reg_out4);

    univ_shift_reg reg1(reg_out1, clk1, clear, reg_mode, reg_in1);
    univ_shift_reg reg2(reg_out2, clk2, clear, reg_mode, reg_in2);
    univ_shift_reg reg3(reg_out3, clk3, clear, reg_mode, reg_in3);
    univ_shift_reg reg4(reg_out4, clk4, clear, reg_mode, reg_in4);

endmodule

// Design of a univeral shift register array for 8-digit BCD storage ~ makes use of Gate-level Modeling
module shift_reg_array_upscaled (input clk1, clk2, clk3, clk4, clk5, clk6, clk7, clk8, clear,
    input [3:0] reg_in1, input [3:0] reg_in2, input [3:0] reg_in3, input [3:0] reg_in4, input [3:0] reg_in5, input [3:0] reg_in6, input [3:0] reg_in7, input [3:0] reg_in8, input [1:0] reg_mode, 
    output [3:0] reg_out1, output [3:0] reg_out2, output [3:0] reg_out3, output [3:0] reg_out4, output [3:0] reg_out5, output [3:0] reg_out6, output [3:0] reg_out7, output [3:0] reg_out8);

    univ_shift_reg reg1(reg_out1, clk1, clear, reg_mode, reg_in1);
    univ_shift_reg reg2(reg_out2, clk2, clear, reg_mode, reg_in2);
    univ_shift_reg reg3(reg_out3, clk3, clear, reg_mode, reg_in3);
    univ_shift_reg reg4(reg_out4, clk4, clear, reg_mode, reg_in4);
    univ_shift_reg reg5(reg_out5, clk5, clear, reg_mode, reg_in5);
    univ_shift_reg reg6(reg_out6, clk6, clear, reg_mode, reg_in6);
    univ_shift_reg reg7(reg_out7, clk7, clear, reg_mode, reg_in7);
    univ_shift_reg reg8(reg_out8, clk8, clear, reg_mode, reg_in8);

endmodule

// Design of a 32-bit to 32-bit comparator for comparing secured password and user-inputted password ~ makes use of Dataflow Modeling
module eq_32_bit_comparator (input [31:0] in_1, in_2, output eq);

    assign eq = (in_1==in_2);

endmodule

// Design of a attempt counter in BCD ~ makes use of Behavioural Modeling
module attempt_bcd_counter (input reset, clk, output reg [3:0] count);

    always @(posedge clk) begin

        if (reset)
            count <= 4'b0000;
        else
            count <= count + 4'b0001;

    end

endmodule

// Design of a D-Flipflop for triggering the alarm effectively ~ makes use of Behavioural Modeling
module d_ff (output reg q, output qbar, input clk, rst, d);

	assign qbar = ~q;
    initial q = 0;

	always @(posedge clk, negedge rst)
	begin
		if (rst)
			q <= 0;
		else
			q <= d;
	end

endmodule

// Design of the output circuit to trigger the alarm or unlocked output state ~ makes use of Gate-level Modeling
module output_circuit (output alarm, unlocked, qbar, input is_equal, reset_alarm, bit_0, bit_2, is_null);

    wire w1, w2, w3;

    d_ff d1(alarm, qbar, w2, reset_alarm, w2);
    not NOT1(w1, is_equal), NOT(w3, is_null);
    and AND1(w2, bit_0, bit_2, w1, w3), AND2(unlocked, qbar, is_equal, w3);

endmodule
