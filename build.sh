#!/usr/bin/bash 

echo "Compiling and building GonFLUX...\n"
zig build
echo "Done!"
cp /zig-out/bin/gonflux ./ 
