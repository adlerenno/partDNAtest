from os import listdir
import csv
import re
import sys


def parse_filename(filename):
    # Define the regular expression patterns for the two formats
    pattern1 = re.compile(r'^(?P<filename>[^_]+)_(?P<r>\d+)\.(?P<approach>[^.]+)\.csv$')
    pattern2 = re.compile(r'^(?P<filename>[^.]+)\.(?P<approach>[^.]+)\.csv$')

    match1 = pattern1.match(filename)
    if match1:
        return match1.group('approach'), match1.group('filename'), '0'  # Default value when r is not provided


    match2 = pattern2.match(filename)
    if match2:
        return match2.group('approach'), match2.group('filename'), match2.group('r')


    # If neither pattern matches, raise an error
    raise ValueError(f"Filename '{filename}' does not match expected patterns")


def get_success_indicator(approach, filename, r):
    with open(f'indicators/{filename}_{r}.{approach}', 'r') as f:
        for line in f:
            return line[0]


def combine(in_dir, out_file):
    files = listdir(in_dir)
    with open(out_file, "w") as f:
        writer = csv.writer(f, delimiter="\t")
        writer.writerow(['algorithm', 'dataset', 'r', 'successful', 's', 'h:m:s', 'max_rss', 'max_vms', 'max_uss', 'max_pss', 'io_in', 'io_out', 'mean_load', 'cpu_time'])
        for fp in files:
            with open(fp, 'r') as g:
                reader = csv.reader(g, delimiter="\t")
                next(reader)  # Headers line
                approach, filename, r = parse_filename(fp)
                success = get_success_indicator(approach, filename, r)
                writer.writerow([approach, filename, r, success] + next(reader))


if __name__ == '__main__':
    combine(sys.argv[1], sys.argv[2])
