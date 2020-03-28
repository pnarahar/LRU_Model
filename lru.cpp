class DLL
    int key,val;
    dll prev,post;
endclass
//Methods
//Remove node
void remove_node(DLL node) {
    DLL prev = node.prev;
    DLL post = node.post;
    prev.post = post;
    post.prev = prev;
}
//Add node
void add_node(DLL node) {
  node.post      = head.post; 
  head.post.prev = node
  head.post      = node;
  node.prev      = head;
}

//Move to Front 
void move_to_front (DLL node) {
   add_node(node);
   remove_node(node);
}

//Poptail
DLL pop_tail() {
 if(tail==null) return -1; 
 else  return (tail.prev);
}


map < integer, DLL>

m=new HASHMAP <integer, DLL>;
int count,capacity;

//Put
void put(int key , int val) {
  DLL node = m.get(key);
  if(node==null) {
     count++;   
     while(count>capacity) {
        pop_tail();
     }
     DLL node = new();
  }
  else  {
      move_to_front(node);
      node.val=val;
  }
}

//Get
void get (int key) {
   DLL node =  m.get(key);
   if(node==null) return -1;
   else 
      {
         move_to_front(node);
         return node.val;
      }
}
