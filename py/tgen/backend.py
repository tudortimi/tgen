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


class VsifTest:

    def __init__(self, name, count=1):
        self.name = name
        self.count = count



class VsifWriter:

    def __init__(self, tests):
        self._tests = tests

    def generate(self, outputFile):
        with open(outputFile, 'w') as f:
            f.write("// Generated by 'tgen'\n")
            f.write('\n')
            f.write('group tests {\n')
            f.write('\n')
            for test in self._tests:
                self._write_test(test, f)
                f.write('\n')
            f.write('};\n')

    def _write_test(self, test, f):
        f.write('  test {t.name} {{\n'.format(t=test))
        f.write('    count: {t.count};\n'.format(t=test))
        f.write('  };\n')