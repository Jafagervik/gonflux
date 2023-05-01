all:
	zig build-exe main.zig && ./main

test:
	zig test 

fmt:
	zig fmt src/*


clean:
	rm ./main ./main.o 
