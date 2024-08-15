from os import listdir
import csv
import re
import sys
import os


def parse_filename(filename):
    # Define the regular expression patterns for the two formats
    # pattern1 = re.compile(r'^(?P<filename>[^_]+)_split_(?P<r>\d+)\.fa\.(?P<approach>[^.]+)\.csv$')
    # pattern2 = re.compile(r'^(?P<filename>[^.]+)\.fa\.(?P<approach>[^.]+)\.csv$')

    pattern_partdna = re.compile(r'^(?P<filename>[a-zA-Z0-9]+)\.(?P<extension>fa|fa\.gz|fq|fq\.gz|owpl)_(?P<r>\d+)\.partdna.csv$')
    match = pattern_partdna.match(filename)
    if match:
        return 'partdna', match.group('filename'), match.group('r'), match.group(
            'extension')  # r is none if not included

    pattern = re.compile(r'^(?P<filename>[a-zA-Z0-9]+)(?:_split_(?P<r>\d+))?\.(?P<extension>fa|fa\.gz|fq|fq\.gz|owpl)\.(?P<approach>[a-zA-Z0-9_]+)\.csv$')
    match = pattern.match(filename)
    if match:
        return match.group('approach'), match.group('filename'), match.group('r'), match.group('extension')  # r is none if not included

    # If neither pattern matches, raise an error
    raise ValueError(f"Filename '{filename}' does not match expected patterns")


def get_success_indicator(approach, filename, r, file_extension):
    if r is None:
        with open(f'indicators/{filename}.{file_extension}.{approach}', 'r') as f:
            for line in f:
                return line[0]
        raise FileNotFoundError(f'File indicators/{filename}.{file_extension}.{approach} not found.')
    else:
        with open(f'indicators/{filename}_split_{r}.{file_extension}.{approach}', 'r') as f:
            for line in f:
                return line[0]
        raise FileNotFoundError(f'File indicators/{filename}_split_{r}.{file_extension}.{approach} not found.')


def combine(in_dir, out_file):
    files = listdir(in_dir)
    with open(out_file, "w") as f:
        writer = csv.writer(f, delimiter="\t")
        writer.writerow(['algorithm', 'dataset', 'r', 'successful', 's', 'h:m:s', 'max_rss', 'max_vms', 'max_uss', 'max_pss', 'io_in', 'io_out', 'mean_load', 'cpu_time'])
        for fp in files:
            with open(os.path.join(in_dir, fp), 'r') as g:
                reader = csv.reader(g, delimiter="\t")
                next(reader)  # Headers line
                approach, filename, r, file_extension = parse_filename(fp)
                if approach == 'partdna':
                    success = 1
                else:
                    success = get_success_indicator(approach, filename, r, file_extension)
                writer.writerow([approach, filename, r, success] + next(reader))


if __name__ == '__main__':
    combine(sys.argv[1], sys.argv[2])
