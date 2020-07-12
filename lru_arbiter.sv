module lru_arbiter
#(parameter NUM_REQ=10)
(
  input  logic [NUM_REQ-1:0] req,
  output logic [NUM_REQ-1:0] gnt 
);

//LRU arbiter is also called matrix arbiter

//Total Number of Priority flip flop bits required to represent the square matrix of priority is (n^2 - n)/2
logic [NUM_REQ-1:0] [NUM_REQ-1:0] pri;
logic [NUM_REQ-1:0] higher_prior_req;

//Grant vector
assign gnt[NUM_REQ-1:0] = req[NUM_REQ-1:0] & (~higher_prior_req[NUM_REQ-1:0]);
genvar i,j,k,l;
generate
   for (i=0 ; i<NUM_REQ ; i++)
      for(j=0; j<NUM_REQ ; j++)
          if(i>j) begin
            always @(posedge clk or negedge rst_b) begin
             //Preset the lower half of the matrix 
              if(~rst_b) 
                 pri[i][j] <= 1'b1;
              else
                 pri[i][j] <= pri[i][j] & ~gnt[j];
            end
          end
          else if(i==j) begin
                 assign p[i][j] = 1'b0;
          end
          else begin
                 assign p[i][j] = ~p[j][i];
          end
endgenerate

generate
       for(k=0;k<NUM_REQ;k++)
           for(l=0;l<NUM_REQ;l++)
              if(k!=l)
                 assign higher_prior_req[k] = |(req[l] & pri[l][k]);  
endgenerate


endmodule
