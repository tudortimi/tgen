class test1 extends uvm_test;

  (* tgen_test_attr *)
  static const int num_runs_for_normal = 100;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  `uvm_component_utils(test1)

endclass
