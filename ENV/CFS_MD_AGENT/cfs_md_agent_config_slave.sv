`ifndef CFS_MD_AGENT_CONFIG_SLAVE_SV
  `define CFS_MD_AGENT_CONFIG_SLAVE_SV

class cfs_md_agent_config_slave#(int unsigned DATA_WIDTH = 32) extends cfs_md_agent_config#(DATA_WIDTH);

    // Value of the "ready" signal at reset
    local bit ready_at_reset;
    
    `uvm_component_param_utils(cfs_md_agent_config_slave#(DATA_WIDTH))

    function new(string name = "", uvm_component parent);
      super.new(name, parent);

      ready_at_reset = 1;
    endfunction

    virtual function void set_ready_at_reset(bit value);
        ready_at_reset = value;
    endfunction

    virtual function bit get_ready_at_reset();
        return ready_at_reset;
    endfunction
  endclass

`endif

