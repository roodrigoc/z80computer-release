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

module svo_term #(
	`SVO_DEFAULT_PARAMS
) (
	// resetn clock domain: clk
	input clk, oclk, resetn,

	// input stream
	//
	// clock domain: clk
	//
	input        in_axis_tvalid,
	output       in_axis_tready,
	input  [7:0] in_axis_tdata,

	// output stream
	//   tuser[0] ... start of frame
	
	output       out_axis_tvalid,
	input        out_axis_tready,
	output [1:0] out_axis_tdata,
	output [0:0] out_axis_tuser
);
	`SVO_DECLS

	wire pipeline_en;

	// --------------------------------------------------------------
	// Video Pipeline
	// --------------------------------------------------------------

	reg [3:0] oresetn_q;
	reg oresetn;

	// synchronize oresetn with oclk
	always @(posedge oclk)
		{oresetn, oresetn_q} <= {oresetn_q, resetn};

	// --------------------------------------------------------------
	// Pipeline stage 1: basic video timing

	reg p1_start_of_frame;
	reg p1_start_of_line;
	reg p1_valid;

	reg [`SVO_XYBITS-1:0] p1_xpos, p1_ypos;

	always @(posedge oclk) begin
		if (!oresetn) begin
			p1_xpos <= 0;
			p1_ypos <= 0;
			p1_valid <= 0;
		end else
		if (pipeline_en) begin
			p1_valid <= 1;
			p1_start_of_frame <= !p1_xpos && !p1_ypos;
			p1_start_of_line <= !p1_xpos;
			if (p1_xpos == SVO_HOR_PIXELS-1) begin
				p1_xpos <= 0;
				p1_ypos <= p1_ypos == SVO_VER_PIXELS-1 ? 0 : p1_ypos + 1;
			end else begin
				p1_xpos <= p1_xpos + 1;
			end
		end
	end

	// --------------------------------------------------------------
	// Pipeline stage 2: text memory addr generator

	reg p2_start_of_frame;
	reg p2_start_of_line;
	reg p2_valid;
	reg p2_found_end, p2_last_req_remline;

	always @(posedge oclk) begin
		if (!oresetn) begin
			p2_valid <= 0;
			p2_found_end <= 1;
			p2_last_req_remline <= 1;
		end else
		if (pipeline_en) begin
			p2_start_of_frame <= p1_start_of_frame;
			p2_start_of_line <= p1_start_of_line;
			p2_valid <= p1_valid;

			if (p1_start_of_frame) begin
				if (!p2_found_end && !p2_last_req_remline) begin
					p2_last_req_remline <= 1;
				end else
					p2_last_req_remline <= 0;
			end
		end
	end

	// --------------------------------------------------------------
	// Pipeline stage 3: wait for memory

	reg p3_start_of_frame;
	reg p3_start_of_line;
	reg p3_valid;

	always @(posedge oclk) begin
		if (!oresetn) begin
			p3_valid <= 0;
		end else
		if (pipeline_en) begin
			p3_start_of_frame <= p2_start_of_frame;
			p3_start_of_line <= p2_start_of_line;
			p3_valid <= p2_valid;
		end
	end

	// --------------------------------------------------------------
	// Pipeline stage 4: read char

	reg p4_start_of_frame;
	reg p4_valid;

	always @(posedge oclk) begin
		if (!oresetn) begin
			p4_valid <= 0;
		end else
		if (pipeline_en) begin
			p4_start_of_frame <= p3_start_of_frame;
			p4_valid <= p3_valid;
		end
	end

	// --------------------------------------------------------------
	// Pipeline stage 5: font lookup

	reg p5_start_of_frame;
	reg p5_valid;

	always @(posedge oclk) begin
		if (!oresetn) begin
			p5_valid <= 0;
		end else
		if (pipeline_en) begin
			p5_start_of_frame <= p4_start_of_frame;
			p5_valid <= p4_valid;
		end
	end

	// --------------------------------------------------------------
	// Pipeline output stage

	assign pipeline_en = !p5_valid || out_axis_tready;
	assign out_axis_tvalid = p5_valid;
	assign out_axis_tdata = 0;
	assign out_axis_tuser = p5_start_of_frame;

endmodule


