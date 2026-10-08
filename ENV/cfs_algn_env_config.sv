`ifndef CFS_ALGN_ENV_CONFIG_SV
`define CFS_ALGN_ENV_CONFIG_SV

  class cfs_algn_env_config extends uvm_component;
    
    //Switch to enable checks
    local bit has_checks;
    
    //Aligner data width
    local int unsigned algn_data_width;
    
    `uvm_component_utils(cfs_algn_env_config)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      has_checks      = 1;
      algn_data_width = 8;
    endfunction
    
    //Getter for the has_checks control field
    virtual function bit get_has_checks();
      return has_checks;
    endfunction
        
    //Setter for the has_checks control field
    virtual function void set_has_checks(bit value);
      has_checks = value;
    endfunction
    
    //Getter for the algn_data_width control field
    virtual function int unsigned get_algn_data_width();
      return algn_data_width;
    endfunction
    
    //setter for the algn_data_width control field
    virtual function void set_algn_data_width(int unsigned value);
      //The minimum legal value for this field is 8.
      if(value < 8) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("The minimum legal value for algn_data_width is 8 but user tried to set it to %0d", value))
      end
      
      //The value must be a power of 2
      if($countones(value) != 1) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Thevalue for algn_data_width must be a power of 2 but user tried to set it to %0d", value))
      end
      
      algn_data_width = value;
    endfunction
  endclass
`endif
