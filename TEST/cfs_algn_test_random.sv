`ifndef CFS_ALGN_TEST_RANDOM_SV
`define CFS_ALGN_TEST_RANDOM_SV

class cfs_algn_test_random extends cfs_algn_test_base;

    `uvm_component_utils(cfs_algn_test_random)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this, "TEST_DONE");
      
      #(100ns);
      
      fork
        begin
          cfs_md_sequence_slave_response_forever seq = cfs_md_sequence_slave_response_forever::type_id::create("seq");
          
          seq.start(env.md_tx_agent.sequencer);
        end
      join_none
      
      repeat(100) begin
        cfs_md_sequence_simple_master seq_simple = cfs_md_sequence_simple_master::type_id::create("seq_simple");
        seq_simple.set_sequencer(env.md_rx_agent.sequencer);

        void'(seq_simple.randomize());

        seq_simple.start(env.md_rx_agent.sequencer);
      end
      
      #(500ns);
      
      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
      phase.drop_objection(this, "TEST_DONE"); 
    endtask

endclass
`endif
