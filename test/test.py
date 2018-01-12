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

sys.path.append('../py')

import tgen.frontend


class TestIntegration(unittest.TestCase):

    def test_read_from_dumper(self):
        os.chdir('sim')
        subprocess.call([ './run.py', '--dump-test-attrs', 'tests', 'test0' ])
        tests = tgen.frontend.JSONReader('tests_test_attrs.json').get_tests()

        self.assertEqual(len(tests), 4)

        test_names = [test['name'] for test in tests]
        self.assertListEqual([ 'test0', 'test1', 'derived_test0', 'derived_test1' ], test_names)

        test0 = next(test for test in tests if test['name'] == 'test0')
        self.assertEqual(test0['num_runs_for_mini'], 10)

        test1 = next(test for test in tests if test['name'] == 'test1')
        self.assertEqual(test1['num_runs_for_normal'], 100)

        derived_test0 = next(test for test in tests if test['name'] == 'derived_test0')
        self.assertEqual(derived_test0['num_runs_for_mini'], 1)

        derived_test1 = next(test for test in tests if test['name'] == 'derived_test1')
        self.assertEqual(derived_test1['num_runs_for_mini'], 2)


if __name__ == '__main__':
    unittest.main()
