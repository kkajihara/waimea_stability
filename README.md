# waimea_stability

## Background
This project examined co-occurrence networks of fungi, bacteria, and fungi with bacteria across an entire watershed containing 
diverse habitats and hosts to infer universally stabilizing network properties of microbiomes.


## Directories
* **all_networks**
  * code to reproduce analyses involving watershed, habitat, and gradient networks
* **data**
  * metadata file
* **global_networks**
  * code to reproduce watershed-level network analyses
* **gradient_networks**
  * code to reproduce gradient-level network analyses
* **habitat_networks**
  * code to reproduce habitat-level network analyses
* **intermediates**
  * RDS files used as the main inputs for the above code
  * Full taxa tables, metadata, and other files are linked at [https://www.pnas.org/doi/10.1073/pnas.2204146119#data-availability]
* **networks**
  * code to generate networks
  
  
## Reproducibility
To reproduce analyses, code files should be run in order within a directory, following this order of directories: global_networks, habitat_networks, gradient_networks, all_networks. Intermediate and input files are provided for the starting scripts (those beginning in "01"). To conserve repository space, phyloseq objects are provided for the fungal and bacterial datasets (located in "intermediates"). 

Network generation scripts (located in "networks") were run on the University of Hawaii's high performance computer using the SpiecEasi package paired with batchtools. Demonstration code is provided in network_generation_demo.R using a randomly subsampled data from this study (~30 second runtime). 

Intermediate igraph files are provided to run network analysis code. 

Packages with dependencies are listed in packages_with_dependencies.csv


