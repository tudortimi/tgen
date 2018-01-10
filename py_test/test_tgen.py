import sys
import unittest

sys.path.append('../py')

import tgen


class TestTGen(unittest.TestCase):

    def test_read_one_test(self):
        t = tgen.TestReader('one_test.json')
        tests = t.get_tests()
        self.assertEqual(len(tests), 1)

    def test_read_two_tests(self):
        t = tgen.TestReader('two_tests.json')
        tests = t.get_tests()
        self.assertEqual(len(tests), 2)


if __name__ == '__main__':
    unittest.main()
