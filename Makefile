## Easy script 
test: 
	cd build && cmake .. && make && ./tests 

run: 
	cd build && cmake .. && make && ./flux ./test.gflx 


run2: 
	cd build && cmake .. && make && ./flux ./test2.gflx 

run3: 
	cd build && cmake .. && make && ./flux ./test3.gflx 
	
run4: 
	cd build && cmake .. && make && ./flux ./test4.gflx 


run5: 
	cd build && cmake .. && make && ./flux ./test4.gflx 
