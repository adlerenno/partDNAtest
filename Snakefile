import os

DATA_SETS = ['SRR006041.recal']
MAX_MAIN_MEMORY = 128
NUMBER_OF_PROCESSORS = 32

# The ending / is necessary for all paths.
DIR = "./"
BENCHMARK = './bench/'
SOURCE = './source/'
SPLIT = './split/'
INPUT = './data/'
OUTPUT = './data_bwt/'

APPROACHES = [
    'bcr',
    'ropebwt',
    'ropebwt2',
    'ropebwt3',
    'bigBWT',
    'r_pfbwt',
    'grlBWT',
    'egap',
    'gsufsort',
    'divsufsort',
]
DATA_TYPE = {
    'bcr': 'fq.gz',
    'ropebwt': 'fq.gz',
    'ropebwt2': 'fq.gz',
    'ropebwt3': 'fq.gz',
    'bigBWT': 'fa',
    'r_pfbwt': 'fa',
    'grlBWT': 'owpl',
    'egap': 'fa',
    'gsufsort': 'fq.gz',
    'divsufsort': 'fa',
}

for path in [BENCHMARK, SOURCE, SPLIT, INPUT, OUTPUT]:
    os.makedirs(path, exist_ok=True)

rule convert_targets:
    input:
        [f'data_bwt/{approach}/GRCh38.fa' for approach in APPROACHES],
        [f'data_bwt/{approach}/GRCh38.fa_split_{r}' for approach in APPROACHES for r in range(3, 6)],
        [f'data_bwt/{approach}/GRCm39.fa' for approach in APPROACHES],
        [f'data_bwt/{approach}/GRCm39.fa_split_{r}' for approach in APPROACHES for r in range(3, 6)],
        [f'data_bwt/{approach}/TAIR10.fa' for approach in APPROACHES],
        [f'data_bwt/{approach}/TAIR10.fa_split_{r}' for approach in APPROACHES for r in range(3, 6)],
        [f'data_bwt/{approach}/ASM584.fa' for approach in APPROACHES],
        [f'data_bwt/{approach}/ASM584.fa_split_{r}' for approach in APPROACHES for r in range(3, 6)],
        [f'data_bwt/{approach}/R64.fa' for approach in APPROACHES],
        [f'data_bwt/{approach}/R64.fa_split_{r}' for approach in APPROACHES for r in range(3, 6)],
        [f'data_bwt/{approach}/ASM19595.fa' for approach in APPROACHES],
        [f'data_bwt/{approach}/ASM19595.fa_split_{r}' for approach in APPROACHES for r in range(3, 6)]
    shell:
        """
        python3 scripts/collect_benchmark.py
        """

rule clean:
    shell:
        """
        rm -rf ./bench
        rm -rf ./source
        rm -rf ./split
        rm -rf ./data
        rm -rf ./data_bwt
        rm -rf ./tmp
        """

rule fetch_ncbi_human_GRCh38: # https://www.ncbi.nlm.nih.gov/assembly/GCF_000001405.40/
    output:
        'source/GRCh38.fa'
    shell:
        """
        cd source
        wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.26_GRCh38/GCF_000001405.26_GRCh38_genomic.fna.gz
        gzip -d GCF_000001405.26_GRCh38_genomic.fna.gz
        python3 ./../scripts/convert_grc_long.py GCF_000001405.26_GRCh38_genomic.fna GRCh38.fa
        """

rule fetch_ncbi_mouse_GRCm39:  # https://www.ncbi.nlm.nih.gov/assembly/GCF_000001635.27/
    output:
        'source/GRCm39.fa'
    shell:
        """
        cd source
        wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz
        gzip -d GCF_000001635.27_GRCm39_genomic.fna.gz
        python3 ./../scripts/convert_grc_long.py GCF_000001635.27_GRCm39_genomic.fna GRCm39.fa
        """

rule fetch_ncbi_tiar10:  # https://www.ncbi.nlm.nih.gov/assembly/GCF_000001735.4/
    output:
        'source/TAIR10.fa'
    shell:
        """
        cd source
        wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/735/GCF_000001735.4_TAIR10.1/GCF_000001735.4_TAIR10.1_genomic.fna.gz
        gzip -d GCF_000001735.4_TAIR10.1_genomic.fna.gz
        python3 ./../scripts/convert_grc_long.py GCF_000001735.4_TAIR10.1_genomic.fna TAIR10.fa
        """

rule fetch_ncbi_ecoli:  # https://www.ncbi.nlm.nih.gov/nuccore/U00096.3
    output:
        'source/ASM584.fa'
    shell:
        """
        cd source
        wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/005/845/GCA_000005845.2_ASM584v2/GCA_000005845.2_ASM584v2_genomic.fna.gz
        gzip -d GCA_000005845.2_ASM584v2_genomic.fna.gz
        python3 ./../scripts/convert_grc_long.py GCA_000005845.2_ASM584v2_genomic.fna ASM584.fa
        """

