module tick_generator #(
    parameter DIVISOR = 50_000_000  
) (
    input  logic clk,
    input  logic rst,
    output logic tick
);

    localparam CNT_WIDTH = $clog2(DIVISOR);
    logic [CNT_WIDTH-1:0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= '0;
            tick  <= 1'b0;
        end else if (count == DIVISOR - 1) begin
            count <= '0;
            tick  <= 1'b1;
        end else begin
            count <= count + 1'b1;
            tick  <= 1'b0;
        end
    end

endmodule