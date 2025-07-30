`include "defines.svh"
class environment;
    virtual alu_intf drv_vif;
    virtual alu_intf mon_vif;
    virtual alu_intf ref_vif;

    mailbox #(transaction) mbx_gd;
    mailbox #(transaction) mbx_dr;
    mailbox #(transaction) mbx_rs;
    mailbox #(transaction) mbx_ms;

    generator           gen;
    driver              drv;
    monitor             mon;
    reference_model     ref_sb;
    scoreboard          scb;

    function new (virtual alu_intf drv_vif,
                  virtual alu_intf mon_vif,
                  virtual alu_intf ref_vif);
        this.drv_vif = drv_vif;
        this.mon_vif = mon_vif;
        this.ref_vif = ref_vif;
    endfunction

    task build();
        begin
            mbx_gd = new();
            mbx_dr = new();
            mbx_rs = new();
            mbx_ms = new();

            gen     = new(mbx_gd);
            drv     = new(mbx_gd,mbx_dr,drv_vif);
            mon     = new(mon_vif,mbx_ms);
            ref_sb  = new(mbx_dr,mbx_rs,ref_vif);
            scb     = new(mbx_rs,mbx_ms);
        end
    endtask

    task start();
        drv.drv_cg.start;
        fork
            gen.start();
            drv.start();
            mon.start();
            scb.start();
            ref_sb.start();
        join
        scb.compare_report();
    endtask
endclass
