set terminal pdf enhanced font "Times New Roman,18" size 7.5,3
load 'settings.gp'


### Optimistic
set xlabel "cores" font ",18"
set xtics nomirror font ",18"
set ytics nomirror font ",16"
set grid ytics mytics
unset key

set ylabel "M operations / second" font ",18"
set output "Fig-12-c.pdf"
set multiplot layout 1,3 rowsfirst 

## Insert
set size .35,.85
set origin 0,.15
set title "Insert only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($8/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($2/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($2/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($2/1000000) with linespoints ls ls_btreeolc lw 2 lc rgb rgb_btreeolc title title_btreeolc,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($6/1000000) with linespoints ls ls_masstree lw 2 lc rgb rgb_masstree title title_masstree,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($4/1000000) with linespoints ls ls_bwtree lw 2 lc rgb rgb_bwtree title title_bwtree
	
set ylabel " "

## Read/Update
set size .35,.85
set origin .33,.15
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($20/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($8/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($8/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($8/1000000) with linespoints ls ls_btreeolc lw 2 lc rgb rgb_btreeolc title title_btreeolc,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($12/1000000) with linespoints ls ls_masstree lw 2 lc rgb rgb_masstree title title_masstree,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($10/1000000) with linespoints ls ls_bwtree lw 2 lc rgb rgb_bwtree title title_bwtree

## Read-Only
set size .35,.85
set origin .66,.15
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($21/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($9/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($9/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($9/1000000) with linespoints ls ls_btreeolc lw 2 lc rgb rgb_btreeolc title title_btreeolc,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($13/1000000) with linespoints ls ls_masstree lw 2 lc rgb rgb_masstree title title_masstree,\
	"../benchmark-results/tree-bench/pthread-bwtree-btree-olc-masstree-throughput.data" every every_x using 1:($11/1000000) with linespoints ls ls_bwtree lw 2 lc rgb rgb_bwtree title title_bwtree
	
## Keys
unset xlabel
unset xtics
unset ytics
unset yrange
unset grid
unset ylabel
unset title
unset border
set size 1,2
set key at .74,-.92 horizontal width 5 maxrows 2 maxcols 6 font ",16"
set xrange [-1:1]
set yrange [-1:1]
plot NaN with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	NaN with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	NaN with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb,\
	NaN with linespoints ls ls_btreeolc lw 2 lc rgb rgb_btreeolc title title_btreeolc,\
	NaN with linespoints ls ls_masstree lw 2 lc rgb rgb_masstree title title_masstree,\
	NaN with linespoints ls ls_bwtree lw 2 lc rgb rgb_bwtree title title_bwtree

unset multiplot

### R/W Lock
set border 15
set xlabel "cores" font ",18"
unset xrange
unset yrange
set xtics nomirror font ",18"
set ytics nomirror font ",16"
set grid ytics mytics
unset key

set ylabel "M operations / second" font ",18"
set output "Fig-12-b.pdf"
set multiplot layout 1,3 rowsfirst 

## Insert
set size .35,.85
set origin 0,.15
set title "Insert only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($2/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($4/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($4/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb
	
set ylabel " "

## Read/Update
set size .35,.85
set origin .33,.15
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($14/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($10/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($10/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb

## Read-Only
set size .35,.85
set origin .66,.15
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($15/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($11/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($11/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb	
## Keys
unset xlabel
unset xtics
unset ytics
unset yrange
unset grid
unset ylabel
unset title
unset border
set size 1,2
set key at .74,-.92 horizontal width 5 maxrows 2 maxcols 6 font ",16"
set xrange [-1:1]
set yrange [-1:1]
plot NaN with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	NaN with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	NaN with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb

unset multiplot

### Serialized
set border 15
set xlabel "cores" font ",18"
unset xrange
unset yrange
set xtics nomirror font ",18"
set ytics nomirror font ",16"
set grid ytics mytics
unset key

set ylabel "M operations / second" font ",18"
set output "Fig-12-a.pdf"
set multiplot layout 1,3 rowsfirst 

## Insert
set size .35,.85
set origin 0,.15
set title "Insert only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($4/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($6/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($6/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb
	
set ylabel " "

## Read/Update
set size .35,.85
set origin .33,.15
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($16/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($12/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($12/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb

## Read-Only
set size .35,.85
set origin .66,.15
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" every every_x using 1:($17/1000000) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	"../benchmark-results/tree-bench/pthread-blinktree-throughput.data" every every_x using 1:($13/1000000) with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	"../benchmark-results/tree-bench/tbb-blinktree-throughput.data" every every_x using 1:($13/1000000) with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb	
## Keys
unset xlabel
unset xtics
unset ytics
unset yrange
unset grid
unset ylabel
unset title
unset border
set size 1,2
set key at .74,-.92 horizontal width 5 maxrows 2 maxcols 6 font ",16"
set xrange [-1:1]
set yrange [-1:1]
plot NaN with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title title_mxtasking,\
	NaN with linespoints ls ls_thread lw 2 lc rgb rgb_thread title title_pthread,\
	NaN with linespoints ls ls_tbb lw 2 lc rgb rgb_tbb title title_tbb

unset multiplot

