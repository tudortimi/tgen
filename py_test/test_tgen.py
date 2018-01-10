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
