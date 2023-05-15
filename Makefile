## Easy script 

all: 
	cd build && cmake .. && make

tests: 
	cd build && cmake .. && make tests && ./tests 

builtin: 
	cd build && cmake .. && make flux && ./flux ./builtin.gflx 

ident: 
	cd build && cmake .. && make flux  && ./flux ./ident.gflx 

char: 
	cd build && cmake .. && make flux && ./flux ./char.gflx 

string: 
	cd build && cmake .. && make flux && ./flux ./string.gflx 


run2: 
	cd build && cmake .. && make flux && ./flux ./test2.gflx 

run3: 
	cd build && cmake .. && make flux && ./flux ./test3.gflx 
	
run4: 
	cd build && cmake .. && make flux && ./flux ./test4.gflx 


run5: 
	cd build && cmake .. && make flux && ./flux ./test4.gflx 
