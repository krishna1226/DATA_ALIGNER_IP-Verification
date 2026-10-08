`ifndef CFS_MD_RESET_HANDLER_SV
  `define CFS_MD_RESET_HANDLER_SV

  interface class cfs_md_reset_handler;

    //Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);

    endclass

`endif

