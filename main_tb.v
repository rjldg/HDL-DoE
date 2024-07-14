`timescale 1 ns / 1 ns
`include "desc_lib.v"

module main_tb;

    wire [4:0] out;
    reg [9:0] x;

    input_encoder enc(x, out);

    initial begin
        $dumpfile("main_tb.vcd"); $dumpvars(0, main_tb);

        x[0]=0; x[1]=0; x[2]=0; x[3]=0; x[4]=0; 
        x[5]=0; x[6]=0; x[7]=0; x[8]=0; x[9]=0;

        $display("*** SIMULATING INPUT ENCODER ***");
        $display("\t BCD Output\t   Keypad Input");
        $monitor("\t   %b\t    %b", out, x);

        #5 x[0]=1;
        #5 x[1]=1;
        #5 x[1]=0;
        #5 x[0]=0;
        #5 x[9]=1;
        #5 x[9]=0;

    end


endmodule