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


`define class_declaration(NAME, BASE = uvm_test) \
  class NAME extends BASE; \
    function new(string name, uvm_component parent); \
      super.new(name, parent); \
    endfunction \
  endclass


package dummy_package0_for_uvm_test_extraction_unit_test;

  import uvm_pkg::*;

  `class_declaration(some_test_from_dummy_package0)
  `class_declaration(some_other_test_from_dummy_package0)

endpackage


package dummy_package1_for_uvm_test_extraction_unit_test;

  class some_class;
  endclass

endpackage


package dummy_package2_for_uvm_test_extraction_unit_test;

  import uvm_pkg::*;

  virtual `class_declaration(some_abstract_test)

endpackage



module uvm_test_extraction_unit_test;

  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "uvm_test_extraction_ut";
  svunit_testcase svunit_ut;


  import tgen::*;
  import reflection::*;


  // Dummy packages need to be imported somewhere, otherwise they aren't visible for 'reflection'.
  import dummy_package0_for_uvm_test_extraction_unit_test::*;
  import dummy_package1_for_uvm_test_extraction_unit_test::*;
  import dummy_package2_for_uvm_test_extraction_unit_test::*;


  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask



  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_tests__returns_subclasses_of_uvm_test)
      uvm_test_extraction extr = new("dummy_package0_for_uvm_test_extraction_unit_test");
      array_of_rf_class tests = extr.get_tests();

      // SVUnit macros have a hard time with inline strings
      string exp_test_names[] = {
          "some_test_from_dummy_package0",
          "some_other_test_from_dummy_package0" };

      `FAIL_UNLESS(tests.size() == 2)
      foreach (tests[i])
        `FAIL_UNLESS(tests[i].get_name() inside { exp_test_names })
    `SVTEST_END


    `SVTEST(get_tests__ignores_classes_unrelated_to_uvm_test)
      uvm_test_extraction extr = new("dummy_package1_for_uvm_test_extraction_unit_test");
      array_of_rf_class tests = extr.get_tests();

      `FAIL_UNLESS(tests.size() == 0)
    `SVTEST_END


    `SVTEST(get_tests__ignores_abstract_uvm_test_subclasses)
      uvm_test_extraction extr = new("dummy_package2_for_uvm_test_extraction_unit_test");
      array_of_rf_class tests = extr.get_tests();

      `FAIL_UNLESS(tests.size() == 0)
    `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
