#!/bin/env python3.4

import argparse
import subprocess


parser = argparse.ArgumentParser()
args = parser.parse_args()


cmd = [
    'runSVUnit',
    '-s', 'ius',
    '-o', 'sim',
    ]

subprocess.call(cmd)
