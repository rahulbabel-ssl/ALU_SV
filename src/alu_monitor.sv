`include "defines.svh"
class monitor;
    transaction mon_trans;
    mailbox #(transaction)mbx_ms;
    virtual alu_intf.monitor_modport vif;

    function new(virtual alu_intf.monitor_modport vif, mailbox #(transaction)mbx_ms);
        this.vif = vif;
        this.mbx_ms = mbx_ms;
    endfunction

    task start();
        repeat(5)@(vif.monitor_cb);
        for(int i = 0;i<`no_of_trans;i++)
        begin
            mon_trans=new();
            repeat(1)@(vif.monitor_cb)
            begin
                mon_trans.ce        = vif.monitor_cb.ce;
                mon_trans.cin       = vif.monitor_cb.cin;
                mon_trans.mode      = vif.monitor_cb.mode;
                mon_trans.inp_valid = vif.monitor_cb.inp_valid;
                mon_trans.opa       = vif.monitor_cb.opa;
                mon_trans.opb       = vif.monitor_cb.opb;
                mon_trans.res       = vif.monitor_cb.res;
                mon_trans.cout      = vif.monitor_cb.cout;
                mon_trans.oflow     = vif.monitor_cb.oflow;
                mon_trans.err       = vif.monitor_cb.err;
                mon_trans.g         = vif.monitor_cb.g;
                mon_trans.l         = vif.monitor_cb.l;
                mon_trans.e         = vif.monitor_cb.e;
            end
            mbx_ms.put(mon_trans);
                $display("Monitor output res = %d , cout = %d, oflow = %d, err = %d, g = %d, l = %d , e = %d",mon_trans.res,mon_trans.cout,mon_trans.oflow,mon_trans.err,mon_trans.g,mon_trans.l,mon_trans.e,$time);
                repeat(1) @(vif.monitor_cb);
        end
    endtask
endclass
