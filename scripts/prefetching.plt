set terminal pdf enhanced font "Times New Roman,18" size 7.5,2.5
load 'settings.gp'

set xtics nomirror
#set xtics (1,12,24,36,48)
set grid ytics mytics
set ytics nomirror font ",16"

### Throughput
set ylabel "M operations / second" font ",18"
set output "Fig-10-a.pdf"
set multiplot layout 1,3 rowsfirst
#set yrange [0:80]
set xlabel "cores"
set ylabel "M operations / second"

## Insert
set key left top
set title "Insert only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" using 1:($8/1000000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching,\
	"" using 1:($6/1000000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching
unset key

## Read/Update
set ylabel " "
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" using 1:($20/1000000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching,\
	"" using 1:($18/1000000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching

## Read-Only
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" using 1:($21/1000000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching,\
	"" using 1:($19/1000000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching
	
unset multiplot

### Memory Stalls
unset key
#set ytics 1
#set mytics 2
set ylabel "K memory stalls / operation"
set output "Fig-10-b.pdf"
set multiplot layout 1,3 rowsfirst
set xlabel "cores"

## Insert
set title "Insert only"
plot  "../benchmark-results/mxtasking/mxtasking-memory-stalls.data" using 1:($6/1000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching,\
	"" using 1:($8/1000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching
unset key

## Read/Update
set key top left
set ylabel " "
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-memory-stalls.data" using 1:($18/1000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching,\
	"" using 1:($20/1000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching
unset key

## Read-Only
set ylabel " "
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-memory-stalls.data" using 1:($19/1000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching,\
	"" using 1:($21/1000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching
unset multiplot

### Instructions
set key left bottom
#set ytics 1
#set yrange [0:2.5]
set ylabel "K instructions / operation"
set output "Fig-10-c.pdf"
set multiplot layout 1,3 rowsfirst
set xlabel "cores"
## Insert
set key left bottom
set title "Insert only"
plot "../benchmark-results/mxtasking/mxtasking-instructions.data" using 1:($8/1000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching,\
	"" using 1:($6/1000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching
unset key
## Read/Update
set ylabel " "
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-instructions.data" using 1:($20/1000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching,\
	"" using 1:($18/1000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching

## Read-Only
set ylabel " "
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-instructions.data" using 1:($21/1000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_prefetching,\
	"" using 1:($19/1000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_prefetching
unset multiplot