rule fetch_ncbi_bakeryeast:  # https://www.ncbi.nlm.nih.gov/assembly/GCF_000146045.2/
    output:
        'source/R64.fa'
    shell:
        """
        cd source
        wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz
        gzip -d GCF_000146045.2_R64_genomic.fna.gz
        python3 ./../scripts/convert_grc_long.py GCF_000146045.2_R64_genomic.fna R64.fa
        """



rule fetch_ncbi_tuberculosis:  # https://www.ncbi.nlm.nih.gov/assembly/GCF_000195955.2/
    output:
        'source/ASM19595.fa'
    shell:
        """
        cd source
        wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/195/955/GCF_000195955.2_ASM19595v2/GCF_000195955.2_ASM19595v2_genomic.fna.gz
        gzip -d GCF_000195955.2_ASM19595v2_genomic.fna.gz
        python3 ./../scripts/convert_grc_long.py GCF_000195955.2_ASM19595v2_genomic.fna.gz ASM19595.fa
        """

rule fetch_ncbi_sra:
    input:
        script_prefetch = 'sratoolkit.3.0.0-mac64/bin/prefetch',
        script_fastq = 'sratoolkit.3.0.0-mac64/bin/fasterq-dump'
    output:
        'source/{filename}.fq'
    shell:
        """
        {input.script_prefetch} {wildcards.filename}
        {input.script_fastq} --concatenate-reads --outdir ./source/ {wildcards.filename}
        python3 ./../scripts/convert_grc_long.py {wildcards.filename}.fastq {wildcards.filename}.fq
        """

rule prepare_files:
    input:
        in_file = 'split/{filename}'
    output:
        out_file = 'data/{filename}'
    shell:
        """python3 ./scripts/prepare_files.py {input.in_file} {output.out_file}"""

rule partDNA:
    input:
        script = "partDNA/build/exc",
        in_file = "source/{filename}"
    output:
        out_file = "split/{filename}_split_{r}"
    benchmark:
        "bench/{filename}_{r}.partdna.csv"
    shell:
        """
        {input.script} -i {input.in_file} -o {output.out_file} -r {wildcards.r} -d
        """

rule copy_non_split:
    input:
        in_file = 'source/{filename}'
    output:
        out_file = 'split/{filename}'
    shell:
        """cp {input.in_file} {output.out_file}"""

rule bcr:
    input:
        script = 'BCR_LCP_GSA/BCR_LCP_GSA',
        source = 'data/{filename}'
    output:
        destination = 'data_bwt/bcr/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.bcr.csv'
    shell:
        "{input.script} {input.source} {output.destination}"

rule ropebwt:
    input:
        script = 'ropebwt/ropebwt',
        source = 'data/{filename}'
    output:
        destination='data_bwt/ropebwt/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.ropebwt.csv'
    shell:
        "{input.script} -t -R -o {output.destination} {input.source}"

rule ropebwt2:
    input:
        script = 'ropebwt2/ropebwt2',
        source = 'data/{filename}'
    output:
        destination='data_bwt/ropebwt2/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.ropebwt2.csv'
    shell:
        "{input.script} -R -o {output.destination} {input.source}"

rule ropebwt3:
    input:
        script = 'ropebwt3/ropebwt3',
        source = 'data/{filename}'
    output:
        destination = 'data_bwt/ropebwt3/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.ropebwt3.csv'
    shell:
        """{input.script} -R -t{threads} -do {output.destination} {input.source}"""

rule bigBWT:
    input:
        script = 'Big-BWT/bigbwt',
        source = 'data/{filename}'
    output:
        destination='data_bwt/bigBWT/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.bigBWT.csv'
    shell:
        """{input.script} {input.source} -t {threads}
        mv {input.source}.log {output.destination}.log
        mv {input.source}.bwt {output.destination}.bwt"""


rule grlBWT:
    input:
        script = 'grlBWT/build/grlbwt-cli',
        script2 = 'grlBWT/build/grl2plain',
        source = 'data/{filename}'
    output:
        destination='data_bwt/grlBWT/{filename}'
    params:
        tempdir = 'tmp/'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.grlBWT.csv'
    shell:
        """{input.script} {input.source} -t {threads} -T {params.tempdir}
        {input.script2} {input.source}.rl_bwt {output.destination}
        rm {input.source}.rl_bwt
        """

rule egap:
    input:
        script = 'egap/eGap',
        source = 'data/{filename}'
    output:
        destination='data_bwt/egap/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.egap.csv'
    shell:
        "{input.script} {input.source} -o {output.destination}"

rule gsufsort:
    input:
        script = 'gsufsort/gsufsort-64',
        source = 'data/{filename}'
    output:
        destination='data_bwt/gsufsort/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.gsufsort.csv'
    shell:
        "{input.script} {input.source} --upper --bwt --output {output.destination}"

rule r_pfbwt:
    input:
        script = 'r-pfbwt/build/rpfbwt',
        script2 = 'pfp/build/pfp++',
        source = 'data/{filename}'
    output:
        destination='data_bwt/r_pfbwt/{filename}'
    params:
        w1 = 10,
        p1 = 100,
        w2 = 5,
        p2 = 11,
        tempdir = 'tmp/'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.r_pfbwt.csv'
    shell:
        """./{input.script2} -f {input.source} -w {params.w1} -p {params.p1} --output-occurrences --threads {threads}
        ./{input.script2} -i {input.source}.parse -w {params.w2} -p {params.p2} --threads {threads}
        ./{input.script} --l1-prefix {input.source} --w1 {params.w1} --w2 {params.w2} --threads {threads} --tmp-dir {params.tempdir} --bwt-only
        """

