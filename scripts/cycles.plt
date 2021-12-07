set terminal pdf enhanced font "Times New Roman,20" size 13,3.2
load 'settings.gp'

set style data histogram
set style histogram rowstacked
#set style histogram gap 1
#set style fill solid
set boxwidth .7
set ylabel "K cycles / operation"

#set yrange [0:8.5]
set ytics nomirror #(" 0" 0, " 1" 1, " 2" 2, " 3" 3, " 4" 4, " 5" 5, " 6" 6, " 7" 7, "14" 14, "15" 15, "16" 16, "17" 17)
set grid ytics mytics
#set mytics 2
set bmargin 3


set output "Fig-13.pdf"
set multiplot layout 1,3 rowsfirst

set xtics format "" nomirror rotate by -25 font ",17"
# Insert
set arrow 1 from 0,8 to 0,7.3 lw 2 size 1,10 filled
unset key
set title "Insert only"
set size .27,1
plot "../benchmark-results/cycles-a-phase0.data" using ($9/1000):xtic(1) title "traversing tree" fill pattern pattern_tree lc rgb rgb_tree_traversal,\
	"" using ($10/1000):xtic(1) title "insert/lookup/update" fill pattern pattern_insert lc rgb rgb_tree_operation,\
	"" using ($2/1000):xtic(1) title "prefetching" fill pattern pattern_prefetching lc rgb rgb_prefetching,\
	"" using ($8/1000):xtic(1) title "synchronization" fill pattern pattern_sync lc rgb rgb_sync,\
	"" using (($3+$4)/1000):xtic(1) title "MxTasking/TBB runtime" fill pattern pattern_mxtasking lc rgb rgb_runtime,\
	"" using (($5+$6)/1000):xtic(1) title "system" fill pattern pattern_system lc rgb rgb_system,\
	"" using (($11+$7)/1000):xtic(1) title "other" fill pattern pattern_other lc rgb rgb_other
unset arrow 1
	
# "" using ($0):((($2+$3+$4+$5+$6+$7+$8+$9+$10)/1000) > 17 ? 17 : 1/0):(sprintf("%.2f", ($2+$3+$4+$5+$6+$7+$8+$9+$10)/1000)) with labels tc rgb 'black' offset 0,-.1 font ",14" notitle

# Read/Update
unset key
set title "Read/Update"
set size .27,1
set origin .27,0
set ylabel " "
plot "../benchmark-results/cycles-a-phase1.data" using ($9/1000):xtic(1) title "traversing tree" fill pattern pattern_tree lc rgb rgb_tree_traversal,\
	"" using ($10/1000):xtic(1) title "insert/lookup/update" fill pattern pattern_insert lc rgb rgb_tree_operation,\
	"" using ($2/1000):xtic(1) title "prefetching" fill pattern pattern_prefetching lc rgb rgb_prefetching,\
	"" using ($8/1000):xtic(1) title "synchronization" fill pattern pattern_sync lc rgb rgb_sync,\
	"" using (($3+$4)/1000):xtic(1) title "MxTasking/TBB runtime" fill pattern pattern_mxtasking lc rgb rgb_runtime,\
	"" using (($5+$6)/1000):xtic(1) title "system" fill pattern pattern_system lc rgb rgb_system,\
	"" using (($11+$7)/1000):xtic(1) title "other" fill pattern pattern_other lc rgb rgb_other
	
# Read-Only
set key vertical
set key outside right center font ",20" invert
set title "Read only"
set size .46,1
set origin .54,0
set ylabel " "
plot "../benchmark-results/cycles-c-phase1.data" using ($9/1000):xtic(1) title "traversing tree" fill pattern pattern_tree lc rgb rgb_tree_traversal,\
	"" using ($10/1000):xtic(1) title "insert/lookup/update" fill pattern pattern_insert lc rgb rgb_tree_operation,\
	"" using ($2/1000):xtic(1) title "prefetching" fill pattern pattern_prefetching lc rgb rgb_prefetching,\
	"" using ($8/1000):xtic(1) title "synchronization" fill pattern pattern_sync lc rgb rgb_sync,\
	"" using (($3+$4)/1000):xtic(1) title "MxTasking/TBB runtime" fill pattern pattern_mxtasking lc rgb rgb_runtime,\
	"" using (($5+$6)/1000):xtic(1) title "system" fill pattern pattern_system lc rgb rgb_system,\
	"" using (($11+$7)/1000):xtic(1) title "other" fill pattern pattern_other lc rgb rgb_other
	
unset multiplot
