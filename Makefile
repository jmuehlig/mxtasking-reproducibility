check-requirements:
	./check.sh
	
clean:
	./clear.sh
	
install:
	./install_dependencies.sh
	
experiments:
	./run_experiments.sh
	
tree-experiments:
	./run_tree_experiments.sh
	
hashjoin-experiments:
	./run_hashjoin_experiments.sh
	
cycle-experiments:
	./run_cycle_experiments.sh
