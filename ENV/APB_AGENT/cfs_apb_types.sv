`ifndef CFS_APB_TYPES_SV
`define CFS_APB_TYPES_SV
    
    // virtual interface
    typedef virtual cfs_apb_if cfs_apb_vif;

    // APB direction
    typedef enum bit{CFS_APB_READ = 0, CFS_APB_WRITE = 1} cfs_apb_dir;

    // APB ADDRESS
    typedef bit[`CFS_APB_MAX_ADDR_WIDTH-1:0] cfs_apb_addr;

    // APB DATA
    typedef bit[`CFS_APB_MAX_DATA_WIDTH-1:0] cfs_apb_data;

    // APB RESPONSE
    typedef enum bit{CFS_APB_OK = 0, CFS_APB_ERR = 1} cfs_apb_response;
`endif
