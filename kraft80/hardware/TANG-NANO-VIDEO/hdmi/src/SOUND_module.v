/////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////
module SOUND_module( output dacser,
                     output dacsclk,
                     output dacrclk,
                     input cpuclk,
                     input nrst,
                     inout [7:0] data,
                     input ncs,
                     input nwr,
                     input nrd,
                     input [3:0] addr);


    wire cpuwrite;
    wire cpuread;
    reg got_wr;
    //reg got_rd;

    wire ncs2;
    assign ncs2 = ncs | (addr < 6) | addr[3];

    assign cpuwrite = ncs2 | nwr;
    assign cpuread  = ncs2 | nrd;

    assign data = 8'bz;

    reg [3:0] rindex;

    reg [7:0] r0;
    reg [7:0] r1;
    reg [7:0] r2;
    reg [7:0] r3;
    reg [7:0] r4;
    reg [7:0] r5;
    reg [7:0] r6;
    reg [7:0] r7;
    reg [7:0] r8;
    reg [7:0] r9;
    reg [7:0] r10;
    reg [7:0] r11;
    reg [7:0] r12;
    reg [7:0] r13;

    wire [11:0] outvalue;
    wire noiseout;
 
    wire [11:0] divA;
    wire [11:0] divB;
    wire [11:0] divC;
    wire [4:0] divN;
    assign divA[11:8] = r1[3:0];
    assign divA[7:0]  = r0;
    assign divB[11:8] = r3[3:0];
    assign divB[7:0]  = r2;
    assign divC[11:8] = r5[3:0];
    assign divC[7:0]  = r4;
    assign divN = r6[4:0];

    wire [15:0] divEnv;
    assign divEnv[15:8] = r12;
    assign divEnv[7:0]  = r11;

    reg envstart;
    reg envchdiv;

    initial begin
        got_wr = 0;
        //got_rd = 0;
        r0 = 0; r1 = 0; r2 = 0; r3 = 0;
        r4 = 0; r5 = 0; r6 = 0; r7 = 0;
        r8 = 0; r9 = 0;
        r10 = 0; r11 = 0; r12 = 0; r13 = 0;
        envstart = 0;
        envchdiv = 0;
    end

    TONE_module toneA (.tone_div(divA),
                       .toneout(toneAout),
                       .cpuclk(cpuclk),
                       .nrst(nrst));

    TONE_module toneB (.tone_div(divB),
                       .toneout(toneBout),
                       .cpuclk(cpuclk),
                       .nrst(nrst));

    TONE_module toneC (.tone_div(divC),
                       .toneout(toneCout),
                       .cpuclk(cpuclk),
                       .nrst(nrst));

    WNGEN_module wng1 (.wn_div(divN),
                       .noiseout(noiseout),
                       .cpuclk(cpuclk),
                       .nrst(nrst));

    ENVELOPE_module env1 (.env_div(divEnv),
                          .env_shape(r13[3:0]),
                          .start(envstart),
                          .chdiv(envchdiv),
                       //output reg [3:0] env_amp,
                          .cpuclk(cpuclk),
                          .nrst(nrst));

    wire [3:0] ampA;
    assign ampA = r8[4] ? env1.env_amp : r8[3:0];
    wire [3:0] ampB;
    assign ampB = r9[4] ? env1.env_amp : r9[3:0];
    wire [3:0] ampC;
    assign ampC = r10[4] ? env1.env_amp : r10[3:0];

    wire toneAen;
    assign toneAen = toneA.toneact & (~r7[0]);
    wire toneBen;
    assign toneBen = toneB.toneact & (~r7[1]);
    wire toneCen;
    assign toneCen = toneC.toneact & (~r7[2]);

    wire noiseAen;
    assign noiseAen = wng1.noiseact & (~r7[3]);
    wire noiseBen;
    assign noiseBen = wng1.noiseact & (~r7[4]);
    wire noiseCen;
    assign noiseCen = wng1.noiseact & (~r7[5]);

    wire [11:5] w000;
    assign w000 = 7'b1000000;

    wire [11:5] w001;
    assign w001 = toneAen ? (toneA.toneout ? w000+ampA:w000-ampA):(noiseAen ? w000 : w000+(ampA<<1)-16);

    wire [11:5] w002;
    assign w002 = toneBen ? (toneB.toneout ? w001+ampB:w001-ampB):(noiseBen ? w001 : w001+(ampB<<1)-16);

    wire [11:5] w003;
    assign w003 = toneCen ? (toneC.toneout ? w002+ampC:w002-ampC):(noiseCen ? w002 : w002+(ampC<<1)-16);

    wire [11:5] w004;
    assign w004 = noiseAen ? (wng1.noiseout ? w003+ampA:w003-ampA): w003;

    wire [11:5] w005;
    assign w005 = noiseBen ? (wng1.noiseout ? w004+ampB:w004-ampB): w004;

    wire [11:5] w006;
    assign w006 = noiseCen ? (wng1.noiseout ? w005+ampC:w005-ampC): w005;

    assign outvalue[11:5] = w006;
    assign outvalue[4:0] = 0;

    DAC_module dac1 (.dacser(dacser),
                     .dacsclk(dacsclk),
                     .dacrclk(dacrclk),
                     .cpuclk(cpuclk),
                     .nrst(nrst),
                     .outvalue(outvalue));

    always @(posedge cpuclk) begin

        if (!nrst) begin
            got_wr = 0;
            //got_rd = 0;
            r0 = 0; r1 = 0; r2 = 0; r3 = 0;
            r4 = 0; r5 = 0; r6 = 0; r7 = 0;
            r8 = 0; r9 = 0;
            r10 = 0; r11 = 0; r12 = 0; r13 = 0;
            envstart = 0;
            envchdiv = 0;
        end
        else begin

            if (!cpuwrite) begin

                if (!got_wr) begin
                    case (addr)
                        6: begin rindex = data; end
                        7: begin 

                            case (rindex)
                            0: r0 = data;
                            1: r1 = data;
                            2: r2 = data;
                            3: r3 = data;
                            4: r4 = data;
                            5: r5 = data;
                            6: r6 = data;
                            7: r7 = data;
                            8: r8 = data;
                            9: r9 = data;
                            10: r10 = data;
                            11: begin r11 = data; envchdiv = 1; end
                            12: begin r12 = data; envchdiv = 1; end
                            13: begin r13 = data; envstart = 1; end
                            endcase

                           end
                    endcase

                    got_wr <= 1;

                end
            end
            else begin
                got_wr <= 0; 
                envstart = 0;
                envchdiv = 1;
            end
        end

    end


