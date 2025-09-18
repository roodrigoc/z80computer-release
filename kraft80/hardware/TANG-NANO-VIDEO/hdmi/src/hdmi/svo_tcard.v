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
    input [3:0] addr,
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

    reg[15:0] wraddr_tmp;
    reg [7:0] bramdatain_tmp;

    reg[15:0] bramwraddr;
    reg [7:0] bramdatain;
    wire[7:0] bramdataout;
    wire[15:0] bramrdaddr;
    
    reg bram_awrite;
    reg bram_aclock;
    reg bram_lock;

    reg[4:0] wstate;
    reg got_wr;
    reg got_rd;

    // CGA Mapping colors
    reg [3:0] cga_r[15:0];
    reg [3:0] cga_g[15:0];
    reg [3:0] cga_b[15:0];

    wire[3:0] color_index;
    assign r[7:4] = cga_r[color_index];
    assign g[7:4] = cga_g[color_index];
    assign b[7:4] = cga_b[color_index];
    assign r[3:0] = 0;
    assign g[3:0] = 0;
    assign b[3:0] = 0;

    reg [18:0] pixelcount;

    reg [31:0] cled5;
    reg [31:0] cled4;
    reg [31:0] cled3;
    reg [5:2] regled;

    reg [31:0] counter;
    assign led[1] = counter[18];

    assign led[0] = ~(regled[5]&regled[4]);

    assign led[5:2] = ~regled;

    reg videomode;

    reg [7:0] screenbasereg;
    reg [12:0] screenbase;

    initial begin
        got_wr = 0;
        got_rd = 0;

        videomode = 0;
        wstate <= 0;
        bramwraddr <= 0;

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

        screenbase = 0;
    end

    wire cpuwrite;
    wire cpuread;

    wire ncs2;
    assign ncs2 = ncs | (addr > 3);

    assign cpuwrite = ncs2 | nwr;
    assign cpuread  = ncs2 | nrd;

    wire [7:0] dataaout;

    assign data = cpuread ? 8'bz : dataaout;

    always @(negedge cpuclk) begin

		if (!nrst) begin
            bram_aclock <= 0;
            bram_lock <= 0;
            screenbase = 0;
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

            if (!nrst) begin
                got_wr = 0;
                got_rd = 0;
            end
            else begin
                if (!cpuwrite) begin

                    if (!got_wr) begin
                        case (addr)
                            0: begin bramdatain <= data; wstate <= 1; end
                            1: begin cled5 <= 800000; bramwraddr[7:0] <= data; end
                            2: begin cled4 <= 800000; bramwraddr[15:8] <= data; wstate <= 6; end
                            3:
