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



module tagged_class_var_extraction_unit_test;

  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "tagged_class_var_extraction_ut";
  svunit_testcase svunit_ut;


  import tgen::*;
  import reflection::*;

  tagged_class_var_extraction extr_attrs;
  tagged_class_var_extraction extr_attr_vals;
  tagged_class_var_extraction extr_subclass_attr_vals;


  typedef class some_class;


  function void build();
    svunit_ut = new(name);

    extr_attrs = new(
        rf_manager::get_module_by_name("tagged_class_var_extraction_unit_test")
            .get_class_by_name("some_class"));
    extr_attr_vals = new(
        rf_manager::get_module_by_name("tagged_class_var_extraction_unit_test")
            .get_class_by_name("some_other_class"));
    extr_subclass_attr_vals = new(
        rf_manager::get_module_by_name("tagged_class_var_extraction_unit_test")
            .get_class_by_name("some_derived_class"));
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask



  class some_class;

    (* tgen_test_attr *)
    static const int tagged_var = 0;

    static const int untagged_var = 0;

    (* some_attr *)
    static const int wrongly_tagged_var = 0;

    (* tgen_test_attr *)
    static const int another_tagged_var = 0;

    (* tgen_test_attr *)
    static const int yet_another_tagged_var = 0;

  endclass


  class some_other_class;

    (* tgen_test_attr *)
    static const int int_attr = 42;

  endclass


  class some_base_class;

    (* tgen_test_attr *)
    static const int base_var = 1000;

    (* tgen_test_attr *)
    static const int overridden_var = 100;

  endclass


  class some_derived_class extends some_base_class;

    (* tgen_test_attr *)
    static const int overridden_var = 10;

  endclass



  `SVUNIT_TESTS_BEGIN

    `SVTEST(has__tagged_var__returns_1)
      string name = "tagged_var";
      `FAIL_UNLESS(extr_attrs.has(name))
    `SVTEST_END


    `SVTEST(has__untagged_var__returns_0)
      string name = "untagged_var";
      `FAIL_IF(extr_attrs.has(name))
    `SVTEST_END


    `SVTEST(has__wrongly_tagged_var__returns_0)
      string name = "wrongly_tagged_var";
      `FAIL_IF(extr_attrs.has(name))
    `SVTEST_END


    `SVTEST(has__in_derived_class_attr_from_base_class__return_1)
      string name = "base_var";
      `FAIL_UNLESS(extr_subclass_attr_vals.has(name))
    `SVTEST_END


    `SVTEST(get_all__returns_all_tagged_vars)
      string exp_names[] = {
          "tagged_var",
          "another_tagged_var",
          "yet_another_tagged_var" };

      string attrs[] = extr_attrs.get_all();
      `FAIL_UNLESS(attrs.size() == 3)
      foreach (attrs[i])
        `FAIL_UNLESS(attrs[i] inside { exp_names })
    `SVTEST_END


    `SVTEST(get_all__derived_class_with_overridden__returns_overriden_only_once)
      string attrs[] = extr_subclass_attr_vals.get_all();
      `FAIL_UNLESS(attrs.size() == 2)
      `FAIL_IF(attrs[0] == attrs[1])
    `SVTEST_END


    `SVTEST(get_value__int_attr__returns_value)
      rf_value_base value = extr_attr_vals.get_value("int_attr");
      rf_value #(int) int_value;

      `FAIL_UNLESS($cast(int_value, value))
      `FAIL_UNLESS(int_value.get() == 42)
    `SVTEST_END


    `SVTEST(get_value__overriden_var__returns_overriden_value)
      rf_value_base value = extr_subclass_attr_vals.get_value("overridden_var");
      rf_value #(int) int_value;

      `FAIL_UNLESS($cast(int_value, value))
      `FAIL_UNLESS(int_value.get() == 10)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
