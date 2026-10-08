`ifndef CFS_ALGN_MODEL_SV
  `define CFS_ALGN_MODEL_SV

  class cfs_algn_model extends uvm_component implements uvm_ext_reset_handler;
    
    //Pointer to the environment configuration
    cfs_algn_env_config env_config;

    //Register block
    cfs_algn_reg_block reg_block;
    
    `uvm_component_utils(cfs_algn_model)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);  
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(reg_block == null) begin
        reg_block = cfs_algn_reg_block::type_id::create("reg_block", this);
        
        reg_block.build();
        reg_block.lock_model();
      end
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
      cfs_algn_clr_cnt_drop cbs_clr_cnt_drop;
      
      super.connect_phase(phase);
      
      cbs_clr_cnt_drop = cfs_algn_clr_cnt_drop::type_id::create("cbs_clr_cnt_drop");
      cbs_clr_cnt_drop.cnt_drop = reg_block.STATUS.CNT_DROP;
      uvm_reg_field_cb::add(reg_block.CTRL.CLR, cbs_clr_cnt_drop);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      
      reg_block.CTRL.SET_ALGN_DATA_WIDTH(env_config.get_algn_data_width());
    endfunction
    
    virtual function void handle_reset(uvm_phase phase);
      reg_block.reset("HARD");
    endfunction
    
  endclass

`endif
