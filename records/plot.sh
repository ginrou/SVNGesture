#!/bin/bash


plot_with_gnuplot() {
    echo "plot $1 to $2"
    gnuplot <<EOF
set terminal png
set output "$2"
set yrange [-10:10]
plot "$1" using 1:2 with lines, "$1" using 1:3 with lines, "$1" using 1:4 with lines
EOF
}

DATA_DIR=data
for file in `find $DATA_DIR -type f -name "*.txt"`; do
    plot_with_gnuplot $file ${file%.txt}.png 
done