// DATA
// 0000---x : select videmode in x
// 0001xxxx : select starting line [3:0] in xxxx
// 0010xxxx : select starting line [7:4] in xxxx
                                case(data[7:4])
                                    0: begin videomode = data[0]; bramdatain <= 0; bramwraddr <= 0; bram_awrite <= 1; wstate <= 10; end
                                    1: screenbasereg[3:0] = data[3:0];
                                    2: begin screenbasereg[7:4] = data[3:0]; screenbase = 80*screenbasereg; end
                                endcase
                            default: cled3 <= 800000;
                        endcase

                        got_wr <= 1;

                    end
                end
                if (!cpuread) begin
                    got_rd <= 1;
                end
                else begin

                    if (got_rd) begin
                        if (!videomode) begin
                            bramwraddr <= bramwraddr + 1;   // In Text Mode increment after read
                            wstate <= 5;
                        end
                        got_rd <= 0;
                    end

                    got_wr <= 0;

                    case (wstate)
                        1: begin bram_lock <= 1; bram_awrite <= 1; wstate <= 2; end
                        2: begin bram_aclock = 1; wstate <= 3; end
                        3: begin bram_aclock = 0; wstate <= 4; end
                        4: begin bramwraddr <= bramwraddr + 1; bram_awrite <= 0; bram_lock = 0; wstate <= 0; end
                        5: wstate <= 6;
                        6: begin bram_aclock = 1; wstate <= 7; end
                        7: begin bram_aclock = 0; wstate <= 0; end
                       10: begin bram_aclock = 1; wstate <= 11; end
                       11: begin bram_aclock = 0; wstate <= 12; bramwraddr <= bramwraddr + 1; end
                       12: if (bramwraddr == 38400) begin bramwraddr <= 0; wstate <= 0; bram_awrite <= 0; end else wstate <= 10;

                    endcase
                end
            end
        end
    end

    always @(negedge clk) begin

		if (!resetn) begin
            pixelcount <= 0;
		end
        else begin

            /////////////////
            if (!out_axis_tvalid || out_axis_tready) begin

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

                out_axis_tvalid <= 1;

                out_axis_tdata <= {b, g, r};
            end
        end
	end

    wire[15:0] bramrdaddr_mode0;
    wire[15:0] bramrdaddr_mode1;
    wire[3:0] color_index_mode0;
    wire[3:0] color_index_mode1;

    textmode_80x60 txtmode0 ( .pixelcount(pixelcount),
                              .color_index(color_index_mode0),
                              .clk(clk),
                              .out_axis_tvalid(out_axis_tvalid),
                              .out_axis_tready(out_axis_tready),
                              .resetn(resetn),
                              .bramrdaddr(bramrdaddr_mode0),
                              .bramdataout(bramdataout),
                              .bramwraddr(bramwraddr),
                              .bram_lock(bram_lock),
                              .screenbase(screenbase));

    graphmode_320x240_4bpp grmode1 ( .pixelcount(pixelcount),
                                     .color_index(color_index_mode1),
                                     .clk(clk),
                                     .out_axis_tvalid(out_axis_tvalid),
                                     .out_axis_tready(out_axis_tready),
                                     .resetn(resetn),
                                     .bramrdaddr(bramrdaddr_mode1),
                                     .bramdataout(bramdataout),
                                     .bram_lock(bram_lock),
                                     .bramwraddr(bramwraddr));

    //wire[15:0] bramrdaddr;

    assign bramrdaddr = videomode?bramrdaddr_mode1:bramrdaddr_mode0;
    assign color_index = videomode?color_index_mode1:color_index_mode0;

    Gowin_DPB your_instance_name(
        .douta(dataaout),      //output [7:0] douta
        .doutb(bramdataout),  //output [7:0] doutb
        .clka(bram_aclock),   //input clka
        .ocea(1'b0),             //input ocea
        .cea(1'b1),              //input cea
        .reseta(1'b0),           //input reseta
        .wrea(bram_awrite),   //input wrea
        .clkb(clk),           //input clkb
        .oceb(1'b0),             //input oceb
        .ceb(1'b1),              //input ceb
        .resetb(1'b0),           //input resetb
        .wreb(1'b0),             //input wreb
        .ada(bramwraddr),     //input [15:0] ada
        .dina(bramdatain),    //input [7:0] dina
        .adb(bramrdaddr),     //input [15:0] adb
        .dinb(8'b0)              //input [7:0] dinb
    );


endmodule

/////////////////////////////////////////////////////////////////////////////////
module graphmode_320x240_4bpp (

    input [18:0] pixelcount,
    output reg [3:0] color_index,
    input clk,
    input out_axis_tvalid,
    input out_axis_tready,
    input resetn,
    output [15:0] bramrdaddr,
    input [7:0] bramdataout,
    input bram_lock,
    input[15:0] bramwraddr
);

    reg [16:0] memcounth;
    reg [7:0] memcountl;
    reg presch;
    reg [1:0]prescl;
    reg [1:0]prescnibble;

    wire[16:0] memrdpos;
    assign memrdpos = memcounth + memcountl;

    assign bramrdaddr = bram_lock & (bramwraddr == memrdpos) ? 38400 : memrdpos;
    //assign bramrdaddr = memrdpos;
    always @(negedge clk) begin

		if (!resetn) begin
            memcounth <= 0;
            memcountl <= 0;
            presch <= 0;
            prescl <= 0;
		end
        else begin

            /////////////////
            if (!out_axis_tvalid || out_axis_tready) begin

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

                if (pixelcount == 307199)
                begin
                    color_index <= 0;
                    memcountl <= 0;
                    memcounth <= 0;
                    presch <= 0;
                    prescl <= 0;
                    prescnibble <= 0;
                end
            end
        end
    end

endmodule

/////////////////////////////////////////////////////////////////////////////////
module textmode_80x60 (

    input [18:0] pixelcount,
    output reg [3:0] color_index,
    input clk,
    input out_axis_tvalid,
    input out_axis_tready,
    input resetn,
    output [15:0] bramrdaddr,
    input [7:0] bramdataout,
    input [15:0] bramwraddr,
    input bram_lock,
    input[12:0] screenbase
);

	// --------------------------------------------------------------
	// Font Memory
	// --------------------------------------------------------------
`include "termfont_new.vh"

	function font(input [7:0] c, input [2:0] x, input [2:0] y);
		font = fontmem_new[{c, y, x}];
	endfunction

    reg[8:0] rastercount;
    reg[2:0] subrastercount;
    reg[9:0] hpixelcount;
    reg[12:0] memlinebase;

    wire[16:0] memrdpos;
    assign memrdpos = (hpixelcount >> 3) + memlinebase;

    assign bramrdaddr = bram_lock & (bramwraddr == memrdpos) ? 38400 : memrdpos;
    //assign bramrdaddr = memrdpos;

    reg[5:0] cursorcount;
    wire iscursor;
    assign iscursor = cursorcount[5] & ((bramrdaddr == bramwraddr)&&(subrastercount == 7)) ;

    always @(negedge clk) begin

		if (!resetn) begin
		end
        else begin

            /////////////////
            if (!out_axis_tvalid || out_axis_tready) begin

                color_index <= iscursor ^ font(bramdataout,hpixelcount[2:0],rastercount[2:0]) ? 10 : 0;

                if (hpixelcount == 639) begin

                    hpixelcount <= 0;
                    rastercount <= rastercount + 1;

                    if (subrastercount == 7) begin
                        
                        if (memlinebase < (80*59))
                            memlinebase <= memlinebase + 80;
                        else
                            memlinebase <= 0;
                    end
                    subrastercount <= subrastercount + 1;
                end
                else
                    hpixelcount <= hpixelcount + 1;

                if (pixelcount == 307199)
                begin
                    cursorcount = cursorcount + 1;
                    color_index <= 0;
                    rastercount <= 0;
                    subrastercount <= 0;
                    hpixelcount <= 0;
                    memlinebase <= screenbase;
                end
            end
        end
    end

endmodule



