from os import listdir
import csv
import re


def parse_filename(filename):
    # Define the regular expression patterns for the two formats
    pattern1 = re.compile(r'^(?P<filename>[^_]+)_(?P<r>\d+)\.(?P<approach>[^.]+)\.csv$')
    pattern2 = re.compile(r'^(?P<filename>[^.]+)\.(?P<approach>[^.]+)\.csv$')

    match1 = pattern1.match(filename)
    if match1:
        return [
            match1.group('approach'),
            match1.group('filename'),
            '0',  # Default value when r is not provided
        ]

    match2 = pattern2.match(filename)
    if match2:
        return [
            match2.group('approach'),
            match2.group('filename'),
            match2.group('r'),
        ]

    # If neither pattern matches, raise an error
    raise ValueError(f"Filename '{filename}' does not match expected patterns")


files = listdir('bench')
with open('benchmark.csv', "w") as f:
    writer = csv.writer(f, delimiter="\t")
    writer.writerow(['algorithm', 'dataset', 'r', ])
    for fp in files:
        with open(fp, 'r') as g:
            reader = csv.reader(g, delimiter="\t")
            next(reader)  # Headers line
            writer.writerow(parse_filename(fp) + next(reader))
