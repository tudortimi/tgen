#!/bin/env python3.4

"""
   Copyright 2018 Tudor Timisescu (verificationgentleman.com)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""


import os
import subprocess
import sys
import unittest

sys.path.append('../../py')

import tgen.frontend
import tgen.backend


# Get tests in raw form
os.chdir('../sim')
subprocess.check_output([ './run.py', '--dump-test-attrs', 'tests', 'test0' ])
tests = tgen.frontend.JSONReader('tests_test_attrs.json').get_tests()

# Convert tests to vsif format
vsif_tests = []
for test in tests:
    name = test['name']
    count = test['num_runs_for_mini'] if 'num_runs_for_mini' in test else 1
    vsif_tests.append(tgen.backend.VsifTest(name, count))

# Generate vsif file
os.chdir('../vmanager')
tgen.backend.VsifWriter(vsif_tests).generate('tests.vsif')
