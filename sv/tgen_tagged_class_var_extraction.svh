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


/**
 * Extracts attributes for the supplied class by looking for its class variables that are tagged
 * with the 'tgen_test_attr' SystemVerilog attribute.
 *
 * Only 'static' variables are allowed so that the extraction can be done from the class type and
 * not from an object of the class. Only 'const' variables are allowed, otherwise it would be
 * possible to modify their values before performing extraction.
 *
 * Attributes for a class are inherited from its base class. The normal rules of 'static' variable
 * scoping apply:
 *
 *   - if 'attr' isn't present in 'class' a reference to 'class::attr' delivers the value of 'attr'
 *     defined in the base class (assuming it exists)
 *   - if 'attr' is present in both 'class' and its base class, then a reference to 'class::attr'
 *     delivers the value defined in 'class'
 */
class tagged_class_var_extraction extends test_attributes;

  local const rf_variable tagged_vars[$];


  function new(rf_class class_);
    tagged_vars = get_pruned_vars(get_tagged_vars(class_));
  endfunction


  local function array_of_rf_variable get_pruned_vars(array_of_rf_variable vars);
    rf_variable result[$] = vars;

    for (int i = 0; 1; i++) begin
      string name = result[i].get_name();
      int find_result[$] = result.find_index() with (item.get_name() == name);

      while (find_result.size() > 1) begin
        int last_duplicate = find_result.pop_back();
        result.delete(last_duplicate);
      end

      if (i == result.size() - 1)
        break;
    end

    return result;
  endfunction


  local function array_of_rf_variable get_tagged_vars(rf_class class_);
    rf_variable result[$];

    rf_variable vars[] = class_.get_variables();
    foreach (vars[i])
      if (has_tgen_attr(vars[i]))
        if (is_supported(vars[i]))
          result.push_back(vars[i]);
        else
          issue_not_supported_error(vars[i]);

    if (class_.get_base_class() != null) begin
      result = { result, get_tagged_vars(class_.get_base_class()) };
    end

    return result;
  endfunction


  local function bit is_supported(rf_variable var_);
    return var_.is_static() && var_.is_const();
  endfunction


  local function void issue_not_supported_error(rf_variable var_);
    $error(
        "Unsupported test attribute variable '%s' found. %s\n%s",
        var_.get_name(),
        "Only 'static const' variables are supported.",
        "Skipping.");
  endfunction


  virtual function bit has(string name);
    int find_result[$];
    find_result = tagged_vars.find_first_index() with (item.get_name() == name);
    return find_result.size() > 0;
  endfunction


  local function bit has_tgen_attr(rf_variable var_);
    rf_attribute attrs[] = var_.get_attributes();
    foreach (attrs[i])
      if (attrs[i].get_name() == "tgen_test_attr")
        return 1;
    return 0;
  endfunction


  virtual function strings get_all();
    string result[$];
    foreach (tagged_vars[i])
      result.push_back(tagged_vars[i].get_name());
    return result;
  endfunction


  virtual function rf_value_base get_value(string name);
    rf_variable find_result[$];

    `prog_assert(has(name))

    find_result = tagged_vars.find_first() with (item.get_name() == name);
    return find_result[0].get();
  endfunction

endclass
