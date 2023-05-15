## Easy script 
test: 
	cd build && cmake .. && make && ./tests 

builtin: 
	cd build && cmake .. && make && ./flux ./builtin.gflx 

ident: 
	cd build && cmake .. && make && ./flux ./ident.gflx 

char: 
	cd build && cmake .. && make && ./flux ./char.gflx 

string: 
	cd build && cmake .. && make && ./flux ./string.gflx 


run2: 
	cd build && cmake .. && make && ./flux ./test2.gflx 

run3: 
	cd build && cmake .. && make && ./flux ./test3.gflx 
	
run4: 
	cd build && cmake .. && make && ./flux ./test4.gflx 


run5: 
	cd build && cmake .. && make && ./flux ./test4.gflx 
