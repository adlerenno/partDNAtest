# Tests for partDNA library

This repo contains the Snakefile to perform the tests of the partDNA paper. 
The snakefile will download all necessary repositories, install all necessary libraries (SDSL, sais-2.4.1, divsufsort) 
and download the test datasets from NCBI. 
The order of steps might differ between runtimes. 

Be aware that you might type your password or agree to an installation at any time during the process. 
This should not happen during BWT construction processes which are benchmarked.
To make sure to first install all dependencies, run ...

```bash
git clone https://github.com/adlerenno/partDNAtest
cd partDNAtest
sudo Snakemake --keep-going
```