endmodule

/////////////////////////////////////////////////////////////////////////////////
module ENVELOPE_module(input [15:0] env_div,
                       input [3:0] env_shape,
                       input start,
                       input chdiv,
                       output reg [3:0] env_amp,
                       input cpuclk,
                       input nrst);

    reg [8:0] clkdiv;
    reg [15:0] divider;
    reg alternate;
    reg running;
    reg o_start;
    reg o_chdiv;

//    wire HOLD,ALTERNATE,ATTACK,CONTINUE;
//    assign HOLD = env_shape[0];
//    assign ALTERNATE = env_shape[1];
//    assign ATTACK = env_shape[2];
//    assign CONTINUE = env_shape[3];

    initial begin
        divider = 0;
        clkdiv = 0;
        running = 0;
        o_start = 0;
        o_chdiv = 0;
    end

    always @(posedge cpuclk) begin

        if (!nrst) begin
            divider = 0;
            clkdiv = 0;
            running = 0;
            o_start = 0;
            o_chdiv = 0;
        end
        else begin

            if (start && (!o_start)) begin

                divider = 0;
                clkdiv = 0;
                running = 1;
                alternate = 0;
                
                if (env_shape[2])   // Attack
                    env_amp = 4'b0000;
                else
                    env_amp = 4'b1111;

            end
            else begin

                if (chdiv && !o_chdiv) begin
                    divider = 0;
                end
                else
                if (running) begin

                    if (!clkdiv) begin  // Divides 4MHz by 512 to simulate 2MHz / 256

                        if (divider == (env_div - 1)) begin

                            divider = 0;

                            case (env_shape[3:2])

                                0: begin
                                    if (env_amp)
                                        env_amp = env_amp - 1;
                                    else
                                        running = 0;
                                   end

                                1: begin
                                    if (env_amp != 15)
                                        env_amp = env_amp + 1;
                                    else begin
                                        env_amp = 0;
                                        running = 0;
                                    end
                                   end

                                2: begin

                                    case (env_shape[1:0])

                                        0: env_amp = env_amp - 1;

                                        1: begin
                                            if (env_amp)
                                                env_amp = env_amp - 1;
                                            else
                                                running = 0;
                                           end

                                        2: begin

                                            if (!alternate) begin
                                                if (env_amp)
                                                    env_amp = env_amp - 1;
                                                else alternate = 1;
                                            end
                                            else begin
                                                if (env_amp != 15)
                                                    env_amp = env_amp + 1;
                                                else
                                                    alternate = 0;
                                            end

                                           end

                                        3: begin
                                            if (env_amp)
                                                env_amp = env_amp - 1;
                                            else begin
                                                env_amp = 15;
                                                running = 0;
                                                end
                                           end

                                    endcase
                                   end

                                3: begin

                                    case (env_shape[1:0])

                                        0: env_amp = env_amp + 1;

                                        1: begin
                                            if (env_amp != 15)
                                                env_amp = env_amp + 1;
                                            else
                                                running = 0;
                                           end

                                        2: begin 

                                            if (alternate) begin
                                                if (env_amp)
                                                    env_amp = env_amp - 1;
                                                else alternate = 0;
                                            end
                                            else begin
                                                if (env_amp != 15)
                                                    env_amp = env_amp + 1;
                                                else
                                                    alternate = 1;
                                            end

                                           end

                                        3: begin
                                            if (env_amp != 15)
                                                env_amp = env_amp + 1;
                                            else begin
                                                env_amp = 0;
                                                running = 0;
                                            end
                                           end

                                    endcase

                                   end
                            endcase
                        end
                        else
                            divider = divider + 1;
                    end // clkdiv
                    clkdiv = clkdiv + 1;

                end // running
            end
        end

        o_start = start;
        o_chdiv = chdiv;
    end

