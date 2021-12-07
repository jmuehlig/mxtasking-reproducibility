set terminal pdf enhanced font "Times New Roman,24" size 7,3.5
set termopt enhanced
load 'settings.gp'

set key right top spacing 2
set style data histogram
set style histogram rowstacked
set boxwidth .5
set xtics nomirror
unset xtics
set ytics nomirror
set ylabel "K cycles / lookup"
set xtics #font ",22"
set grid ytics 
set output "Fig-07.pdf"
set title "B^{link}-tree (read-only)"
set key invert outside
#set xtics rotate by -20
#set ytics 1
#set grid ytics mytics
#set mytics (.5,1.5,2.5)

plot "../benchmark-results/cycles-c-phase1-system-allocator.data" using (($6+$7+$8+$9+$10+$11)/1000):xtic(1) title "application" fill pattern pattern_tree lc rgb rgb_tree_traversal,\
	"" using (($2+$3+$4)/1000):xtic(1) title "MxTasking\n+Prefetching" fill pattern pattern_mxtasking lc rgb rgb_mxtasking,\
	"" using ($5/1000):xtic(1) title "allocation" fill pattern pattern_system lc rgb rgb_system
