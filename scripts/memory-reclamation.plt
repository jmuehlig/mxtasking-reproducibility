set terminal pdf enhanced font "Times New Roman,18" size 7.5,2.5
load 'settings.gp'

set xlabel "cores" font ",18"
#set xtics nomirror (1,12,24,36,48) font ",18"
#set ytics nomirror 10 font ",16"
#set yrange [0:80]
set grid ytics mytics

### MxTasking
set ylabel "M operations / second" font ",18"
set output "Fig-11.pdf"
set multiplot layout 1,3 rowsfirst #title "MxTasking"

# no -> ls_optimistic
# every -> ls_exclusive
# bachted -> ls_rw_lock

## Insert
set title "Insert only"
set key left top font ",14"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" using 1:($12/1000000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_reclamation,\
	"" using 1:($8/1000000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_batch_reclamation,\
	"" using 1:($10/1000000) with linespoints ls ls_exclusive lw 2 lc rgb rgb_thread title title_read_reclamation
unset key
## Read/Update
set ylabel " "
set title "Read/Update"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" using 1:($24/1000000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_reclamation,\
	"" using 1:($20/1000000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_batch_reclamation,\
	"" using 1:($22/1000000) with linespoints ls ls_exclusive lw 2 lc rgb rgb_thread title title_read_reclamation
unset key

## Read-Only
set title "Read only"
plot "../benchmark-results/mxtasking/mxtasking-throughput.data" using 1:($25/1000000) with linespoints ls ls_optimistic lw 2 lc rgb rgb_tbb title title_no_reclamation,\
	"" using 1:($21/1000000) with linespoints ls ls_rw_lock lw 2 lc rgb rgb_mxtasking title title_batch_reclamation,\
	"" using 1:($23/1000000) with linespoints ls ls_exclusive lw 2 lc rgb rgb_thread title title_read_reclamation
unset key
unset multiplot

