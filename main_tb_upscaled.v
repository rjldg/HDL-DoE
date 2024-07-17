`timescale 1 ns / 1 ns
`include "desc_lib.v"

module main_tb;

    wire [4:0] out;
    wire [1:0] mode_out;
    wire [3:0] reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8;
    wire [3:0] sp_reg_out1, sp_reg_out2, sp_reg_out3, sp_reg_out4, sp_reg_out5, sp_reg_out6, sp_reg_out7, sp_reg_out8;
    reg [9:0] x;
    reg sel, rst_ui, rst_sp, t;
    wire q1_ui, q2_ui, q3_ui, q4_ui, q5_ui, q6_ui, q7_ui, qbar1_ui, qbar2_ui, qbar3_ui, qbar4_ui, qbar5_ui, qbar6_ui, qbar7_ui;
    wire q1_sp, q2_sp, q3_sp, q4_sp, q5_sp, q6_sp, q7_sp, qbar1_sp, qbar2_sp, qbar3_sp, qbar4_sp, qbar5_sp, qbar6_sp, qbar7_sp;

    input_encoder enc(x, out);
    demux1_2 dmx(mode_out, out[4], sel);

    t_ff_circuit_upscaled input_t_ff(q1_ui, q2_ui, q3_ui, q4_ui, q5_ui, q6_ui, q7_ui, qbar1_ui, qbar2_ui, qbar3_ui, qbar4_ui, qbar5_ui, qbar6_ui, qbar7_ui, mode_out[0], rst_ui, t);
    shift_reg_array_upscaled input_array(q4_ui, q6_ui, q5_ui, q7_ui, qbar4_ui, qbar6_ui, qbar5_ui, qbar7_ui, rst_ui, out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], 2'b11,
        reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8);

    t_ff_circuit_upscaled input_t_ff_2(q1_sp, q2_sp, q3_sp, q4_sp, q5_sp, q6_sp, q7_sp, qbar1_sp, qbar2_sp, qbar3_sp, qbar4_sp, qbar5_sp, qbar6_sp, qbar7_sp, mode_out[1], rst_sp, t);
    shift_reg_array_upscaled input_array_2(q4_sp, q6_sp, q5_sp, q7_sp, qbar4_sp, qbar6_sp, qbar5_sp, qbar7_sp, rst_sp, out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], out[3:0], 2'b11,
        sp_reg_out1, sp_reg_out2, sp_reg_out3, sp_reg_out4, sp_reg_out5, sp_reg_out6, sp_reg_out7, sp_reg_out8);

    /*
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    */

    initial begin
        $dumpfile("main_tb.vcd"); $dumpvars(0, main_tb);

        $display("*** SIMULATING INPUT ENCODER ***");
        $display("\t BCD Output\t   Keypad Input\t    Demux Output\t\t\t\t     TFF Output\t\t\t\t\t\t\t\t\t        (UI) Shift Register Output\t\t\t\t\t\t\t\t        (SP) Shift Register Output");
        $monitor("\t   %b\t    %b\t         %b\t\t     clk1=%b, clk2=%b, clk3=%b, clk4=%b, clk5=%b, clk6=%b, clk7=%b, clk8=%b\t\t       SR1=%b, SR2=%b, SR3=%b, SR4=%b, SR5=%b, SR6=%b, SR7=%b, SR8=%b\t\t       SR1=%b, SR2=%b, SR3=%b, SR4=%b, SR5=%b, SR6=%b, SR7=%b, SR8=%b", out, x, mode_out, q4_ui, q6_ui, q5_ui, q7_ui, qbar4_ui, qbar6_ui, qbar5_ui, qbar7_ui, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, sp_reg_out1, sp_reg_out2, sp_reg_out3, sp_reg_out4, sp_reg_out5, sp_reg_out6, sp_reg_out7, sp_reg_out8);

        x[0]=0; x[1]=0; x[2]=0; x[3]=0; x[4]=0; 
        x[5]=0; x[6]=0; x[7]=0; x[8]=0; x[9]=0;

        sel = 1;
        t = 0;
        rst_ui = 1;
        rst_sp = 1;
        
        fork
            #1 t = 1;
            #1 rst_ui = 0;
            #1 rst_sp = 0;
        join   
        #5 x[2]=1;
        #5 x[2]=0;
        #5 x[1]=1;
        #5 x[1]=0;
        #5 x[9]=1;
        #5 x[9]=0;
        #5 x[3]=1;
        #5 x[3]=0;
        #5 x[5]=1;
        #5 x[5]=0;
        #5 x[4]=1;
        #5 x[4]=0;
        #5 x[8]=1;
        #5 x[8]=0;
        #5 x[8]=1;
        #5 x[8]=0;
        #5 x[1]=1;
        #5 x[1]=0;
        #20 $finish;

    end


endmodule