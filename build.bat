
ECHO  "Downloading for windows now!"
zig build -target native-windows

XCOPY .\\zig-out\\bin\\gfx .\\
ECHO "DONE!"

