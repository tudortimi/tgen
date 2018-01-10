class derived_test1 extends abstract_test;

  (* tgen_test_attr *)
  static const int num_runs_for_mini = 2;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  `uvm_component_utils(derived_test1)

endclass
