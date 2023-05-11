## Easy script 
test: 
	cd build && cmake .. && make && ./tests 

run: 
	cd build && cmake .. && make && ./flux ./test.gflx
