/*
 *  SVO - Simple Video Out FPGA Core
 *
 *  Copyright (C) 2014  Clifford Wolf <clifford@clifford.at>
 *  
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

`timescale 1ns / 1ps
`include "svo_defines.vh"

module svo_tcard #( `SVO_DEFAULT_PARAMS ) (

    inout [7:0] data,
    input ncs,
    input nwr,
    input nrd,
    input nrst,
    input [2:0] addr,
	input clk, resetn,
    output [5:0] led,
    input cpuclk,

	// output stream
	//   tuser[0] ... start of frame
	output reg out_axis_tvalid,
	input out_axis_tready,
	output reg [SVO_BITS_PER_PIXEL-1:0] out_axis_tdata,
	output reg [0:0] out_axis_tuser
    );

	wire [SVO_BITS_PER_RED-1:0] r;
	wire [SVO_BITS_PER_GREEN-1:0] g;
	wire [SVO_BITS_PER_BLUE-1:0] b;

//    reg [7:0] regbusdata;
//    assign data = regbusdata;

    reg[15:0] wraddr_tmp;
    reg [7:0] bramdatain_tmp;

    reg[15:0] bramwraddr;
    reg [7:0] bramdatain;
    wire[7:0] bramdataout;
    wire[15:0] bramrdaddr;
    
    reg bram_awrite;
    reg bram_aclock;
    reg bram_lock;

    reg started;
    reg[3:0] wstate;
    reg got_wr;

    // CGA Mapping colors
    reg [3:0] cga_r[15:0];
    reg [3:0] cga_g[15:0];
    reg [3:0] cga_b[15:0];
    reg [3:0] color_index;
    assign r[7:4] = cga_r[color_index];
    assign g[7:4] = cga_g[color_index];
    assign b[7:4] = cga_b[color_index];
    assign r[3:0] = 0;
    assign g[3:0] = 0;
    assign b[3:0] = 0;

    wire border;
    reg [18:0] pixelcount;
    reg [16:0] memcounth;
    reg [7:0] memcountl;
    reg presch;
    reg [1:0]prescl;
    reg [1:0]prescnibble;

    reg [31:0] cled5;
    reg [31:0] cled4;
    reg [31:0] cled3;
    reg [5:2] regled;

    reg [31:0] counter;
    assign led[1] = counter[18];

    assign led[0] = ~(regled[5]&regled[4]);

    assign led[5:2] = ~regled;

    //assign border = ((pixelcount < 25600) | (pixelcount >= 281600));
    assign border = 0;//((pixelcount < 25599) | (pixelcount >= 281599));

    wire[16:0] memrdpos;
    assign memrdpos = memcounth + memcountl;

    assign bramrdaddr = bram_lock & (bramwraddr == memrdpos) ? 38400 : memrdpos;

    initial begin
        wstate <= 0;
        bramwraddr <= 0;
        //regbusdata <= 8'bz;
        started <= 0;

        bram_aclock <= 0;
        bram_lock <= 0;
        wraddr_tmp <= 0;

        cga_r[ 0] = 4'h0; cga_g[ 0] = 4'h0; cga_b[ 0] = 4'h0;   // BLACK
        cga_r[ 1] = 4'h0; cga_g[ 1] = 4'h0; cga_b[ 1] = 4'hc;   // BLUE
        cga_r[ 2] = 4'h0; cga_g[ 2] = 4'ha; cga_b[ 2] = 4'h0;   // GREEN
        cga_r[ 3] = 4'h0; cga_g[ 3] = 4'hc; cga_b[ 3] = 4'hc;   // CYAN
        cga_r[ 4] = 4'ha; cga_g[ 4] = 4'h0; cga_b[ 4] = 4'h0;   // RED
        cga_r[ 5] = 4'hc; cga_g[ 5] = 4'h0; cga_b[ 5] = 4'hc;   // MAGENTA
        cga_r[ 6] = 4'ha; cga_g[ 6] = 4'h6; cga_b[ 6] = 4'h2;   // BROWN
        cga_r[ 7] = 4'hc; cga_g[ 7] = 4'hc; cga_b[ 7] = 4'hc;   // GRAY

        cga_r[ 8] = 4'h8; cga_g[ 8] = 4'h8; cga_b[ 8] = 4'h8;   // DARK GRAY
        cga_r[ 9] = 4'h0; cga_g[ 9] = 4'h0; cga_b[ 9] = 4'hf;   // LIGHT BLUE
        cga_r[10] = 4'h0; cga_g[10] = 4'hf; cga_b[10] = 4'h0;   // LIGHT GREEN
        cga_r[11] = 4'h0; cga_g[11] = 4'hf; cga_b[11] = 4'hf;   // LIGHT CYAN
        cga_r[12] = 4'hf; cga_g[12] = 4'h0; cga_b[12] = 4'h0;   // LIGHT RED
        cga_r[13] = 4'hf; cga_g[13] = 4'h0; cga_b[13] = 4'hf;   // LIGHT MAGENTA
        cga_r[14] = 4'hf; cga_g[14] = 4'hf; cga_b[14] = 4'h0;   // YELLOW
        cga_r[15] = 4'hf; cga_g[15] = 4'hf; cga_b[15] = 4'hf;   // WHITE
    end

    wire cpuwrite;
    wire cpuread;

    assign cpuwrite = ncs | nwr;
    assign cpuread  = ncs | nrd;

    wire [7:0] dataaout;

    assign data = cpuread ? 8'bz : dataaout;

    always @(negedge cpuclk) begin

		if (!resetn) begin
            bram_aclock <= 0;
            bram_lock <= 0;
        end
        else begin

            counter <= counter + 1;

            if (|cled5) begin regled[5] <= 1; cled5 = cled5 - 1; end
                else
                regled[5] <= 0;

            if (|cled4) begin regled[4] <= 1; cled4 = cled4 - 1; end
                else
                regled[4] <= 0;

            if (|cled3) begin regled[3] <= 1; cled3 = cled3 - 1; end
                else
                regled[3] <= 0;

            if (!cpuwrite) begin

                if (!got_wr) begin
                    case (addr)
                        0: begin bramdatain <= data; wstate <= 1; end
                        1: begin cled5 <= 800000; bramwraddr[7:0] <= data; end
                        2: begin cled4 <= 800000; bramwraddr[15:8] <= data; wstate <= 6; end
                        default: cled3 <= 800000;
                    endcase

                    got_wr <= 1;

                end

            end
            else begin

                got_wr <= 0;

                case (wstate)
                    1: begin bram_lock <= 1; bram_awrite <= 1; wstate <= 2; end
                    2: begin bram_aclock = 1; wstate <= 3; end
                    3: begin bram_aclock = 0; wstate <= 4; end
                    4: begin bramwraddr <= bramwraddr + 1; bram_awrite <= 0; bram_lock = 0; wstate <= 0; end
                    
                    6: begin bram_aclock = 1; wstate <= 7; end
                    7: begin bram_aclock = 0; wstate <= 0; end
                endcase
            end


        end
    end

    always @(negedge clk) begin

		if (!resetn) begin
            pixelcount <= 0;
            memcounth <= 0;
            memcountl <= 0;
            presch <= 0;
            prescl <= 0;
		end
        else begin

            /////////////////
            if (!out_axis_tvalid || out_axis_tready) begin

                if (border) begin
                    color_index <= 0;
                    memcountl <= 0;
                    memcounth <= 0;
                    presch <= 0;
                    prescl <= 0;
                    prescnibble <= 0;
                end
                else 
                begin
                
                    color_index <= prescnibble[1] ? bramdataout[3:0] : bramdataout[7:4];
                    prescnibble <= prescnibble + 1;
                    
                    if (prescl == 3) begin
                        if (memcountl < 159)
                            memcountl <= memcountl + 1;
                        else begin
                            memcountl <= 0;
                            if (presch) memcounth <= memcounth + 160;
                            presch <= ~presch;
                        end
                    end

                    prescl <= prescl + 1;
                end

                if (pixelcount == 307199)
                begin
                    color_index <= 0;
                    memcountl <= 0;
                    memcounth <= 0;
                    presch <= 0;
                    prescl <= 0;
                    prescnibble <= 0;
                    pixelcount <= pixelcount + 1;
                end
                else
                if (pixelcount == 307200)
                    pixelcount <= 0;
                else
                    pixelcount <= pixelcount + 1;
            end
        end
    end

	always @(posedge clk) begin

		if (!resetn) begin
			out_axis_tvalid <= 0;
			out_axis_tdata <= 0;
			out_axis_tuser <= 0;
		end
        else begin
            if (!out_axis_tvalid || out_axis_tready) begin

                out_axis_tuser[0] <= !pixelcount;
//                if (!out_axis_tuser[0]) begin
//                end

                out_axis_tvalid <= 1;

                out_axis_tdata <= {b, g, r};
            end
        end
	end

//    Gowin_SDPB video_bram(
//        .dout(bramdataout), //output [7:0] dout
//        .clka(bram_aclock), //input clka
//        .cea(1),            //input cea
//        .reseta(0),         //input reseta
//        .clkb(clk),         //input clkb
//        .ceb(1),            //input ceb (read)
//        .resetb(0),         //input resetb
//        .oce(0),            //input oce
//        .ada(bramwraddr),   //input [15:0] ada
//        .din(bramdatain),   //input [7:0] din
//        .adb(bramrdaddr)    //input [15:0] adb
//    );

    Gowin_DPB your_instance_name(
        .douta(dataaout),      //output [7:0] douta
        .doutb(bramdataout),  //output [7:0] doutb
        .clka(bram_aclock),   //input clka
        .ocea(0),             //input ocea
        .cea(1),              //input cea
        .reseta(0),           //input reseta
        .wrea(bram_awrite),   //input wrea
        .clkb(clk),           //input clkb
        .oceb(0),             //input oceb
        .ceb(1),              //input ceb
        .resetb(0),           //input resetb
        .wreb(0),             //input wreb
        .ada(bramwraddr),     //input [15:0] ada
        .dina(bramdatain),    //input [7:0] dina
        .adb(bramrdaddr),     //input [15:0] adb
        .dinb(0)              //input [7:0] dinb
    );
endmodule
