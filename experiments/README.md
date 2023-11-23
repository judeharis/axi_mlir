# Experiments

Each subfolder contains code to compile and run experiments described in the paper.
All each experiment folder contains similar set of folder and files:
* srcs/
  * source code for running the experiment
  * source code for manual C++ implementation used for comparison
  * templates to generate mlir problems for different problem size
* compile_sysc.sh
  * compiles all libraries and apps for the experiment
* run_sysc.sh
  * runs all the compiled SystemC experiment
* compile_pynq.sh
  * compiles all libraries and apps for the experiment targeting the PYNQ board
* ex?_pynq/
  * all pynq libraries, apps and scripts to run the expirements are store in the this folder
* analysis/
  * contains results produced in the paper, additional contains the jupyter notebooks used to reproduce figures from the paper
  * the "ex?-generate-paper-graphs" notebook can be used to generate graphs from newly generated data (check out PYNQ Evaluation section)




# Compiling and Running with SystemC


# Compiling and Running with PYNQ


# Anaylsis

# Experiments
