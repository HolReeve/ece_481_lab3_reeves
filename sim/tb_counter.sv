module tb_counter_unit #(parameter WIDTH = 4);

    logic clk = 0;
    logic rst, en, up;
    logic [WIDTH-1:0] q;
    logic [WIDTH-1:0] expected_q;
    int errors = 0;

    counter #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst(rst), .en(en), .up(up), .q(q)
    );

    always #5 clk = ~clk;

    task automatic check(string test_name);
        @(posedge clk);
        #1;
        if (q !== expected_q) begin
            $error("[WIDTH=%0d] %s: FAIL - q=%0d expected=%0d", WIDTH, test_name, q, expected_q);
            errors++;
        end else begin
            $display("[WIDTH=%0d] %s: PASS - q=%0d", WIDTH, test_name, q);
        end
    endtask

    initial begin
        int i;

        
        rst = 1; en = 0; up = 1;
        expected_q = 0;
        check("reset");
        rst = 0;

        
        check("hold #1");
        check("hold #2");

        
        en = 1; up = 1;
        for (i = 0; i < 5; i++) begin
            expected_q = expected_q + 1;
            check($sformatf("count up %0d", i));
        end

        
        up = 0;
        for (i = 0; i < 3; i++) begin
            expected_q = expected_q - 1;
            check($sformatf("count down %0d", i));
        end

        
        rst = 1; check("reset before overflow"); rst = 0;
        up = 1;
        for (i = 0; i < (1 << WIDTH); i++) begin
            expected_q = expected_q + 1;
            check($sformatf("overflow step %0d", i));
        end

        
        rst = 1; check("reset before underflow"); rst = 0;
        up = 0;
        expected_q = expected_q - 1;
        check("underflow to max");

        if (errors == 0)
            $display("TB_COUNTER WIDTH=%0d: ALL TESTS PASSED", WIDTH);
        else
            $display("TB_COUNTER WIDTH=%0d: %0d ERRORS", WIDTH, errors);
    end

endmodule

module tb_counter;
    tb_counter_unit #(.WIDTH(4)) u4();
    tb_counter_unit #(.WIDTH(8)) u8();
endmodule