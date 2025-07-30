`ifndef APB_CONFIG_SV
`define APB_CONFIG_SV

    class APB_config extends uvm_object;

        `uvm_object_utils (APB_config)
        virtual APB_if apb_if;
        uvm_active_passive_enum is_active;

        // Default Constructor
        function new(string name = "APB_config");
            super.new(name);
        endfunction
        
    endclass : APB_config

`endif // APB_CONFIG_SV