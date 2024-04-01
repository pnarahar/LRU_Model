//Key of the table is data and value is how many times the data occurred in the data stream

module 
    #(parameter DEPTH = 5,
      parameter NB = 12)
    (
     input  logic [NB-1:0]     din,
     input  logic              din_vld,
     output logic [NB-1:0]     dout,  // Unpaired element in the data stream
     output logic              ready,
     input  logic              rst_b,
     input  logic              clk
     );


logic [NB : 0] tbl [DEPTH-1:0];
logic [DEPTH-1 : 0] tbl_hit;
logic [$clog2(DEPTH)-1:0]un_paired_idx,wr_pnt;
logic [2:0] tbl_cnt [DEPTH-1:0];
localparam THRSH = 5;

logic [$clog2(THRSH)-1 : 0] strm_cnt;


//Tracking the next available table slot
always_comb begin
    wr_pnt = 0;
    for (int i=0; i<DEPTH; i++)
       if(tbl[i][NB] == 1'b1)
           wr_pnt = i+1;
end 


//test for the match in the current set
always_comb begin
  for(i=0; i<DEPTH; i++)
    begin
  //If Din matches a valid table entry
      if(din == tbl[i] & tbl[i][NB])
         tbl_hit[i] = 1'b1;
      else
         tbl_hit[i] = 1'b0;    
    end

end


//Store the incoming data as key of the hash table
generate
for(genvar i=0;i<DEPTH;i++)
    always@(posedge clk or negedge rst_b) begin
        if(!rst_b)
            tbl[i] <= '0;
        else if(ready)
            tbl[i] <= '0;
//Table miss, store the key in the table
        else if(~|tbl_hit  & din_vld) begin
            tbl[wr_pnt][NB-1:0] <= din; 
            tbl[wr_pnt][NB] <= 1'b1;
        end
    end
endgenerate



//The stream can have atmost one unpaired index. The below code implies priority(To be optimized)
always_comb begin
   for(i=0;i<DEPTH;i++)
//Check for Odd counts
      if(tbl_cnt[i][0])
        un_paired_idx = i;
end

//Mod N Counter: Every N Cycles look for an unpaired data 
always@(posedge clk or negedge rst_n)
 begin
     if(~rst_b) 
         strm_cnt<='0;
     else if (din_vld)
        if(strm_cnt>=THRSH)
          strm_cnt<='0;
        else
          strm_cnt<=strm_cnt + 1;
 end


assign dout = tbl[un_paired_idx];
assign ready = strm_cnt == THRSH;  

//Tracking how many times a number occurred in the datastream
generate
for(genvar i=0;i<DEPTH;i++)
    always@(posedge clk or negedge rst_b) begin
        if(!rst_b)
            tbl_cnt[i] <= '0;
        else if(ready)
             tbl_cnt[i]<='0;
// IF table hit or writing the key for the first time, increment the counter       
        else if((tbl_hit[i] | wr_pnt == i) & din_vld)
             tbl_cnt[i] <= tbl_cnt[i] + 1'b1; 
    
    end
endgenerate


endmodule
