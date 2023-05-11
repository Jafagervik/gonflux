# Set up and install this 

# Make build if not exists
if [-e build ]
    mkdir build && cd build 
else 
    cd build 
fi 

# cmake top level 
cmake ..

# make 
make 

# cp executable to top 
cp ./build/flux ./ 

echo "Done building executable! Lets flux away"

