module counter #(parameter WIDTH = 4)
(
input logic clk, rst, en, up,
output logic [WIDTH-1:0] q
);

    always_ff @(posedge clk) begin
        if(rst)
            q <= '0;
        else if (en) begin
            if (up)
                q <= q + 1'b1;
            else
                q <= q - 1'b1;
        end
    end
endmodule
