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


class uvm_test_extraction extends test_extraction;

  local const rf_package pkg;
  local const rf_class uvm_test;


  function new(string package_name);
    pkg = rf_manager::get_package_by_name(package_name);
    uvm_test = rf_manager::get_package_by_name("uvm_pkg").get_class_by_name("uvm_test");
  endfunction


  virtual function array_of_rf_class get_tests();
    rf_class classes[] = pkg.get_classes();
    rf_class result[$];

    foreach (classes[i])
      if (is_uvm_test(classes[i]) && !classes[i].is_abstract())
        result.push_back(classes[i]);

    return result;
  endfunction


  local function bit is_uvm_test(rf_class cls);
    rf_class base_class = cls.get_base_class();

    if (base_class == null)
      return 0;

    if (base_class.equals(uvm_test))
      return 1;

    return is_uvm_test(base_class);
  endfunction

endclass
