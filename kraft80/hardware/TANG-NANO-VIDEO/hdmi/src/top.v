module top(

  inout [7:0] data,
  input ncs,
  input nwr,
  input nrd,
  input nrst,
  input [2:0] addr,
  output [5:0] led,
  input cpuclk,

  input clk,
  input resetn,
  output       tmds_clk_n,
  output       tmds_clk_p,
  output [2:0] tmds_d_n,
  output [2:0] tmds_d_p,
  output oclk,
  output oen
);

  assign oclk = clk_p;
  assign oen = ncs | nwr;


//    reg [31:0] counter;
//    assign led = ~counter[28:22];
//    always @ (posedge clk) begin
//    counter <= counter + 1;
//    end

Gowin_rPLL u_pll (
  .clkin(clk),
  .clkout(clk_p5),
  .lock(pll_lock)
);

Gowin_CLKDIV u_div_5 (
    .clkout(clk_p),
    .hclkin(clk_p5),
    .resetn(pll_lock)
);

Reset_Sync u_Reset_Sync (
  .resetn(sys_resetn),
  .ext_reset(resetn & pll_lock),
  .clk(clk_p)
);
 
svo_hdmi svo_hdmi_inst (

  .data(data),
  .ncs(ncs),
  .nwr(nwr),
  .nrd(nrd),
  .nrst(nrst),
  .addr(addr),
  .led(led),
  .cpuclk(cpuclk),

	.clk(clk_p),
	.resetn(sys_resetn),

	// video clocks
	.clk_pixel(clk_p),
	.clk_5x_pixel(clk_p5),
	.locked(pll_lock),

	// output signals
	.tmds_clk_n(tmds_clk_n),
	.tmds_clk_p(tmds_clk_p),
	.tmds_d_n(tmds_d_n),
	.tmds_d_p(tmds_d_p)
);

endmodule

module Reset_Sync (
 input clk,
 input ext_reset,
 output resetn
);

 reg [3:0] reset_cnt = 0;
 
 always @(posedge clk or negedge ext_reset) begin
     if (~ext_reset)
         reset_cnt <= 4'b0;
     else
         reset_cnt <= reset_cnt + !resetn;
 end
 
 assign resetn = &reset_cnt;

endmodule