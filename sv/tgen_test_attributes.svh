// Copyright 2018 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


virtual class test_attributes;

  // XXX Should be an interface class


  typedef string strings[];


  /**
   * Returns '1' if and only if an attribute called 'name' is present.
   */
  pure virtual function bit has(string name);

  /**
   * Returns a list of all attribute names that are present.
   */
  pure virtual function strings get_all();

  /**
   * Returns the value of the requested attribute. If the attribute doesn't have a value, it returns
   * null. Throws an error if the attribute doesn't exist.
   */
  pure virtual function rf_value_base get_value(string name);

endclass