endmodule

/////////////////////////////////////////////////////////////////////////////////
module WNGEN_module (input [4:0] wn_div,
                     output reg noiseout,
                     output reg noiseact,
                     input cpuclk,
                     input nrst);

    wire lfsrout;
    reg [7:0] clkdiv;
    reg [4:0] divider;
    reg fsr_clk;

    always @(posedge cpuclk) begin

        if (!nrst) begin
            divider = 0;
            noiseout = 0;
            clkdiv = 0;
            fsr_clk = 0;
        end
        else begin
            if (wn_div == 0) begin
                noiseout = 1'b0;
                noiseact = 1'b0;
            end else begin
                noiseact = 1'b1;
                if (clkdiv == 31) begin     // Divides 4MHz by 32, so simulates division of 2MHz by 16.
                    if (divider == (wn_div-1)) begin
                        fsr_clk = 1;
                        divider = 0;
                    end else begin
                        //fsr_clk = 0;
                        divider = divider + 1;
                    end
                    clkdiv = 0;
                    noiseout = lfsrout;
                end
                else begin
                    fsr_clk = 0;
                    clkdiv = clkdiv + 1;
                end
            end
        end
    end

    LFSR_module lfsr1 (.out(lfsrout),
                       .clk(fsr_clk),
                       .nrst(nrst));

endmodule

/////////////////////////////////////////////////////////////////////////////////
module TONE_module (input [11:0] tone_div,
                    output reg toneout,
                    output reg toneact,
                    input cpuclk,
                    input nrst);

    reg [7:0] clkdiv;
    reg [11:0] divider;

    always @(posedge cpuclk) begin

        if (!nrst) begin
            divider = 0;
            clkdiv = 0;
            toneact = 1'b0;
        end
        else begin
            if (tone_div == 0) begin
                toneout = 1'b0;
                toneact = 1'b0;
            end else begin
                toneact = 1'b1;
                if (clkdiv == 15) begin     // Divides 4MHz by 16, so simulates division of 2MHz by 8 (double the frequency because we're toggling the output, thus dividing its freq by two).
                    if (divider == (tone_div-1)) begin
                        divider = 0;
                        toneout = toneout ^ 1'b1;
                    end else
                        divider = divider + 1;

                    clkdiv = 0;
                end
                else
                    clkdiv = clkdiv + 1;
            end
        end
    end

endmodule

/////////////////////////////////////////////////////////////////////////////////
module DAC_module  (output reg dacser,
                    output reg dacsclk,
                    output reg dacrclk,
                    input cpuclk,
                    input nrst,
                    input [11:0] outvalue);

    reg [11:0] outshr;
    reg[5:0] state;

    initial begin
        state = 0;
        dacser = 0;
        dacsclk = 0;
        dacrclk = 0;
    end

// 28 states @ 4MHz -> Round trip 142 kHz
//
// 0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21   22   23   24   25  26  27
//         C0H C0L C1H C1L C2H C2L C3H C3L C4H C4L C5H C5L C6H C6L C7H C7L C8H C8L C9H C9L  C10H C10L C11H C11L
//     SER0    SER1    SER2    SER3    SER4    SER5    SER6    SER7    SER8    SER9    SER10     SER11
//                                                                                                             RCH RCL
// OUT

    always @(posedge cpuclk) begin

        if (!nrst) begin
            dacsclk = 0; dacrclk = 0; state = 0;
        end
        else begin
            if (state == 27) begin
                dacrclk = 0; state = 0;
            end else
            if (state == 26) begin
                dacrclk = 1; state = 27;
            end
            else
            if (state == 0) begin
                outshr = outvalue; state = 1;
            end
            else begin
                if (state[0]) begin 
                    dacsclk = 0; dacser = outshr[0]; outshr = outshr >> 1; 
                end else begin
                    dacsclk = 1;
                end
                state = state + 1;
            end
        end
    end

endmodule

/////////////////////////////////////////////////////////////////////////////////
module LFSR_module (output out,
                    input clk,
                    input nrst);

    reg [16:1] sfr;
    reg aux;
    assign out = sfr[1];

    initial begin
        sfr = 16'b1;
    end

    always @(posedge clk) begin

        if (!nrst) begin
            sfr = 16'b1;
        end
        else begin
            aux = sfr[11] ^ sfr[13] ^ sfr[14] ^ sfr[16];
            sfr = sfr << 1;
            sfr[1] = aux;
        end
    end

endmodule
