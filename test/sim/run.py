#!/bin/env python3.4

import argparse
import subprocess


parser = argparse.ArgumentParser()
parser.add_argument('test')
parser.add_argument('--dump-test-attrs', action='store')
args = parser.parse_args()


cmd = [
    'irun',
    '-access', 'rw',
    '-uvm',
    '-incdir', '../sv',
    '../sv/tests.sv',
    '../sv/top.sv',
    '+UVM_TESTNAME=' + args.test,
    ]

if args.dump_test_attrs:
    cmd.append('-F')
    cmd.append('../../build/tgen.f')

    cmd.append('../../sv/tgen_dumper.sv')
    cmd.append('+TGEN_PKGNAME=' + args.dump_test_attrs)

subprocess.call(cmd)
