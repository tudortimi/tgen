class sequence1 extends uvm_sequence;

  function new(string name = get_type_name());
    super.new(name);
  endfunction


  `uvm_object_utils(sequence1)

endclass
