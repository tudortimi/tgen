import os
import subprocess
import sys
import unittest

sys.path.append('../py')

import tgen


class TestIntegration(unittest.TestCase):

    def test_read_from_dumper(self):
        os.chdir('sim')
        subprocess.call([ './run.py', '--dump-test-attrs', 'tests', 'test0' ])
        tests = tgen.TestReader('tests_test_attrs.json').get_tests()

        self.assertEqual(len(tests), 4)

        test_names = [test['name'] for test in tests]
        self.assertListEqual([ 'test0', 'test1', 'derived_test0', 'derived_test1' ], test_names)

        test0 = next(test for test in tests if test['name'] == 'test0')
        self.assertEqual(test0['num_runs_for_mini'], 10)

        test1 = next(test for test in tests if test['name'] == 'test1')
        self.assertEqual(test1['num_runs_for_normal'], 100)

        # Need to fix
        #derived_test0 = next(test for test in tests if test['name'] == 'derived_test0')
        #self.assertEqual(derived_test0['num_runs_for_mini'], 1)

        derived_test1 = next(test for test in tests if test['name'] == 'derived_test1')
        self.assertEqual(derived_test1['num_runs_for_mini'], 2)


if __name__ == '__main__':
    unittest.main()
