`timescale 1 ns / 1 ns
`include "desc_lib.v"

module main_tb;

    wire [4:0] out;
    wire [1:0] mode_out;
    reg [9:0] x;
    reg sel;

    input_encoder enc(x, out);
    demux1_2 dmx(mode_out, out[4], sel);

    initial begin
        $dumpfile("main_tb.vcd"); $dumpvars(0, main_tb);

        x[0]=0; x[1]=0; x[2]=0; x[3]=0; x[4]=0; 
        x[5]=0; x[6]=0; x[7]=0; x[8]=0; x[9]=0;

        sel = 1'b0;

        $display("*** SIMULATING INPUT ENCODER ***");
        $display("\t BCD Output\t   Keypad Input\t    Demux Output");
        $monitor("\t   %b\t    %b\t         %b", out, x, mode_out);

        #5 x[0]=1;
        #5 x[1]=1;
        #5 x[1]=0;
        #5 x[0]=0;
        #5 x[9]=1;
        #5 x[9]=0;

    end


endmodule