#!/bin/bash
rm -rf ./tmp
sudo mount -t tmpfs none ./tmp  # Uses max 50% of available RAM for RAM disc