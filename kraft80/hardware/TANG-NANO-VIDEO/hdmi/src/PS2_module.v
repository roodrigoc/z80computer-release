
module PS2_module(
    // CPU interface
    inout [7:0] data,
    input ncs,
    input nwr,
    input nrd,
    input nrst,
    input [3:0] addr,
    input cpuclk,    // 4MHz

    // Peripheral interface
    inout ps2data,
    inout ps2clk,
    output reg intr_out);

    assign p2sdata = 1'bz;

    reg ps2datareg;
    reg ps2clkreg;
    reg [8:0] rxdata;
    reg isreceiving;
    reg [3:0] bitsreceived;
    reg o_ps2clk;
    reg [19:0] ps2timeout;
    reg [7:0] receiveddata;

    wire cpuwrite;
    wire cpuread;
    //reg got_wr;
    reg got_rd;

    wire ncs2;
    assign ncs2 = ncs | (addr != 5);

    assign cpuwrite = ncs2 | nwr;
    assign cpuread  = ncs2 | nrd;

    assign data = cpuread ? 8'bz : receiveddata;

    reg[3:0] ps2clk2;

    initial begin
        //got_wr = 0;
        got_rd = 0;

        isreceiving = 1'b0;
        ps2datareg = 1'bz;
        ps2clkreg = 1'bz;
        o_ps2clk = 1;
        intr_out = 0;
    end

    assign ps2data = ps2datareg;
    assign ps2clk = ps2clkreg;

    always @(posedge cpuclk) begin

        if (!nrst) begin
            //got_wr = 0;
            got_rd = 0;
            isreceiving = 0;
            intr_out = 0;
            o_ps2clk = 1;
        end
        else begin
//                if (!cpuwrite) begin

//                    if (!got_wr) begin
//                        case (addr)
//                            0: begin bramdatain <= data; wstate <= 1; end
//                            1: begin cled5 <= 800000; bramwraddr[7:0] <= data; end
//                            2: begin cled4 <= 800000; bramwraddr[15:8] <= data; wstate <= 6; end
//                            3: if (data[7:4] == 0) begin videomode = data[0]; bramdatain <= 0; bramwraddr <= 0; bram_awrite <= 1; wstate <= 10; end
//                            default: cled3 <= 800000;
//                        endcase

//                        got_wr <= 1;

//                    end
//                end

            if (!cpuread) begin
                got_rd <= 1;
            end
            else begin
                if (got_rd) begin
                    intr_out = 0;
                    got_rd <= 0;
                end
            end
        end

        if ((!ps2clk2) & o_ps2clk) begin

            ps2timeout = 400000;

            if (isreceiving) begin
                
                if (bitsreceived != 9) 
                begin
                    rxdata = rxdata >> 1;
                    rxdata[8] = ps2data;
                    bitsreceived = bitsreceived + 1;
                end
                else begin  // STOP here
                    receiveddata = rxdata[7:0]; // Discard parity
                    intr_out = 1'b1;
                    isreceiving = 1'b0;
                end
            end
            else begin
                if (!ps2data) begin
                    isreceiving = 1'b1;
                    bitsreceived = 4'b0;
                end
            end
        end
        else begin
            if (ps2timeout)
                ps2timeout = ps2timeout - 1;
            else
                isreceiving = 1'b0;
        end

        o_ps2clk = |ps2clk2;
        ps2clk2 = ps2clk2 << 1; ps2clk2[0] = ps2clk;
    end

endmodule
