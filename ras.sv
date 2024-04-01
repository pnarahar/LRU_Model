module ras
    #(parameter PC_WIDTH = 32,
      parameter ASIZE    = 2)
    (
     input  logic [PC_WIDTH-1:0]  pcplus4,
     input  logic                 i_jal,
     input  logic                 i_jr,
     output logic [PC_WIDTH-1:0]  ret_addr,
     input  logic                 rst_b,
     input  logic                 clk
     );


localparam DEPTH = (2**ASIZE);
logic [(DEPTH-1):0] [(PC_WIDTH-1):0] ras_stack;
logic [ASIZE-1:0] tosp,tospplus1;
logic [ASIZE:0]   ras_counter;
logic full;
//Use this when empty, May help in recursive calls, No Guarrantees
assign ret_addr = ras_stack[tosp];

assign full  = ras_counter[ASIZE] & ~|ras_counter[ASIZE-1:0];
assign empty = ~|ras_counter;
always @(posedge clk or negedge rst_b) begin
   if(~rst_b)  begin
       ras_counter <= '0;
       tosp        <= '1;
       tospplus1   <= '0;
       for (int i = 0 ; i<DEPTH ; i++)
           ras_stack[i] <= 'hX;
   end
   else begin
       if(i_jal & ~full) begin
           ras_stack[tospplus1] <= pcplus4;
           tosp       <= tosp+1'b1;
           tospplus1  <= tospplus1 + 1'b1;
           ras_counter<= ras_counter + 1'b1;
       end
       else if(i_jr & ~empty) begin
           tosp       <= tosp      - 1'b1;
           tospplus1  <= tospplus1 - 1'b1;
           ras_counter <= ras_counter - 1'b1;
       end
   end
end

endmodule

