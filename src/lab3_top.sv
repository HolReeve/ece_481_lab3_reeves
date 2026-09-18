module lab3_top (
    input  logic       clk,
    input  logic       btnC,
    input  logic [1:0] sw,
    output logic [3:0] led
);

    logic tick;

    tick_generator #(.DIVISOR(50_000_000)) tick_gen (
        .clk(clk),
        .rst(btnC),
        .tick(tick)
    );

    logic en;
    assign en = sw[0] & tick;

    counter #(.WIDTH(4)) count_inst (
        .clk(clk),
        .rst(btnC),
        .en(en),
        .up(sw[1]),
        .q(led)
    );

endmodule