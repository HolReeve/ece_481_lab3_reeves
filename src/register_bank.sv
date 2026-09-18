`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 09:20:10 PM
// Design Name: 
// Module Name: register_bank
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_bank #(
    parameter M = 4,
    parameter W = 8
) (
    input  logic clk, rst, wr_en,
    input  logic [$clog2(M)-1:0] wr_addr,
    input  logic [W-1:0] wr_data,
    input  logic [$clog2(M)-1:0] rd_addr,
    output logic [W-1:0] rd_data
);

    logic [W-1:0] regs [0:M-1];
    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < M; i++)
                regs[i] <= '0;
        end else if (wr_en) begin
            regs[wr_addr] <= wr_data;
        end
    end

    assign rd_data = regs[rd_addr];

endmodule
