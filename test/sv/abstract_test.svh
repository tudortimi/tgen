virtual class abstract_test extends uvm_test;

  (* tgen_test_attr *)
  static const int num_runs_for_mini = 1;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
