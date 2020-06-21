//LRU
module lru_stack
#
(
parameter DEPTH      = 8,
)
(
input  logic             updata_lru_stack,
input  logic             clk,
input  logic             rst_b,
input  logic [DEPTH-1:0] accessed_blk,
output logic [DEPTH-1:0] victim_blk,
);

//Stored in decoded form
logic [DEPTH-1:0] [DEPTH-1 : 0] sloc; 
logic [DEPTH-1:0]               sloc_eq,update_sloc;
//
generate
   for(i=0 ; i<DEPTH; i++)
       if(i==0) begin
            always @(posedge clk or negedge rst_b)
                  if(~rst_b)
                      sloc[i] <= '0;
                  else if( update_lru_stack )
                      sloc[i] <= accessed_blk;
       end
       else begin
            always @(posedge clk or negedge rst_b)
                  if(~rst_b)
                      sloc[i] <= '0;
                  else if( update_sloc[i] )
                      sloc[i] <= sloc[i-1];
       end
endgenerate

//Comparator as deep as DEPTH of LRU
always_comb
begin
for(i=0;i<=(DEPTH-1);i=i+1)
   begin
     if(sloc[i]==accessed_blk)
        sloc_eq[i]=1'b1;
     else
        sloc_eq[i]=1'b0;
   end		
end
  
assign update_sloc[0]=update_lru_stack;;

always_comb begin
     for(int p=1;i<=(DEPTH-1);p=i+1)
           update_sloc[p]= (~ sloc_eq[p-1]) & update_sloc[p-1];
end

assign victim =sloc[DEPTH-1];

endmodule
