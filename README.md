# Tests for partDNA library

This repository contains the [Snakefile](https://snakemake.github.io) to perform the tests of the [partDNA]() paper. 
The snakefile will download all necessary repositories, 
install all necessary libraries ([SDSL](https://github.com/simongog/sdsl-lite), sais-2.4.1, [divsufsort](https://github.com/y-256/libdivsufsort/tree/master)) 
and download the test datasets from [NCBI](https://www.ncbi.nlm.nih.gov/datasets/genome/). 
The order of steps might differ due to the interna of snakemake. 

Be aware that you might type your password or agree to an installation at any time during the process. 
This should not happen during BWT construction processes which are benchmarked.
To achive best results for you testing machine, adjust the following values in `Snakefile' to your local ressources.

```
MAX_MAIN_MEMORY = 128
NUMBER_OF_PROCESSORS = 32
```

You can run all tests with:

```bash
git clone https://github.com/adlerenno/partDNAtest
cd partDNAtest
sudo Snakemake -p --cores 1
```

To clean up, run 

```bash
sudo Snakemake clean --cores 1
```

You need to have at least 250GB disk space and about 19h  to run all experiments.
If you want to perform fewer experiments, comment out either APPROACHES, DATA_SETS or adjust the R_VALUES. 
If you want to add additional datasets, you need to add a rule to download that file into the source directory.
If you want to add a datasets from [NCBI](https://www.ncbi.nlm.nih.gov/datasets/genome/), you can copy for example the fetch_ncbi_human_GRCh38 rule and adjust it.
