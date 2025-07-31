`include "defines.svh"
class generator;

    transaction trans;
    mailbox #(transaction) mbx_gd;

    function new( mailbox #(transaction) mbx_gd );
        this.mbx_gd = mbx_gd;
        trans = new();
    endfunction

    task start();
        for( int i = 0; i < `no_of_trans; i++ ) begin
            if(trans.randomize()) begin
                mbx_gd.put(trans.copy());
                $display("\n----------------------------------------------------- Randomised values --------------------------------------------------------------------- \n");
                if(trans.mode)
                    $display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d \n",$time,trans.ce,trans.mode,trans.inp_valid,trans.cin,trans.opa,trans.opb);
                else
                    $display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %b | OPB = %b \n",$time,trans.ce,trans.mode,trans.inp_valid,trans.cin,trans.opa,trans.opb);
            end
            else begin
                    $error(" Generator randomization failed ");
            end
        end
    endtask

endclass
