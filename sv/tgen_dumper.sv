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


module tgen_dumper;

  import uvm_pkg::*;
  import reflection::*;

  import tgen::*;


  string package_name = get_package_name();


  initial begin
    automatic uvm_test_extraction test_extraction;
    automatic rf_class tests[];

    $display("Dumping TGen test attributes for package '%s'", package_name);

    test_extraction = new(package_name);
    tests = test_extraction.get_tests();
    write_attrs(tests);
  end


  function automatic string get_package_name();
    string plusargs[$];
    void'(uvm_cmdline_proc.get_arg_values("+TGEN_PKGNAME=", plusargs));

    // TODO Currently only dumping from a single package is supported.
    return plusargs[0];
  endfunction


  function automatic void write_attrs(rf_class tests[]);
    automatic integer file = $fopen($sformatf("%s_test_attrs.json", package_name), "w");
    $fwrite(file, "[");

    foreach (tests[i]) begin
      $fwrite(file, get_attrs_for_single_test(tests[i]));
      if (i != tests.size() - 1)
        $fwrite(file, ",");
    end

    $fwrite(file, "]");
    $fclose(file);
  endfunction


  function automatic string get_attrs_for_single_test(rf_class test);
    string result;
    rf_variable test_attrs[] = read_attrs(test);

    result = { result, "{" };
    result = { result, $sformatf("\"name\": \"%s\"", test.get_name()) };

    foreach (test_attrs[i]) begin
      result = { result, "," };
      result = {
          result,
          $sformatf(
              "\"%s\": %s",
              test_attrs[i].get_name(),
              value(test_attrs[i])) };
    end

    result = { result, "}" };
    return result;
  endfunction


  function automatic array_of_rf_variable read_attrs(rf_class test);
    rf_variable result[$];
    rf_variable vars[] = test.get_variables();

    foreach (vars[i])
      if (is_test_attr(vars[i])) begin
        if (!vars[i].is_static() || !vars[i].is_const()) begin
          string supported_msg = "Only 'static const' variables are supported.";

          $error(
              "Unsupported test attribute variable '%s' found. %s\n%s",
              vars[i].get_name(),
              supported_msg,
              "Skipping.");
          continue;
        end

        result.push_back(vars[i]);
      end

    return result;
  endfunction


  function automatic bit is_test_attr(rf_variable v);
    rf_attribute attrs[] = v.get_attributes();
    foreach (attrs[i])
      if (attrs[i].get_name() == "tgen_test_attr")
        return 1;
    return 0;
  endfunction


  function string value(rf_variable v);
    rf_value #(int) val;
    if (!$cast(val, v.get()))
      $error("Unsupported variable type");
    return $sformatf("%0d", val.get());
  endfunction

endmodule
