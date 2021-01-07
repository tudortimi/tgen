#!/bin/env python3.4

import argparse
import subprocess


parser = argparse.ArgumentParser()
parser.add_argument('-t',
                    '--test',
                    action='append',
                    dest='tests',
                    help='only run specified test(s)')
args = parser.parse_args()


cmd = [
    'runSVUnit',
    '-s', 'ius',
    '-o', 'sim',
    ]

subprocess.check_call(['./gradlew', 'genFullArgsFile'], cwd='..')
cmd.extend(['-f', '../build/full_args.f'])

if args.tests:
    for test in args.tests:
        cmd.append('-t')
        cmd.append(test)


subprocess.call(cmd)
