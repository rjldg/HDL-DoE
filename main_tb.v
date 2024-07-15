`timescale 1 ns / 1 ns
`include "desc_lib.v"

module main_tb;

    wire [4:0] out;
    wire [1:0] mode_out;
    reg [9:0] x;
    reg sel, reset, t;
    wire q1, q2, q3, qbar1, qbar2, qbar3;

    input_encoder enc(x, out);
    demux1_2 dmx(mode_out, out[4], sel);
    t_ff_circuit uut(q1, q2, q3, qbar1, qbar2, qbar3, mode_out[0], reset, t);

    /*
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    */

    initial begin
        $dumpfile("main_tb.vcd"); $dumpvars(0, main_tb);

        $display("*** SIMULATING INPUT ENCODER ***");
        $display("\t BCD Output\t   Keypad Input\t    Demux Output\t\t     TFF Output");
        $monitor("\t   %b\t    %b\t         %b\t\t     clk1=%b, clk2=%b, clk3=%b, clk4=%b", out, x, mode_out, q2, qbar2, q3, qbar3);

        x[0]=0; x[1]=0; x[2]=0; x[3]=0; x[4]=0; 
        x[5]=0; x[6]=0; x[7]=0; x[8]=0; x[9]=0;

        sel = 0;
        t = 0;
        reset = 1;
        
        #1 t = 1;
        #1 reset = 0;
        #5 x[0]=1;
        #5 x[0]=0;
        #5 x[1]=1;
        #5 x[1]=0;
        #5 x[9]=1;
        #5 x[9]=0;
        #20 $finish;

    end


endmodule