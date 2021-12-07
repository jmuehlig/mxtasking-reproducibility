set terminal pdf enhanced font "Times New Roman,22"
load 'settings.gp'

set xlabel "records / task"
set xtics nomirror #rotate by -30
set ytics nomirror
set grid ytics mytics

set ylabel "M output tuples / second"
set output "Fig-09.pdf"

plot "../benchmark-results/mxtasking/mxtasking-hashjoin-pd0.data" using ($2/1000000):xticlabels(1) with linespoints ls ls_mxtasking lw 2 lc rgb rgb_mxtasking title ""
