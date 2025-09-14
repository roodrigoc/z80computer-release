
module TIMER_module(
    // CPU interface
    inout [7:0] data,
    input ncs,
    input nwr,
    input nrd,
    input nrst,
    input [3:0] addr,
    input cpuclk,    // 4MHz

    output intr_out);

    wire cpuwrite;
    wire cpuread;
    reg got_wr;
    reg got_rd;
    reg intr_enabled;
    reg intr_pending;
    assign intr_out = intr_pending & intr_enabled;

    wire ncs2;
    assign ncs2 = ncs | (addr != 4);

    assign cpuwrite = ncs2 | nwr;
    assign cpuread  = ncs2 | nrd;

    reg [1:0] presc34;
    reg [13:0] divider;

    initial begin
        divider = 0;
        got_wr = 0;
        got_rd = 0;
        intr_enabled = 0;
        intr_pending = 0;
    end

    always @(posedge cpuclk) begin

        if (!nrst) begin
            divider = 0;
            got_wr = 0;
            got_rd = 0;
            intr_enabled = 0;
            intr_pending = 0;
        end
        else begin

            presc34 = presc34 + 1;
            if (|presc34) begin     // 4MHz to 3MHz

                if (divider != 9999)
                    divider = divider + 1;
                else begin
                    divider = 0;
                    intr_pending = 1;
                end
            end

            if (!cpuwrite) begin

                if (!got_wr) begin
                    intr_enabled = data[0];
                    got_wr <= 1;
                end
            end
            else
                got_wr <= 0;

            if (!cpuread) begin
                got_rd <= 1;
            end
            else begin
                if (got_rd) begin
                    intr_pending = 0;
                    got_rd <= 0;
                end
            end
        end
    end

endmodule
