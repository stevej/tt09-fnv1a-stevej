`ifndef _LRC_
`define _LRC_

/**
 * Provides a running longitudinal redundancy check (LRC) of the changing input bytes.
 */
module lrc(
    input logic clk,
    input logic rst_n,
    input [7:0] in,
    output [7:0] out);

logic [7:0] lrc;
logic [7:0] last_in_seen;

assign out = lrc;

/**
 * LRC algorithm
 * lrc := 0
 * for each byte b in the buffer do
 *    lrc := (lrc + b) and 0xFF
 * lrc := (((lrc XOR 0xFF) + 1) and 0xFF)
 */
always @(posedge clk) begin
    if (!rst_n) begin
        lrc <= 8'b0;
        last_in_seen <= '0;
    end else begin
        // We only update when the input changes. This could
        // be a bug or a feature depending on how generous
        // you feel about the author.
        if (in != last_in_seen && in != 8'b0) begin
            lrc <= (((lrc + in) & 8'hFF) ^ 8'hFF) & 8'hFF;
        end else begin
            lrc <= lrc;
        end
        last_in_seen <= in;
    end
end
endmodule
`endif