rule divsufsort:
    input:
        script = 'divsufsort-dna/build/dss',
        source = 'data/{filename}'
    output:
        destination = 'data_bwt/divsufsort/{filename}'
    threads: NUMBER_OF_PROCESSORS
    benchmark: 'bench/{filename}.divsufsort.csv'
    shell:
        """{input.script} -i {input.source} -o {output.destination}"""

rule build_bcr:
    output:
        script = 'BCR_LCP_GSA/BCR_LCP_GSA'
    shell:
        """
        rm -rf ./BCR_LCP_GSA/
        git clone https://github.com/giovannarosone/BCR_LCP_GSA
        cd BCR_LCP_GSA
        make
        """

rule build_ropebwt:
    output:
        script = 'ropebwt/ropebwt'
    shell:
        """
        rm -rf ./ropebwt
        git clone https://github.com/lh3/ropebwt
        cd ropebwt
        make
        """

rule build_ropebwt2:
    output:
        script = 'ropebwt2/ropebwt2'
    shell:
        """
        rm -rf ./ropebwt2
        git clone https://github.com/lh3/ropebwt2
        cd ropebwt2
        make
        """

rule build_ropebwt3:
    output:
        script = 'ropebwt3/ropebwt3'
    shell:
        """
        rm -rf ./ropebwt3
        git clone https://github.com/lh3/ropebwt3
        cd ropebwt3
        make
        """

rule build_bigbwt:
    output:
        script = 'Big-BWT/bigbwt'
    shell:
        """
        rm -rf ./Big-BWT
        pip install psutil
        git clone https://gitlab.com/manzai/Big-BWT.git
        cd Big-BWT
        make
        """

rule build_grlbwt:
    output:
        script = 'grlBWT/build/grlbwt-cli',
        script2 = 'grlBWT/build/grl2plain',
    shell:
        """
        rm -rf ./grlBWT
        git clone https://github.com/simongog/sdsl-lite.git
        cd sdsl-lite
        ./install.sh /usr/local/
        cd ..
        git clone https://github.com/ddiazdom/grlBWT
        cd grlBWT
        mkdir build
        cd build
        cmake ..
        make
        """

rule build_egap:
    output:
        script = 'egap/eGap'
    shell:
        """
        rm -rf ./egap
        git clone https://github.com/felipelouza/egap.git
        cd egap
        make 
        """

rule build_gsufsort:
    output:
        script = 'gsufsort/gsufsort-64'
    shell:
        """
        rm -rf ./gsufsort
        git clone https://github.com/felipelouza/gsufsort.git
        cd gsufsort
        make 
        """

rule build_r_pf:
    output:
        script = 'r-pfbwt/build/rpfbwt'
    shell:
        """
        rm -rf ./r-pfbwt
        git clone https://github.com/marco-oliva/r-pfbwt.git
        cd r-pfbwt
        mkdir build && cd build
        cmake ..
        make -j
        """

rule build_pfp:
    output:
        script = 'pfp/build/pfp++'
    shell:
        """
        rm -rf ./pfp
        git clone https://github.com/marco-oliva/pfp.git
        cd pfp
        mkdir build && cd build
        cmake ..
        make
        """

rule build_divsufsort:
    output:
        script = 'divsufsort-dna/build/dss'
    shell:
        """
        rm -rf ./divsufsort-dna
        git clone https://github.com/y-256/libdivsufsort.git
        cd libdivsufsort
        mkdir -p build
        cd build
        cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX="/usr/local" -DBUILD_DIVSUFSORT64=ON -DUSE_OPENMP=ON ..
        make
        sudo make install
        cd ../..
        git clone https://github.com/adlerenno/divsufsort-dna
        cd divsufsort-dna
        mkdir -p build
        cd build
        cmake ..
        make
"""

rule build_part_dna:
    output:
        script = "partDNA/build/exc"
    shell:
        """
        rm -rf ./partDNA
        git clone https://github.com/adlerenno/partDNA.git
        cd partDNA
        unzip sais-2.4.1.zip
        cd sais-2.4.1
        mkdir -p build
        cd build
        cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX="/usr/local" -DBUILD_EXAMPLES=OFF -DBUILD_SAIS64=ON -DBUILD_SHARED_LIBS=OFF ..
        make
        sudo make install
        cd ../..
        mkdir -p build
        cd build
        cmake ..
        make
        """

rule build_sra_toolkit:
    output:
        'sratoolkit.3.0.0-mac64/bin/fasterq-dump',
        'sratoolkit.3.0.0-mac64/bin/prefetch'
    shell:
        """
        rm -rf ./sratoolkit.3.0.0-mac64
        wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz
        tar -vxzf sratoolkit.tar.gz
        """
