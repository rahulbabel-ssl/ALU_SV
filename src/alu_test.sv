`include "defines.svh"
class test;
    virtual alu_intf drv_vif;
    virtual alu_intf mon_vif;
    virtual alu_intf ref_vif;

    environment env;

    function new(virtual alu_intf drv_vif, virtual alu_intf mon_vif, virtual alu_intf ref_vif);
        this.drv_vif = drv_vif;
        this.mon_vif = mon_vif;
        this.ref_vif = ref_vif;
    endfunction

    task run();
        env = new(drv_vif,mon_vif,ref_vif);
        env.build;
        env.start;
    endtask
endclass
