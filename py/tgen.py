import collections
import json


class TestReader:

    def __init__(self, inputFile):
        self._inputFile = inputFile

    def get_tests(self):
        with open(self._inputFile, 'r') as f:
            tests = json.load(f)

        return tests
