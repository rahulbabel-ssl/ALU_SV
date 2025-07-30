`include "defines.svh"
class driver;
    transaction drv_trans;
    mailbox #(transaction)mbx_gd;
    mailbox #(transaction)mbx_dr;
    virtual alu_intf.driver_modport vif;
    int count = 0;
covergroup drv_cg;
    MODE_CP: coverpoint drv_trans.mode;
    INP_VALID_CP : coverpoint drv_trans.inp_valid;
    CMD_CP : coverpoint drv_trans.cmd {
      bins valid_cmd[] = {[0:13]};
      ignore_bins invalid_cmd[] = {14, 15};
    }
    OPA_CP : coverpoint drv_trans.opa {
      bins all_zeros_a = {0};
      bins opa = {[0:`MAX]};
      bins all_ones_a = {`MAX};
    }
    OPB_CP : coverpoint drv_trans.opb {
      bins all_zeros_b = {0};
      bins opb = {[0:`MAX]};
      bins all_ones_b = {`MAX};
    }
    CIN_CP : coverpoint drv_trans.cin;
    CMD_X_IP_V: cross CMD_CP, INP_VALID_CP;
    MODE_X_INP_V: cross MODE_CP, INP_VALID_CP;
    MODE_X_CMD: cross MODE_CP, CMD_CP;
    OPA_X_OPB : cross OPA_CP, OPB_CP;
  endgroup

    function new( mailbox #(transaction)mbx_gd,mailbox #(transaction)mbx_dr, virtual alu_intf.driver_modport vif);
        this.mbx_gd = mbx_gd;
        this.mbx_dr = mbx_dr;
        this.vif = vif;
        drv_cg = new();
    endfunction

    task start();
        repeat(3) @(vif.driver_cb);
        for(int i = 0;i <`no_of_trans;i++)
        begin
            drv_trans = new();

            mbx_gd.get(drv_trans);
            drv_cg.sample;
            if(vif.rst)
                repeat(vif.rst)
                begin
                    vif.driver_cb.ce <= 1;
                    vif.driver_cb.cin <= 0;
                    vif.driver_cb.opa <= 0;
                    vif.driver_cb.opb <= 0;
                    vif.driver_cb.mode <= 0;
                    vif.driver_cb.inp_valid <= 0;
                    mbx_dr.put(drv_trans);
                    repeat(1)@(vif.driver_cb);
         //           $display("DRIVER WRITE OPERATvif.reference_cbION DRIVING DATA TO THE INTERFACE ce=%d,cin=%d,opa=%d,opb=%d,mode=%d,inp_valid=%d",vif.ce,vif.cin,vif.opa,vif.opb,vif.mode,vif.inp_valid,$time);
                end
            else
                repeat(1)@(vif.driver_cb)
                begin
                    vif.driver_cb.ce <= drv_trans.ce;
                    vif.driver_cb.cin <= drv_trans.cin;
                    vif.driver_cb.opa <= drv_trans.opa;
                    vif.driver_cb.opb <= drv_trans.opb;
                    vif.driver_cb.mode <= drv_trans.mode;
                    vif.driver_cb.inp_valid <= drv_trans.inp_valid;
                    vif.driver_cb.cmd <= drv_trans.cmd;
                    //if(drv_trans.cmd == 9) repeat (2) @(vif.driver_cb);
                    mbx_dr.put(drv_trans);
                    repeat(1)@(vif.driver_cb);
                    $display("DRIVER WRITE OPERATION DRIVING DATA TO THE INTERFACE ce=%d,cin=%d,opa=%d,opb=%d,mode=%d,inp_valid=%d,cmd = %d",drv_trans.ce,drv_trans.cin,drv_trans.opa,drv_trans.opb,drv_trans.mode,drv_trans.inp_valid,drv_trans.cmd,$time);
                end
           /* if(!rst && (drv_trans.inp_valid == 2'b01 || drv.inp_valid == 2'b10))
                repeat(1) @(vif.driver_cb)
                begin
                    count = count + 1;




                end*/
        end
    endtask
endclass
