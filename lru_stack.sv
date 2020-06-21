//LRU

always @(posedge clk)
 begin
	if(update_sloc[0]==1'b1)
		sloc[0]<=accessed_block;
	for(j=1;j<(DEPTH-1);j=j+1)
		begin
		if(update_sloc[j])
			sloc[j]<=sloc[j-1];
		end
 end
  
always@(*)
  begin
	for(i=0;i<=(DEPTH-1);i=i+1)
		begin
			if(sloc[i]==accessed_block)
				sloc_eq[i]=1'b1;
			else
				sloc_eq[i]=1'b0;
		end		
   end
  
always @(*)
begin
	if(update_lru_stack)
		update_sloc[0]=1'b1;
	else
		update_sloc[0]=0;
	for(p=1;i<=(DEPTH-1);p=i+1)
		update_sloc[p]= (~ sloc_eq[p-1]) & update_sloc[p-1];
end

assign victim =sloc[DEPTH-1];
