`include "defines.svh"
class scoreboard;
    transaction ref2sb_trans,mon2sb_trans;
    mailbox #(transaction) mbx_rs;
    mailbox #(transaction) mbx_ms;

    int match, mistake;


    function new(mailbox #(transaction)mbx_rs,mailbox #(transaction)mbx_ms);
        this.mbx_rs = mbx_rs;
        this.mbx_ms = mbx_ms;
    endfunction

    task start();
        for(int i = 0; i <`no_of_trans; i++)begin

            ref2sb_trans = new();
            mon2sb_trans = new();
            fork
                    mbx_rs.get(ref2sb_trans);
                    mbx_ms.get(mon2sb_trans);
            join
            compare_report();
                $display("-------------------------------------------------------------------------------------------------------------------------------------");
        end
    endtask


    task compare_report();
            if(ref2sb_trans.cmd == 8) begin
                    if((ref2sb_trans.e === mon2sb_trans.e) && (ref2sb_trans.g === mon2sb_trans.g) && (ref2sb_trans.l === mon2sb_trans.l)) begin
                 $display("SCOREBOARD REF RES[mon]=%0d, RES[ref]=%0d COUT[mon]=%0d, COUT[ref]=%0d OFLOW[mon]=%0d, OFLOW[ref]=%0d E[mon]=%0d, E[ref]=%0d G[mon]=%0d, G[ref]=%0d L[mon]=%0d, L[ref]=%0d ERR[mon]=%0d, ERR[ref]=%0d",mon2sb_trans.res,ref2sb_trans.res,mon2sb_trans.cout,ref2sb_trans.cout,mon2sb_trans.oflow,ref2sb_trans.oflow, mon2sb_trans.e,ref2sb_trans.e,mon2sb_trans.g,ref2sb_trans.g,mon2sb_trans.l,ref2sb_trans.l,mon2sb_trans.err,ref2sb_trans.err,$time);
                match++;
                 $display("DATA MATCH SUCCESSFUL MATCH=%d",match);
                   end
            end

               else if((ref2sb_trans.res === mon2sb_trans.res) && (ref2sb_trans.cout === mon2sb_trans.cout) && (ref2sb_trans.oflow === mon2sb_trans.oflow) && (ref2sb_trans.e === mon2sb_trans.e) && (ref2sb_trans.g === mon2sb_trans.g) && (ref2sb_trans.l === mon2sb_trans.l)&& (ref2sb_trans.err === mon2sb_trans.err))
                begin
                        $display("SCOREBOARD REF RES[mon]=%0d, RES[ref]=%0d COUT[mon]=%0d, COUT[ref]=%0d OFLOW[mon]=%0d, OFLOW[ref]=%0d E[mon]=%0d, E[ref]=%0d G[mon]=%0d, G[ref]=%0d L[mon]=%0d, L[ref]=%0d ERR[mon]=%0d, ERR[ref]=%0d",mon2sb_trans.res,ref2sb_trans.res,mon2sb_trans.cout,ref2sb_trans.cout,mon2sb_trans.oflow,ref2sb_trans.oflow, mon2sb_trans.e,ref2sb_trans.e,mon2sb_trans.g,ref2sb_trans.g,mon2sb_trans.l,ref2sb_trans.l,mon2sb_trans.err,ref2sb_trans.err,$time);
                        match++;
                        $display("DATA MATCH SUCCESSFUL MATCH=%d",match);
                end
                else
                begin
                        $display("SCOREBOARD REF RES[mon]=%0d, RES[ref]=%0d COUT[mon]=%0d, COUT[ref]=%0d OFLOW[mon]=%0d, OFLOW[ref]=%0d E[mon]=%0d, E[ref]=%0d G[mon]=%0d, G[ref]=%0d L[mon]=%0d, L[ref]=%0d ERR[mon]=%0d, ERR[ref]=%0d",mon2sb_trans.res,ref2sb_trans.res,mon2sb_trans.cout,ref2sb_trans.cout,mon2sb_trans.oflow,ref2sb_trans.oflow, mon2sb_trans.e,ref2sb_trans.e,mon2sb_trans.g,ref2sb_trans.g,mon2sb_trans.l,ref2sb_trans.l,mon2sb_trans.err,ref2sb_trans.err,$time);
                        mistake++;
                        $display("DATA MATCH FAILED MISMATCH=%d",mistake);
                end
  endtask
endclass
