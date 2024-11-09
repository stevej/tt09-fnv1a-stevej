`ifndef _LRC_
`define _LRC_

/**
 * Provides a running longitudinal redundancy check (LRC) of the changing input bytes.
 */
module lrc(
    input logic clk,
    input logic rst_n,
    input logic [7:0] in,
    output logic [7:0] out
    );

logic [7:0] total_lrc;
logic [7:0] last_in_seen;

assign out = total_lrc;

/**
 * LRC algorithm
 * lrc := 0
 * for each byte b in the buffer do
 *    lrc := (lrc + b) and 0xFF
 * lrc := (((lrc XOR 0xFF) + 1) and 0xFF)
 */
always @(posedge clk) begin
    if (!rst_n) begin
        last_in_seen <= '0;
        total_lrc <= '0;
    end else begin
        // We only update when the input changes. This could
        // be a bug or a feature depending on how generous
        // you feel about the author.
        if ((in != last_in_seen) && (in != 8'b0)) begin
            total_lrc <= (((total_lrc + in) & 8'hFF) ^ 8'hFF) & 8'hFF;
        end else begin
            total_lrc <= total_lrc;
        end
        last_in_seen <= in;
    end
end
endmodule
`endif
