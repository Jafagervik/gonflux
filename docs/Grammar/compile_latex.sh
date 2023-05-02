##!/bin/bash
echo "Compiling Grammar..."
pdflatex Grammar.tex
echo "Removing AUX files"
rm Grammar.aux Grammar.log
echo "Successfully compiled Grammar!"
