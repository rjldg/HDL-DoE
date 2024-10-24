`timescale 1 ns / 1 ns
`include "desc_lib.v"

module main_tb;

    wire [4:0] out;
    wire [1:0] mode_out;
    wire [3:0] reg_out1, reg_out2, reg_out3, reg_out4;
    reg [9:0] x;
    reg sel, rst_ui, t;
    wire q1_ui, q2_ui, q3_ui, qbar1_ui, qbar2_ui, qbar3_ui;

    input_encoder enc(x, out);
    demux1_2 dmx(mode_out, out[4], sel);
    t_ff_circuit input_t_ff(q1_ui, q2_ui, q3_ui, qbar1_ui, qbar2_ui, qbar3_ui, mode_out[0], rst_ui, t);
    shift_reg_array input_array(q2_ui, q3_ui, qbar2_ui, qbar3_ui, rst_ui, out[3:0], out[3:0], out[3:0], out[3:0], 2'b11,
        reg_out1, reg_out2, reg_out3, reg_out4);

    /*
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    */

    initial begin
        $dumpfile("main_tb.vcd"); $dumpvars(0, main_tb);

        $display("*** SIMULATING INPUT ENCODER ***");
        $display("\t BCD Output\t   Keypad Input\t    Demux Output\t\t     TFF Output\t\t\t\t\t       Shift Register Output");
        $monitor("\t   %b\t    %b\t         %b\t\t     clk1=%b, clk2=%b, clk3=%b, clk4=%b\t\t       SR1=%b, SR2=%b, SR3=%b, SR4=%b", out, x, mode_out, q2_ui, q3_ui, qbar2_ui, qbar3_ui, reg_out1, reg_out2, reg_out3, reg_out4);

        x[0]=0; x[1]=0; x[2]=0; x[3]=0; x[4]=0; 
        x[5]=0; x[6]=0; x[7]=0; x[8]=0; x[9]=0;

        sel = 0;
        t = 0;
        rst_ui = 1;
        
        
        #1 t = 1;
        #1 rst_ui = 0;
        #5 x[2]=1;
        #5 x[2]=0;
        #5 x[1]=1;
        #5 x[1]=0;
        #5 x[9]=1;
        #5 x[9]=0;
        #5 x[7]=1;
        #5 x[7]=0;
        #5 rst_ui = 1;
        #5 rst_ui = 0;
        #5 x[5]=1;
        #5 x[5]=0;
        #20 $finish;

    end


endmodule