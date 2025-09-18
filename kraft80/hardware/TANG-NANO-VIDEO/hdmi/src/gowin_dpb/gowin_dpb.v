//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.12 (64-bit)
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9
//Device Version: C
//Created Time: Thu Sep 18 19:01:04 2025

module Gowin_DPB (douta, doutb, clka, ocea, cea, reseta, wrea, clkb, oceb, ceb, resetb, wreb, ada, dina, adb, dinb);

output [7:0] douta;
output [7:0] doutb;
input clka;
input ocea;
input cea;
input reseta;
input wrea;
input clkb;
input oceb;
input ceb;
input resetb;
input wreb;
input [15:0] ada;
input [7:0] dina;
input [15:0] adb;
input [7:0] dinb;

wire lut_f_0;
wire lut_f_1;
wire lut_f_2;
wire lut_f_3;
wire lut_f_4;
wire lut_f_5;
wire lut_f_6;
wire lut_f_7;
wire lut_f_8;
wire lut_f_9;
wire lut_f_10;
wire lut_f_11;
wire lut_f_12;
wire lut_f_13;
wire lut_f_14;
wire lut_f_15;
wire lut_f_16;
wire lut_f_17;
wire lut_f_18;
wire lut_f_19;
wire [11:0] dpb_inst_0_douta_w;
wire [3:0] dpb_inst_0_douta;
wire [11:0] dpb_inst_0_doutb_w;
wire [3:0] dpb_inst_0_doutb;
wire [11:0] dpb_inst_1_douta_w;
wire [3:0] dpb_inst_1_douta;
wire [11:0] dpb_inst_1_doutb_w;
wire [3:0] dpb_inst_1_doutb;
wire [11:0] dpb_inst_2_douta_w;
wire [3:0] dpb_inst_2_douta;
wire [11:0] dpb_inst_2_doutb_w;
wire [3:0] dpb_inst_2_doutb;
wire [11:0] dpb_inst_3_douta_w;
wire [3:0] dpb_inst_3_douta;
wire [11:0] dpb_inst_3_doutb_w;
wire [3:0] dpb_inst_3_doutb;
wire [11:0] dpb_inst_4_douta_w;
wire [3:0] dpb_inst_4_douta;
wire [11:0] dpb_inst_4_doutb_w;
wire [3:0] dpb_inst_4_doutb;
wire [11:0] dpb_inst_5_douta_w;
wire [3:0] dpb_inst_5_douta;
wire [11:0] dpb_inst_5_doutb_w;
wire [3:0] dpb_inst_5_doutb;
wire [11:0] dpb_inst_6_douta_w;
wire [3:0] dpb_inst_6_douta;
wire [11:0] dpb_inst_6_doutb_w;
wire [3:0] dpb_inst_6_doutb;
wire [11:0] dpb_inst_7_douta_w;
wire [3:0] dpb_inst_7_douta;
wire [11:0] dpb_inst_7_doutb_w;
wire [3:0] dpb_inst_7_doutb;
wire [11:0] dpb_inst_8_douta_w;
wire [7:4] dpb_inst_8_douta;
wire [11:0] dpb_inst_8_doutb_w;
wire [7:4] dpb_inst_8_doutb;
wire [11:0] dpb_inst_9_douta_w;
wire [7:4] dpb_inst_9_douta;
wire [11:0] dpb_inst_9_doutb_w;
wire [7:4] dpb_inst_9_doutb;
wire [11:0] dpb_inst_10_douta_w;
wire [7:4] dpb_inst_10_douta;
wire [11:0] dpb_inst_10_doutb_w;
wire [7:4] dpb_inst_10_doutb;
wire [11:0] dpb_inst_11_douta_w;
wire [7:4] dpb_inst_11_douta;
wire [11:0] dpb_inst_11_doutb_w;
wire [7:4] dpb_inst_11_doutb;
wire [11:0] dpb_inst_12_douta_w;
wire [7:4] dpb_inst_12_douta;
wire [11:0] dpb_inst_12_doutb_w;
wire [7:4] dpb_inst_12_doutb;
wire [11:0] dpb_inst_13_douta_w;
wire [7:4] dpb_inst_13_douta;
wire [11:0] dpb_inst_13_doutb_w;
wire [7:4] dpb_inst_13_doutb;
wire [11:0] dpb_inst_14_douta_w;
wire [7:4] dpb_inst_14_douta;
wire [11:0] dpb_inst_14_doutb_w;
wire [7:4] dpb_inst_14_doutb;
wire [11:0] dpb_inst_15_douta_w;
wire [7:4] dpb_inst_15_douta;
wire [11:0] dpb_inst_15_doutb_w;
wire [7:4] dpb_inst_15_doutb;
wire [11:0] dpb_inst_16_douta_w;
wire [3:0] dpb_inst_16_douta;
wire [11:0] dpb_inst_16_doutb_w;
wire [3:0] dpb_inst_16_doutb;
wire [11:0] dpb_inst_17_douta_w;
wire [7:4] dpb_inst_17_douta;
wire [11:0] dpb_inst_17_doutb_w;
wire [7:4] dpb_inst_17_doutb;
wire [7:0] dpb_inst_18_douta_w;
wire [7:0] dpb_inst_18_douta;
wire [7:0] dpb_inst_18_doutb_w;
wire [7:0] dpb_inst_18_doutb;
wire dff_q_0;
wire dff_q_1;
wire dff_q_2;
wire dff_q_3;
wire dff_q_4;
wire dff_q_5;
wire dff_q_6;
wire dff_q_7;
wire mux_o_10;
wire mux_o_11;
wire mux_o_12;
wire mux_o_13;
wire mux_o_14;
wire mux_o_15;
wire mux_o_16;
wire mux_o_18;
wire mux_o_31;
wire mux_o_32;
wire mux_o_33;
wire mux_o_34;
wire mux_o_35;
wire mux_o_36;
wire mux_o_37;
wire mux_o_39;
wire mux_o_52;
wire mux_o_53;
wire mux_o_54;
wire mux_o_55;
wire mux_o_56;
wire mux_o_57;
wire mux_o_58;
wire mux_o_60;
wire mux_o_73;
wire mux_o_74;
wire mux_o_75;
wire mux_o_76;
wire mux_o_77;
wire mux_o_78;
wire mux_o_79;
wire mux_o_81;
wire mux_o_94;
wire mux_o_95;
wire mux_o_96;
wire mux_o_97;
wire mux_o_98;
wire mux_o_99;
wire mux_o_100;
wire mux_o_102;
wire mux_o_115;
wire mux_o_116;
wire mux_o_117;
wire mux_o_118;
wire mux_o_119;
wire mux_o_120;
wire mux_o_121;
wire mux_o_123;
wire mux_o_136;
wire mux_o_137;
wire mux_o_138;
wire mux_o_139;
wire mux_o_140;
wire mux_o_141;
wire mux_o_142;
wire mux_o_144;
wire mux_o_157;
wire mux_o_158;
wire mux_o_159;
wire mux_o_160;
wire mux_o_161;
wire mux_o_162;
wire mux_o_163;
wire mux_o_165;
wire mux_o_178;
wire mux_o_179;
wire mux_o_180;
wire mux_o_181;
wire mux_o_182;
wire mux_o_183;
wire mux_o_184;
wire mux_o_186;
wire mux_o_199;
wire mux_o_200;
wire mux_o_201;
wire mux_o_202;
wire mux_o_203;
wire mux_o_204;
wire mux_o_205;
wire mux_o_207;
wire mux_o_220;
wire mux_o_221;
wire mux_o_222;
wire mux_o_223;
wire mux_o_224;
wire mux_o_225;
wire mux_o_226;
wire mux_o_228;
wire mux_o_241;
wire mux_o_242;
wire mux_o_243;
wire mux_o_244;
wire mux_o_245;
wire mux_o_246;
wire mux_o_247;
wire mux_o_249;
wire mux_o_262;
wire mux_o_263;
wire mux_o_264;
wire mux_o_265;
wire mux_o_266;
wire mux_o_267;
wire mux_o_268;
wire mux_o_270;
wire mux_o_283;
wire mux_o_284;
wire mux_o_285;
wire mux_o_286;
wire mux_o_287;
wire mux_o_288;
wire mux_o_289;
wire mux_o_291;
wire mux_o_304;
wire mux_o_305;
wire mux_o_306;
wire mux_o_307;
wire mux_o_308;
wire mux_o_309;
wire mux_o_310;
wire mux_o_312;
wire mux_o_325;
wire mux_o_326;
wire mux_o_327;
wire mux_o_328;
wire mux_o_329;
wire mux_o_330;
wire mux_o_331;
wire mux_o_333;
wire cea_w;
wire ceb_w;
wire gw_gnd;

