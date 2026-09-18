module tb_regbank_unit #(parameter M = 4, parameter W = 8);

    localparam AW = $clog2(M);

    logic clk = 0;
    logic rst, wr_en;
    logic [AW-1:0] wr_addr, rd_addr;
    logic [W-1:0]  wr_data, rd_data;
    logic [W-1:0]  model [0:M-1];
    int errors = 0;

    register_bank #(.M(M), .W(W)) dut (
        .clk(clk), .rst(rst), .wr_en(wr_en),
        .wr_addr(wr_addr), .wr_data(wr_data),
        .rd_addr(rd_addr), .rd_data(rd_data)
    );

    always #5 clk = ~clk;

    task automatic do_write(input [AW-1:0] addr, input [W-1:0] data);
        wr_en = 1; wr_addr = addr; wr_data = data;
        @(posedge clk);
        #1
        model[addr] = data;
        wr_en = 0;
    endtask

    task automatic check_read(input [AW-1:0] addr, string test_name);
        rd_addr = addr;
        #1;
        if (rd_data !== model[addr]) begin
            $error("[M=%0d W=%0d] %s: FAIL - rd_data=%0d expected=%0d", M, W, test_name, rd_data, model[addr]);
            errors++;
        end else begin
            $display("[M=%0d W=%0d] %s: PASS - rd_data=%0d", M, W, test_name, rd_data);
        end
    endtask

    initial begin
        int i;
        rst = 1; wr_en = 0; rd_addr = 0;
        @(posedge clk);
        #1;
        for (i = 0; i < M; i++) model[i] = '0;
        rst = 0;
        for (i = 0; i < M; i++)
            check_read(i[AW-1:0], "post-reset");

        for (i = 0; i < M; i++)
            do_write(i[AW-1:0], (i * 17 + 3) % (1 << W));

        for (i = M-1; i >= 0; i--)
            check_read(i[AW-1:0], "read after write, reverse order");

        do_write(0, 8'hAA % (1 << W));
        for (i = 1; i < M; i++)
            check_read(i[AW-1:0], "persistence check");
        check_read(0, "overwrite check");

        rd_addr = 0; #1;
        rd_addr = M-1; #1;
        check_read(M-1, "async read, no clock edge");

        do_write(1, 8'h55 % (1 << W));
        check_read(1, "final read-after-write");

        if (errors == 0)
            $display("TB_REGBANK M=%0d W=%0d: ALL TESTS PASSED", M, W);
        else
            $display("TB_REGBANK M=%0d W=%0d: %0d ERRORS", M, W, errors);
    end

endmodule

module tb_register_bank;
    tb_regbank_unit #(.M(4), .W(8)) u1();
    tb_regbank_unit #(.M(8), .W(4)) u2();
endmodule