assign cea_w = ~wrea & cea;
assign ceb_w = ~wreb & ceb;
assign gw_gnd = 1'b0;

LUT4 lut_inst_0 (
  .F(lut_f_0),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_0.INIT = 16'h0001;
LUT4 lut_inst_1 (
  .F(lut_f_1),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_1.INIT = 16'h0002;
LUT4 lut_inst_2 (
  .F(lut_f_2),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_2.INIT = 16'h0004;
LUT4 lut_inst_3 (
  .F(lut_f_3),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_3.INIT = 16'h0008;
LUT4 lut_inst_4 (
  .F(lut_f_4),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_4.INIT = 16'h0010;
LUT4 lut_inst_5 (
  .F(lut_f_5),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_5.INIT = 16'h0020;
LUT4 lut_inst_6 (
  .F(lut_f_6),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_6.INIT = 16'h0040;
LUT4 lut_inst_7 (
  .F(lut_f_7),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_7.INIT = 16'h0080;
LUT4 lut_inst_8 (
  .F(lut_f_8),
  .I0(ada[12]),
  .I1(ada[13]),
  .I2(ada[14]),
  .I3(ada[15])
);
defparam lut_inst_8.INIT = 16'h0100;
LUT5 lut_inst_9 (
  .F(lut_f_9),
  .I0(ada[11]),
  .I1(ada[12]),
  .I2(ada[13]),
  .I3(ada[14]),
  .I4(ada[15])
);
defparam lut_inst_9.INIT = 32'h00040000;
LUT4 lut_inst_10 (
  .F(lut_f_10),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_10.INIT = 16'h0001;
LUT4 lut_inst_11 (
  .F(lut_f_11),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_11.INIT = 16'h0002;
LUT4 lut_inst_12 (
  .F(lut_f_12),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_12.INIT = 16'h0004;
LUT4 lut_inst_13 (
  .F(lut_f_13),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_13.INIT = 16'h0008;
LUT4 lut_inst_14 (
  .F(lut_f_14),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_14.INIT = 16'h0010;
LUT4 lut_inst_15 (
  .F(lut_f_15),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_15.INIT = 16'h0020;
LUT4 lut_inst_16 (
  .F(lut_f_16),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_16.INIT = 16'h0040;
LUT4 lut_inst_17 (
  .F(lut_f_17),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_17.INIT = 16'h0080;
LUT4 lut_inst_18 (
  .F(lut_f_18),
  .I0(adb[12]),
  .I1(adb[13]),
  .I2(adb[14]),
  .I3(adb[15])
);
defparam lut_inst_18.INIT = 16'h0100;
LUT5 lut_inst_19 (
  .F(lut_f_19),
  .I0(adb[11]),
  .I1(adb[12]),
  .I2(adb[13]),
  .I3(adb[14]),
  .I4(adb[15])
);
defparam lut_inst_19.INIT = 32'h00040000;
DPB dpb_inst_0 (
    .DOA({dpb_inst_0_douta_w[11:0],dpb_inst_0_douta[3:0]}),
    .DOB({dpb_inst_0_doutb_w[11:0],dpb_inst_0_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_0}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_10}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_0.READ_MODE0 = 1'b0;
defparam dpb_inst_0.READ_MODE1 = 1'b0;
defparam dpb_inst_0.WRITE_MODE0 = 2'b00;
defparam dpb_inst_0.WRITE_MODE1 = 2'b00;
defparam dpb_inst_0.BIT_WIDTH_0 = 4;
defparam dpb_inst_0.BIT_WIDTH_1 = 4;
defparam dpb_inst_0.BLK_SEL_0 = 3'b001;
defparam dpb_inst_0.BLK_SEL_1 = 3'b001;
defparam dpb_inst_0.RESET_MODE = "SYNC";

DPB dpb_inst_1 (
    .DOA({dpb_inst_1_douta_w[11:0],dpb_inst_1_douta[3:0]}),
    .DOB({dpb_inst_1_doutb_w[11:0],dpb_inst_1_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_1}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_11}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_1.READ_MODE0 = 1'b0;
defparam dpb_inst_1.READ_MODE1 = 1'b0;
defparam dpb_inst_1.WRITE_MODE0 = 2'b00;
defparam dpb_inst_1.WRITE_MODE1 = 2'b00;
defparam dpb_inst_1.BIT_WIDTH_0 = 4;
defparam dpb_inst_1.BIT_WIDTH_1 = 4;
defparam dpb_inst_1.BLK_SEL_0 = 3'b001;
defparam dpb_inst_1.BLK_SEL_1 = 3'b001;
defparam dpb_inst_1.RESET_MODE = "SYNC";

DPB dpb_inst_2 (
    .DOA({dpb_inst_2_douta_w[11:0],dpb_inst_2_douta[3:0]}),
    .DOB({dpb_inst_2_doutb_w[11:0],dpb_inst_2_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_2}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_12}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_2.READ_MODE0 = 1'b0;
defparam dpb_inst_2.READ_MODE1 = 1'b0;
defparam dpb_inst_2.WRITE_MODE0 = 2'b00;
defparam dpb_inst_2.WRITE_MODE1 = 2'b00;
defparam dpb_inst_2.BIT_WIDTH_0 = 4;
defparam dpb_inst_2.BIT_WIDTH_1 = 4;
defparam dpb_inst_2.BLK_SEL_0 = 3'b001;
defparam dpb_inst_2.BLK_SEL_1 = 3'b001;
defparam dpb_inst_2.RESET_MODE = "SYNC";

DPB dpb_inst_3 (
    .DOA({dpb_inst_3_douta_w[11:0],dpb_inst_3_douta[3:0]}),
    .DOB({dpb_inst_3_doutb_w[11:0],dpb_inst_3_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_3}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_13}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_3.READ_MODE0 = 1'b0;
defparam dpb_inst_3.READ_MODE1 = 1'b0;
defparam dpb_inst_3.WRITE_MODE0 = 2'b00;
defparam dpb_inst_3.WRITE_MODE1 = 2'b00;
defparam dpb_inst_3.BIT_WIDTH_0 = 4;
defparam dpb_inst_3.BIT_WIDTH_1 = 4;
defparam dpb_inst_3.BLK_SEL_0 = 3'b001;
defparam dpb_inst_3.BLK_SEL_1 = 3'b001;
defparam dpb_inst_3.RESET_MODE = "SYNC";

DPB dpb_inst_4 (
    .DOA({dpb_inst_4_douta_w[11:0],dpb_inst_4_douta[3:0]}),
    .DOB({dpb_inst_4_doutb_w[11:0],dpb_inst_4_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_4}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_14}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_4.READ_MODE0 = 1'b0;
defparam dpb_inst_4.READ_MODE1 = 1'b0;
defparam dpb_inst_4.WRITE_MODE0 = 2'b00;
defparam dpb_inst_4.WRITE_MODE1 = 2'b00;
defparam dpb_inst_4.BIT_WIDTH_0 = 4;
defparam dpb_inst_4.BIT_WIDTH_1 = 4;
defparam dpb_inst_4.BLK_SEL_0 = 3'b001;
defparam dpb_inst_4.BLK_SEL_1 = 3'b001;
defparam dpb_inst_4.RESET_MODE = "SYNC";

DPB dpb_inst_5 (
    .DOA({dpb_inst_5_douta_w[11:0],dpb_inst_5_douta[3:0]}),
    .DOB({dpb_inst_5_doutb_w[11:0],dpb_inst_5_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_5}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_15}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_5.READ_MODE0 = 1'b0;
defparam dpb_inst_5.READ_MODE1 = 1'b0;
defparam dpb_inst_5.WRITE_MODE0 = 2'b00;
defparam dpb_inst_5.WRITE_MODE1 = 2'b00;
defparam dpb_inst_5.BIT_WIDTH_0 = 4;
defparam dpb_inst_5.BIT_WIDTH_1 = 4;
defparam dpb_inst_5.BLK_SEL_0 = 3'b001;
defparam dpb_inst_5.BLK_SEL_1 = 3'b001;
defparam dpb_inst_5.RESET_MODE = "SYNC";

DPB dpb_inst_6 (
    .DOA({dpb_inst_6_douta_w[11:0],dpb_inst_6_douta[3:0]}),
    .DOB({dpb_inst_6_doutb_w[11:0],dpb_inst_6_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_6}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_16}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_6.READ_MODE0 = 1'b0;
defparam dpb_inst_6.READ_MODE1 = 1'b0;
defparam dpb_inst_6.WRITE_MODE0 = 2'b00;
defparam dpb_inst_6.WRITE_MODE1 = 2'b00;
defparam dpb_inst_6.BIT_WIDTH_0 = 4;
defparam dpb_inst_6.BIT_WIDTH_1 = 4;
defparam dpb_inst_6.BLK_SEL_0 = 3'b001;
defparam dpb_inst_6.BLK_SEL_1 = 3'b001;
defparam dpb_inst_6.RESET_MODE = "SYNC";

DPB dpb_inst_7 (
    .DOA({dpb_inst_7_douta_w[11:0],dpb_inst_7_douta[3:0]}),
    .DOB({dpb_inst_7_doutb_w[11:0],dpb_inst_7_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_7}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_17}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_7.READ_MODE0 = 1'b0;
defparam dpb_inst_7.READ_MODE1 = 1'b0;
defparam dpb_inst_7.WRITE_MODE0 = 2'b00;
defparam dpb_inst_7.WRITE_MODE1 = 2'b00;
defparam dpb_inst_7.BIT_WIDTH_0 = 4;
defparam dpb_inst_7.BIT_WIDTH_1 = 4;
defparam dpb_inst_7.BLK_SEL_0 = 3'b001;
defparam dpb_inst_7.BLK_SEL_1 = 3'b001;
defparam dpb_inst_7.RESET_MODE = "SYNC";

DPB dpb_inst_8 (
    .DOA({dpb_inst_8_douta_w[11:0],dpb_inst_8_douta[7:4]}),
    .DOB({dpb_inst_8_doutb_w[11:0],dpb_inst_8_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_0}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_10}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_8.READ_MODE0 = 1'b0;
defparam dpb_inst_8.READ_MODE1 = 1'b0;
defparam dpb_inst_8.WRITE_MODE0 = 2'b00;
defparam dpb_inst_8.WRITE_MODE1 = 2'b00;
defparam dpb_inst_8.BIT_WIDTH_0 = 4;
defparam dpb_inst_8.BIT_WIDTH_1 = 4;
defparam dpb_inst_8.BLK_SEL_0 = 3'b001;
defparam dpb_inst_8.BLK_SEL_1 = 3'b001;
defparam dpb_inst_8.RESET_MODE = "SYNC";

DPB dpb_inst_9 (
    .DOA({dpb_inst_9_douta_w[11:0],dpb_inst_9_douta[7:4]}),
    .DOB({dpb_inst_9_doutb_w[11:0],dpb_inst_9_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_1}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_11}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_9.READ_MODE0 = 1'b0;
defparam dpb_inst_9.READ_MODE1 = 1'b0;
defparam dpb_inst_9.WRITE_MODE0 = 2'b00;
defparam dpb_inst_9.WRITE_MODE1 = 2'b00;
defparam dpb_inst_9.BIT_WIDTH_0 = 4;
defparam dpb_inst_9.BIT_WIDTH_1 = 4;
defparam dpb_inst_9.BLK_SEL_0 = 3'b001;
defparam dpb_inst_9.BLK_SEL_1 = 3'b001;
defparam dpb_inst_9.RESET_MODE = "SYNC";

DPB dpb_inst_10 (
    .DOA({dpb_inst_10_douta_w[11:0],dpb_inst_10_douta[7:4]}),
    .DOB({dpb_inst_10_doutb_w[11:0],dpb_inst_10_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_2}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_12}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_10.READ_MODE0 = 1'b0;
defparam dpb_inst_10.READ_MODE1 = 1'b0;
defparam dpb_inst_10.WRITE_MODE0 = 2'b00;
defparam dpb_inst_10.WRITE_MODE1 = 2'b00;
defparam dpb_inst_10.BIT_WIDTH_0 = 4;
defparam dpb_inst_10.BIT_WIDTH_1 = 4;
defparam dpb_inst_10.BLK_SEL_0 = 3'b001;
defparam dpb_inst_10.BLK_SEL_1 = 3'b001;
defparam dpb_inst_10.RESET_MODE = "SYNC";

DPB dpb_inst_11 (
    .DOA({dpb_inst_11_douta_w[11:0],dpb_inst_11_douta[7:4]}),
    .DOB({dpb_inst_11_doutb_w[11:0],dpb_inst_11_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_3}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_13}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_11.READ_MODE0 = 1'b0;
defparam dpb_inst_11.READ_MODE1 = 1'b0;
defparam dpb_inst_11.WRITE_MODE0 = 2'b00;
defparam dpb_inst_11.WRITE_MODE1 = 2'b00;
defparam dpb_inst_11.BIT_WIDTH_0 = 4;
defparam dpb_inst_11.BIT_WIDTH_1 = 4;
defparam dpb_inst_11.BLK_SEL_0 = 3'b001;
defparam dpb_inst_11.BLK_SEL_1 = 3'b001;
defparam dpb_inst_11.RESET_MODE = "SYNC";

DPB dpb_inst_12 (
    .DOA({dpb_inst_12_douta_w[11:0],dpb_inst_12_douta[7:4]}),
    .DOB({dpb_inst_12_doutb_w[11:0],dpb_inst_12_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_4}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_14}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_12.READ_MODE0 = 1'b0;
defparam dpb_inst_12.READ_MODE1 = 1'b0;
defparam dpb_inst_12.WRITE_MODE0 = 2'b00;
defparam dpb_inst_12.WRITE_MODE1 = 2'b00;
defparam dpb_inst_12.BIT_WIDTH_0 = 4;
defparam dpb_inst_12.BIT_WIDTH_1 = 4;
defparam dpb_inst_12.BLK_SEL_0 = 3'b001;
defparam dpb_inst_12.BLK_SEL_1 = 3'b001;
defparam dpb_inst_12.RESET_MODE = "SYNC";

DPB dpb_inst_13 (
    .DOA({dpb_inst_13_douta_w[11:0],dpb_inst_13_douta[7:4]}),
    .DOB({dpb_inst_13_doutb_w[11:0],dpb_inst_13_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_5}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_15}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_13.READ_MODE0 = 1'b0;
defparam dpb_inst_13.READ_MODE1 = 1'b0;
defparam dpb_inst_13.WRITE_MODE0 = 2'b00;
defparam dpb_inst_13.WRITE_MODE1 = 2'b00;
defparam dpb_inst_13.BIT_WIDTH_0 = 4;
defparam dpb_inst_13.BIT_WIDTH_1 = 4;
defparam dpb_inst_13.BLK_SEL_0 = 3'b001;
defparam dpb_inst_13.BLK_SEL_1 = 3'b001;
defparam dpb_inst_13.RESET_MODE = "SYNC";

DPB dpb_inst_14 (
    .DOA({dpb_inst_14_douta_w[11:0],dpb_inst_14_douta[7:4]}),
    .DOB({dpb_inst_14_doutb_w[11:0],dpb_inst_14_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_6}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_16}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_14.READ_MODE0 = 1'b0;
defparam dpb_inst_14.READ_MODE1 = 1'b0;
defparam dpb_inst_14.WRITE_MODE0 = 2'b00;
defparam dpb_inst_14.WRITE_MODE1 = 2'b00;
defparam dpb_inst_14.BIT_WIDTH_0 = 4;
defparam dpb_inst_14.BIT_WIDTH_1 = 4;
defparam dpb_inst_14.BLK_SEL_0 = 3'b001;
defparam dpb_inst_14.BLK_SEL_1 = 3'b001;
defparam dpb_inst_14.RESET_MODE = "SYNC";

DPB dpb_inst_15 (
    .DOA({dpb_inst_15_douta_w[11:0],dpb_inst_15_douta[7:4]}),
    .DOB({dpb_inst_15_doutb_w[11:0],dpb_inst_15_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_7}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_17}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_15.READ_MODE0 = 1'b0;
defparam dpb_inst_15.READ_MODE1 = 1'b0;
defparam dpb_inst_15.WRITE_MODE0 = 2'b00;
defparam dpb_inst_15.WRITE_MODE1 = 2'b00;
defparam dpb_inst_15.BIT_WIDTH_0 = 4;
defparam dpb_inst_15.BIT_WIDTH_1 = 4;
defparam dpb_inst_15.BLK_SEL_0 = 3'b001;
defparam dpb_inst_15.BLK_SEL_1 = 3'b001;
defparam dpb_inst_15.RESET_MODE = "SYNC";

DPB dpb_inst_16 (
    .DOA({dpb_inst_16_douta_w[11:0],dpb_inst_16_douta[3:0]}),
    .DOB({dpb_inst_16_doutb_w[11:0],dpb_inst_16_doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_8}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_18}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_16.READ_MODE0 = 1'b0;
defparam dpb_inst_16.READ_MODE1 = 1'b0;
defparam dpb_inst_16.WRITE_MODE0 = 2'b00;
defparam dpb_inst_16.WRITE_MODE1 = 2'b00;
defparam dpb_inst_16.BIT_WIDTH_0 = 4;
defparam dpb_inst_16.BIT_WIDTH_1 = 4;
defparam dpb_inst_16.BLK_SEL_0 = 3'b001;
defparam dpb_inst_16.BLK_SEL_1 = 3'b001;
defparam dpb_inst_16.RESET_MODE = "SYNC";

DPB dpb_inst_17 (
    .DOA({dpb_inst_17_douta_w[11:0],dpb_inst_17_douta[7:4]}),
    .DOB({dpb_inst_17_doutb_w[11:0],dpb_inst_17_doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_8}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_18}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_17.READ_MODE0 = 1'b0;
defparam dpb_inst_17.READ_MODE1 = 1'b0;
defparam dpb_inst_17.WRITE_MODE0 = 2'b00;
defparam dpb_inst_17.WRITE_MODE1 = 2'b00;
defparam dpb_inst_17.BIT_WIDTH_0 = 4;
defparam dpb_inst_17.BIT_WIDTH_1 = 4;
defparam dpb_inst_17.BLK_SEL_0 = 3'b001;
defparam dpb_inst_17.BLK_SEL_1 = 3'b001;
defparam dpb_inst_17.RESET_MODE = "SYNC";

DPB dpb_inst_18 (
    .DOA({dpb_inst_18_douta_w[7:0],dpb_inst_18_douta[7:0]}),
    .DOB({dpb_inst_18_doutb_w[7:0],dpb_inst_18_doutb[7:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,lut_f_9}),
    .BLKSELB({gw_gnd,gw_gnd,lut_f_19}),
    .ADA({ada[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:0]}),
    .ADB({adb[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:0]})
);

defparam dpb_inst_18.READ_MODE0 = 1'b0;
defparam dpb_inst_18.READ_MODE1 = 1'b0;
defparam dpb_inst_18.WRITE_MODE0 = 2'b00;
defparam dpb_inst_18.WRITE_MODE1 = 2'b00;
defparam dpb_inst_18.BIT_WIDTH_0 = 8;
defparam dpb_inst_18.BIT_WIDTH_1 = 8;
defparam dpb_inst_18.BLK_SEL_0 = 3'b001;
defparam dpb_inst_18.BLK_SEL_1 = 3'b001;
defparam dpb_inst_18.RESET_MODE = "SYNC";

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(ada[15]),
  .CLK(clka),
  .CE(cea_w)
);
DFFE dff_inst_1 (
  .Q(dff_q_1),
  .D(ada[14]),
  .CLK(clka),
  .CE(cea_w)
);
DFFE dff_inst_2 (
  .Q(dff_q_2),
  .D(ada[13]),
  .CLK(clka),
  .CE(cea_w)
);
DFFE dff_inst_3 (
  .Q(dff_q_3),
  .D(ada[12]),
  .CLK(clka),
  .CE(cea_w)
);
DFFE dff_inst_4 (
  .Q(dff_q_4),
  .D(adb[15]),
  .CLK(clkb),
  .CE(ceb_w)
);
DFFE dff_inst_5 (
  .Q(dff_q_5),
  .D(adb[14]),
  .CLK(clkb),
  .CE(ceb_w)
);
DFFE dff_inst_6 (
  .Q(dff_q_6),
  .D(adb[13]),
  .CLK(clkb),
  .CE(ceb_w)
);
DFFE dff_inst_7 (
  .Q(dff_q_7),
  .D(adb[12]),
  .CLK(clkb),
  .CE(ceb_w)
);
MUX2 mux_inst_10 (
  .O(mux_o_10),
  .I0(dpb_inst_0_douta[0]),
  .I1(dpb_inst_1_douta[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_11 (
  .O(mux_o_11),
  .I0(dpb_inst_2_douta[0]),
  .I1(dpb_inst_3_douta[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_12 (
  .O(mux_o_12),
  .I0(dpb_inst_4_douta[0]),
  .I1(dpb_inst_5_douta[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_13 (
  .O(mux_o_13),
  .I0(dpb_inst_6_douta[0]),
  .I1(dpb_inst_7_douta[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_14 (
  .O(mux_o_14),
  .I0(dpb_inst_16_douta[0]),
  .I1(dpb_inst_18_douta[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_15 (
  .O(mux_o_15),
  .I0(mux_o_10),
  .I1(mux_o_11),
  .S0(dff_q_2)
);
MUX2 mux_inst_16 (
  .O(mux_o_16),
  .I0(mux_o_12),
  .I1(mux_o_13),
  .S0(dff_q_2)
);
MUX2 mux_inst_18 (
  .O(mux_o_18),
  .I0(mux_o_15),
  .I1(mux_o_16),
  .S0(dff_q_1)
);
MUX2 mux_inst_20 (
  .O(douta[0]),
  .I0(mux_o_18),
  .I1(mux_o_14),
  .S0(dff_q_0)
);
MUX2 mux_inst_31 (
  .O(mux_o_31),
  .I0(dpb_inst_0_douta[1]),
  .I1(dpb_inst_1_douta[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_32 (
  .O(mux_o_32),
  .I0(dpb_inst_2_douta[1]),
  .I1(dpb_inst_3_douta[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_33 (
  .O(mux_o_33),
  .I0(dpb_inst_4_douta[1]),
  .I1(dpb_inst_5_douta[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_34 (
  .O(mux_o_34),
  .I0(dpb_inst_6_douta[1]),
  .I1(dpb_inst_7_douta[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_35 (
  .O(mux_o_35),
  .I0(dpb_inst_16_douta[1]),
  .I1(dpb_inst_18_douta[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_36 (
  .O(mux_o_36),
  .I0(mux_o_31),
  .I1(mux_o_32),
  .S0(dff_q_2)
);
MUX2 mux_inst_37 (
  .O(mux_o_37),
  .I0(mux_o_33),
  .I1(mux_o_34),
  .S0(dff_q_2)
);
MUX2 mux_inst_39 (
  .O(mux_o_39),
  .I0(mux_o_36),
  .I1(mux_o_37),
  .S0(dff_q_1)
);
MUX2 mux_inst_41 (
  .O(douta[1]),
  .I0(mux_o_39),
  .I1(mux_o_35),
  .S0(dff_q_0)
);
MUX2 mux_inst_52 (
  .O(mux_o_52),
  .I0(dpb_inst_0_douta[2]),
  .I1(dpb_inst_1_douta[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_53 (
  .O(mux_o_53),
  .I0(dpb_inst_2_douta[2]),
  .I1(dpb_inst_3_douta[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_54 (
  .O(mux_o_54),
  .I0(dpb_inst_4_douta[2]),
  .I1(dpb_inst_5_douta[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_55 (
  .O(mux_o_55),
  .I0(dpb_inst_6_douta[2]),
  .I1(dpb_inst_7_douta[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_56 (
  .O(mux_o_56),
  .I0(dpb_inst_16_douta[2]),
  .I1(dpb_inst_18_douta[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_57 (
  .O(mux_o_57),
  .I0(mux_o_52),
  .I1(mux_o_53),
  .S0(dff_q_2)
);
MUX2 mux_inst_58 (
  .O(mux_o_58),
  .I0(mux_o_54),
  .I1(mux_o_55),
  .S0(dff_q_2)
);
MUX2 mux_inst_60 (
  .O(mux_o_60),
  .I0(mux_o_57),
  .I1(mux_o_58),
  .S0(dff_q_1)
);
MUX2 mux_inst_62 (
  .O(douta[2]),
  .I0(mux_o_60),
  .I1(mux_o_56),
  .S0(dff_q_0)
);
MUX2 mux_inst_73 (
  .O(mux_o_73),
  .I0(dpb_inst_0_douta[3]),
  .I1(dpb_inst_1_douta[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_74 (
  .O(mux_o_74),
  .I0(dpb_inst_2_douta[3]),
  .I1(dpb_inst_3_douta[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_75 (
  .O(mux_o_75),
  .I0(dpb_inst_4_douta[3]),
  .I1(dpb_inst_5_douta[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_76 (
  .O(mux_o_76),
  .I0(dpb_inst_6_douta[3]),
  .I1(dpb_inst_7_douta[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_77 (
  .O(mux_o_77),
  .I0(dpb_inst_16_douta[3]),
  .I1(dpb_inst_18_douta[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_78 (
  .O(mux_o_78),
  .I0(mux_o_73),
  .I1(mux_o_74),
  .S0(dff_q_2)
);
MUX2 mux_inst_79 (
  .O(mux_o_79),
  .I0(mux_o_75),
  .I1(mux_o_76),
  .S0(dff_q_2)
);
MUX2 mux_inst_81 (
  .O(mux_o_81),
  .I0(mux_o_78),
  .I1(mux_o_79),
  .S0(dff_q_1)
);
MUX2 mux_inst_83 (
  .O(douta[3]),
  .I0(mux_o_81),
  .I1(mux_o_77),
  .S0(dff_q_0)
);
MUX2 mux_inst_94 (
  .O(mux_o_94),
  .I0(dpb_inst_8_douta[4]),
  .I1(dpb_inst_9_douta[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_95 (
  .O(mux_o_95),
  .I0(dpb_inst_10_douta[4]),
  .I1(dpb_inst_11_douta[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_96 (
  .O(mux_o_96),
  .I0(dpb_inst_12_douta[4]),
  .I1(dpb_inst_13_douta[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_97 (
  .O(mux_o_97),
  .I0(dpb_inst_14_douta[4]),
  .I1(dpb_inst_15_douta[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_98 (
  .O(mux_o_98),
  .I0(dpb_inst_17_douta[4]),
  .I1(dpb_inst_18_douta[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_99 (
  .O(mux_o_99),
  .I0(mux_o_94),
  .I1(mux_o_95),
  .S0(dff_q_2)
);
MUX2 mux_inst_100 (
  .O(mux_o_100),
  .I0(mux_o_96),
  .I1(mux_o_97),
  .S0(dff_q_2)
);
MUX2 mux_inst_102 (
  .O(mux_o_102),
  .I0(mux_o_99),
  .I1(mux_o_100),
  .S0(dff_q_1)
);
MUX2 mux_inst_104 (
  .O(douta[4]),
  .I0(mux_o_102),
  .I1(mux_o_98),
  .S0(dff_q_0)
);
MUX2 mux_inst_115 (
  .O(mux_o_115),
  .I0(dpb_inst_8_douta[5]),
  .I1(dpb_inst_9_douta[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_116 (
  .O(mux_o_116),
  .I0(dpb_inst_10_douta[5]),
  .I1(dpb_inst_11_douta[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_117 (
  .O(mux_o_117),
  .I0(dpb_inst_12_douta[5]),
  .I1(dpb_inst_13_douta[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_118 (
  .O(mux_o_118),
  .I0(dpb_inst_14_douta[5]),
  .I1(dpb_inst_15_douta[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_119 (
  .O(mux_o_119),
  .I0(dpb_inst_17_douta[5]),
  .I1(dpb_inst_18_douta[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_120 (
  .O(mux_o_120),
  .I0(mux_o_115),
  .I1(mux_o_116),
  .S0(dff_q_2)
);
MUX2 mux_inst_121 (
  .O(mux_o_121),
  .I0(mux_o_117),
  .I1(mux_o_118),
  .S0(dff_q_2)
);
MUX2 mux_inst_123 (
  .O(mux_o_123),
  .I0(mux_o_120),
  .I1(mux_o_121),
  .S0(dff_q_1)
);
MUX2 mux_inst_125 (
  .O(douta[5]),
  .I0(mux_o_123),
  .I1(mux_o_119),
  .S0(dff_q_0)
);
MUX2 mux_inst_136 (
  .O(mux_o_136),
  .I0(dpb_inst_8_douta[6]),
  .I1(dpb_inst_9_douta[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_137 (
  .O(mux_o_137),
  .I0(dpb_inst_10_douta[6]),
  .I1(dpb_inst_11_douta[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_138 (
  .O(mux_o_138),
  .I0(dpb_inst_12_douta[6]),
  .I1(dpb_inst_13_douta[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_139 (
  .O(mux_o_139),
  .I0(dpb_inst_14_douta[6]),
  .I1(dpb_inst_15_douta[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_140 (
  .O(mux_o_140),
  .I0(dpb_inst_17_douta[6]),
  .I1(dpb_inst_18_douta[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_141 (
  .O(mux_o_141),
  .I0(mux_o_136),
  .I1(mux_o_137),
  .S0(dff_q_2)
);
MUX2 mux_inst_142 (
  .O(mux_o_142),
  .I0(mux_o_138),
  .I1(mux_o_139),
  .S0(dff_q_2)
);
MUX2 mux_inst_144 (
  .O(mux_o_144),
  .I0(mux_o_141),
  .I1(mux_o_142),
  .S0(dff_q_1)
);
MUX2 mux_inst_146 (
  .O(douta[6]),
  .I0(mux_o_144),
  .I1(mux_o_140),
  .S0(dff_q_0)
);
MUX2 mux_inst_157 (
  .O(mux_o_157),
  .I0(dpb_inst_8_douta[7]),
  .I1(dpb_inst_9_douta[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_158 (
  .O(mux_o_158),
  .I0(dpb_inst_10_douta[7]),
  .I1(dpb_inst_11_douta[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_159 (
  .O(mux_o_159),
  .I0(dpb_inst_12_douta[7]),
  .I1(dpb_inst_13_douta[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_160 (
  .O(mux_o_160),
  .I0(dpb_inst_14_douta[7]),
  .I1(dpb_inst_15_douta[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_161 (
  .O(mux_o_161),
  .I0(dpb_inst_17_douta[7]),
  .I1(dpb_inst_18_douta[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_162 (
  .O(mux_o_162),
  .I0(mux_o_157),
  .I1(mux_o_158),
  .S0(dff_q_2)
);
MUX2 mux_inst_163 (
  .O(mux_o_163),
  .I0(mux_o_159),
  .I1(mux_o_160),
  .S0(dff_q_2)
);
MUX2 mux_inst_165 (
  .O(mux_o_165),
  .I0(mux_o_162),
  .I1(mux_o_163),
  .S0(dff_q_1)
);
MUX2 mux_inst_167 (
  .O(douta[7]),
  .I0(mux_o_165),
  .I1(mux_o_161),
  .S0(dff_q_0)
);
MUX2 mux_inst_178 (
  .O(mux_o_178),
  .I0(dpb_inst_0_doutb[0]),
  .I1(dpb_inst_1_doutb[0]),
  .S0(dff_q_7)
);
MUX2 mux_inst_179 (
  .O(mux_o_179),
  .I0(dpb_inst_2_doutb[0]),
  .I1(dpb_inst_3_doutb[0]),
  .S0(dff_q_7)
);
MUX2 mux_inst_180 (
  .O(mux_o_180),
  .I0(dpb_inst_4_doutb[0]),
  .I1(dpb_inst_5_doutb[0]),
  .S0(dff_q_7)
);
MUX2 mux_inst_181 (
  .O(mux_o_181),
  .I0(dpb_inst_6_doutb[0]),
  .I1(dpb_inst_7_doutb[0]),
  .S0(dff_q_7)
);
MUX2 mux_inst_182 (
  .O(mux_o_182),
  .I0(dpb_inst_16_doutb[0]),
  .I1(dpb_inst_18_doutb[0]),
  .S0(dff_q_7)
);
MUX2 mux_inst_183 (
  .O(mux_o_183),
  .I0(mux_o_178),
  .I1(mux_o_179),
  .S0(dff_q_6)
);
MUX2 mux_inst_184 (
  .O(mux_o_184),
  .I0(mux_o_180),
  .I1(mux_o_181),
  .S0(dff_q_6)
);
MUX2 mux_inst_186 (
  .O(mux_o_186),
  .I0(mux_o_183),
  .I1(mux_o_184),
  .S0(dff_q_5)
);
MUX2 mux_inst_188 (
  .O(doutb[0]),
  .I0(mux_o_186),
  .I1(mux_o_182),
  .S0(dff_q_4)
);
MUX2 mux_inst_199 (
  .O(mux_o_199),
  .I0(dpb_inst_0_doutb[1]),
  .I1(dpb_inst_1_doutb[1]),
  .S0(dff_q_7)
);
MUX2 mux_inst_200 (
  .O(mux_o_200),
  .I0(dpb_inst_2_doutb[1]),
  .I1(dpb_inst_3_doutb[1]),
  .S0(dff_q_7)
);
MUX2 mux_inst_201 (
  .O(mux_o_201),
  .I0(dpb_inst_4_doutb[1]),
  .I1(dpb_inst_5_doutb[1]),
  .S0(dff_q_7)
);
MUX2 mux_inst_202 (
  .O(mux_o_202),
  .I0(dpb_inst_6_doutb[1]),
  .I1(dpb_inst_7_doutb[1]),
  .S0(dff_q_7)
);
MUX2 mux_inst_203 (
  .O(mux_o_203),
  .I0(dpb_inst_16_doutb[1]),
  .I1(dpb_inst_18_doutb[1]),
  .S0(dff_q_7)
);
MUX2 mux_inst_204 (
  .O(mux_o_204),
  .I0(mux_o_199),
  .I1(mux_o_200),
  .S0(dff_q_6)
);
MUX2 mux_inst_205 (
  .O(mux_o_205),
  .I0(mux_o_201),
  .I1(mux_o_202),
  .S0(dff_q_6)
);
MUX2 mux_inst_207 (
  .O(mux_o_207),
  .I0(mux_o_204),
  .I1(mux_o_205),
  .S0(dff_q_5)
);
MUX2 mux_inst_209 (
  .O(doutb[1]),
  .I0(mux_o_207),
  .I1(mux_o_203),
  .S0(dff_q_4)
);
MUX2 mux_inst_220 (
  .O(mux_o_220),
  .I0(dpb_inst_0_doutb[2]),
  .I1(dpb_inst_1_doutb[2]),
  .S0(dff_q_7)
);
MUX2 mux_inst_221 (
  .O(mux_o_221),
  .I0(dpb_inst_2_doutb[2]),
  .I1(dpb_inst_3_doutb[2]),
  .S0(dff_q_7)
);
MUX2 mux_inst_222 (
  .O(mux_o_222),
  .I0(dpb_inst_4_doutb[2]),
  .I1(dpb_inst_5_doutb[2]),
  .S0(dff_q_7)
);
MUX2 mux_inst_223 (
  .O(mux_o_223),
  .I0(dpb_inst_6_doutb[2]),
  .I1(dpb_inst_7_doutb[2]),
  .S0(dff_q_7)
);
MUX2 mux_inst_224 (
  .O(mux_o_224),
  .I0(dpb_inst_16_doutb[2]),
  .I1(dpb_inst_18_doutb[2]),
  .S0(dff_q_7)
);
MUX2 mux_inst_225 (
  .O(mux_o_225),
  .I0(mux_o_220),
  .I1(mux_o_221),
  .S0(dff_q_6)
);
MUX2 mux_inst_226 (
  .O(mux_o_226),
  .I0(mux_o_222),
  .I1(mux_o_223),
  .S0(dff_q_6)
);
MUX2 mux_inst_228 (
  .O(mux_o_228),
  .I0(mux_o_225),
  .I1(mux_o_226),
  .S0(dff_q_5)
);
MUX2 mux_inst_230 (
  .O(doutb[2]),
  .I0(mux_o_228),
  .I1(mux_o_224),
  .S0(dff_q_4)
);
MUX2 mux_inst_241 (
  .O(mux_o_241),
  .I0(dpb_inst_0_doutb[3]),
  .I1(dpb_inst_1_doutb[3]),
  .S0(dff_q_7)
);
MUX2 mux_inst_242 (
  .O(mux_o_242),
  .I0(dpb_inst_2_doutb[3]),
  .I1(dpb_inst_3_doutb[3]),
  .S0(dff_q_7)
);
MUX2 mux_inst_243 (
  .O(mux_o_243),
  .I0(dpb_inst_4_doutb[3]),
  .I1(dpb_inst_5_doutb[3]),
  .S0(dff_q_7)
);
MUX2 mux_inst_244 (
  .O(mux_o_244),
  .I0(dpb_inst_6_doutb[3]),
  .I1(dpb_inst_7_doutb[3]),
  .S0(dff_q_7)
);
MUX2 mux_inst_245 (
  .O(mux_o_245),
  .I0(dpb_inst_16_doutb[3]),
  .I1(dpb_inst_18_doutb[3]),
  .S0(dff_q_7)
);
MUX2 mux_inst_246 (
  .O(mux_o_246),
  .I0(mux_o_241),
  .I1(mux_o_242),
  .S0(dff_q_6)
);
MUX2 mux_inst_247 (
  .O(mux_o_247),
  .I0(mux_o_243),
  .I1(mux_o_244),
  .S0(dff_q_6)
);
MUX2 mux_inst_249 (
  .O(mux_o_249),
  .I0(mux_o_246),
  .I1(mux_o_247),
  .S0(dff_q_5)
);
MUX2 mux_inst_251 (
  .O(doutb[3]),
  .I0(mux_o_249),
  .I1(mux_o_245),
  .S0(dff_q_4)
);
MUX2 mux_inst_262 (
  .O(mux_o_262),
  .I0(dpb_inst_8_doutb[4]),
  .I1(dpb_inst_9_doutb[4]),
  .S0(dff_q_7)
);
MUX2 mux_inst_263 (
  .O(mux_o_263),
  .I0(dpb_inst_10_doutb[4]),
  .I1(dpb_inst_11_doutb[4]),
  .S0(dff_q_7)
);
MUX2 mux_inst_264 (
  .O(mux_o_264),
  .I0(dpb_inst_12_doutb[4]),
  .I1(dpb_inst_13_doutb[4]),
  .S0(dff_q_7)
);
MUX2 mux_inst_265 (
  .O(mux_o_265),
  .I0(dpb_inst_14_doutb[4]),
  .I1(dpb_inst_15_doutb[4]),
  .S0(dff_q_7)
);
MUX2 mux_inst_266 (
  .O(mux_o_266),
  .I0(dpb_inst_17_doutb[4]),
  .I1(dpb_inst_18_doutb[4]),
  .S0(dff_q_7)
);
MUX2 mux_inst_267 (
  .O(mux_o_267),
  .I0(mux_o_262),
  .I1(mux_o_263),
  .S0(dff_q_6)
);
MUX2 mux_inst_268 (
  .O(mux_o_268),
  .I0(mux_o_264),
  .I1(mux_o_265),
  .S0(dff_q_6)
);
MUX2 mux_inst_270 (
  .O(mux_o_270),
  .I0(mux_o_267),
  .I1(mux_o_268),
  .S0(dff_q_5)
);
MUX2 mux_inst_272 (
  .O(doutb[4]),
  .I0(mux_o_270),
  .I1(mux_o_266),
  .S0(dff_q_4)
);
MUX2 mux_inst_283 (
  .O(mux_o_283),
  .I0(dpb_inst_8_doutb[5]),
  .I1(dpb_inst_9_doutb[5]),
  .S0(dff_q_7)
);
MUX2 mux_inst_284 (
  .O(mux_o_284),
  .I0(dpb_inst_10_doutb[5]),
  .I1(dpb_inst_11_doutb[5]),
  .S0(dff_q_7)
);
MUX2 mux_inst_285 (
  .O(mux_o_285),
  .I0(dpb_inst_12_doutb[5]),
  .I1(dpb_inst_13_doutb[5]),
  .S0(dff_q_7)
);
MUX2 mux_inst_286 (
  .O(mux_o_286),
  .I0(dpb_inst_14_doutb[5]),
  .I1(dpb_inst_15_doutb[5]),
  .S0(dff_q_7)
);
MUX2 mux_inst_287 (
  .O(mux_o_287),
  .I0(dpb_inst_17_doutb[5]),
  .I1(dpb_inst_18_doutb[5]),
  .S0(dff_q_7)
);
MUX2 mux_inst_288 (
  .O(mux_o_288),
  .I0(mux_o_283),
  .I1(mux_o_284),
  .S0(dff_q_6)
);
MUX2 mux_inst_289 (
  .O(mux_o_289),
  .I0(mux_o_285),
  .I1(mux_o_286),
  .S0(dff_q_6)
);
MUX2 mux_inst_291 (
  .O(mux_o_291),
  .I0(mux_o_288),
  .I1(mux_o_289),
  .S0(dff_q_5)
);
MUX2 mux_inst_293 (
  .O(doutb[5]),
  .I0(mux_o_291),
  .I1(mux_o_287),
  .S0(dff_q_4)
);
MUX2 mux_inst_304 (
  .O(mux_o_304),
  .I0(dpb_inst_8_doutb[6]),
  .I1(dpb_inst_9_doutb[6]),
  .S0(dff_q_7)
);
MUX2 mux_inst_305 (
  .O(mux_o_305),
  .I0(dpb_inst_10_doutb[6]),
  .I1(dpb_inst_11_doutb[6]),
  .S0(dff_q_7)
);
MUX2 mux_inst_306 (
  .O(mux_o_306),
  .I0(dpb_inst_12_doutb[6]),
  .I1(dpb_inst_13_doutb[6]),
  .S0(dff_q_7)
);
MUX2 mux_inst_307 (
  .O(mux_o_307),
  .I0(dpb_inst_14_doutb[6]),
  .I1(dpb_inst_15_doutb[6]),
  .S0(dff_q_7)
);
MUX2 mux_inst_308 (
  .O(mux_o_308),
  .I0(dpb_inst_17_doutb[6]),
  .I1(dpb_inst_18_doutb[6]),
  .S0(dff_q_7)
);
MUX2 mux_inst_309 (
  .O(mux_o_309),
  .I0(mux_o_304),
  .I1(mux_o_305),
  .S0(dff_q_6)
);
MUX2 mux_inst_310 (
  .O(mux_o_310),
  .I0(mux_o_306),
  .I1(mux_o_307),
  .S0(dff_q_6)
);
MUX2 mux_inst_312 (
  .O(mux_o_312),
  .I0(mux_o_309),
  .I1(mux_o_310),
  .S0(dff_q_5)
);
MUX2 mux_inst_314 (
  .O(doutb[6]),
  .I0(mux_o_312),
  .I1(mux_o_308),
  .S0(dff_q_4)
);
MUX2 mux_inst_325 (
  .O(mux_o_325),
  .I0(dpb_inst_8_doutb[7]),
  .I1(dpb_inst_9_doutb[7]),
  .S0(dff_q_7)
);
MUX2 mux_inst_326 (
  .O(mux_o_326),
  .I0(dpb_inst_10_doutb[7]),
  .I1(dpb_inst_11_doutb[7]),
  .S0(dff_q_7)
);
MUX2 mux_inst_327 (
  .O(mux_o_327),
  .I0(dpb_inst_12_doutb[7]),
  .I1(dpb_inst_13_doutb[7]),
  .S0(dff_q_7)
);
MUX2 mux_inst_328 (
  .O(mux_o_328),
  .I0(dpb_inst_14_doutb[7]),
  .I1(dpb_inst_15_doutb[7]),
  .S0(dff_q_7)
);
MUX2 mux_inst_329 (
  .O(mux_o_329),
  .I0(dpb_inst_17_doutb[7]),
  .I1(dpb_inst_18_doutb[7]),
  .S0(dff_q_7)
);
MUX2 mux_inst_330 (
  .O(mux_o_330),
  .I0(mux_o_325),
  .I1(mux_o_326),
  .S0(dff_q_6)
);
MUX2 mux_inst_331 (
  .O(mux_o_331),
  .I0(mux_o_327),
  .I1(mux_o_328),
  .S0(dff_q_6)
);
MUX2 mux_inst_333 (
  .O(mux_o_333),
  .I0(mux_o_330),
  .I1(mux_o_331),
  .S0(dff_q_5)
);
MUX2 mux_inst_335 (
  .O(doutb[7]),
  .I0(mux_o_333),
  .I1(mux_o_329),
  .S0(dff_q_4)
);
endmodule //Gowin_DPB
