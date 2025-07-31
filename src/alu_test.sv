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

class inpvalid_00 extends test;
        transaction_1 inp00;

        function new(virtual alu_intf drv_vif, virtual alu_intf mon_vif, virtual alu_intf ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
                inp00 = new();
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build();
                env.gen.trans = inp00;
                env.start();
        endtask

endclass

class inpvalid_10 extends test;
        transaction_2 inp10;

        function new(virtual alu_intf drv_vif, virtual alu_intf mon_vif, virtual alu_intf ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
                inp10 = new();
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build();
                env.gen.trans = inp10;
                env.start();
        endtask

endclass

class inpvalid_01 extends test;
        transaction_3 inp01;

        function new(virtual alu_intf drv_vif, virtual alu_intf mon_vif, virtual alu_intf ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
                inp01 = new();
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build();
                env.gen.trans = inp01;
                env.start();
        endtask

endclass

class regress_test extends test;
        transaction_1 inp01;
        transaction_2 inp10;
        transaction_3 inp11;

        function new(virtual alu_intf drv_vif, virtual alu_intf mon_vif, virtual alu_intf ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
                inp01 = new;
                inp10 = new;
                inp11 = new;
        endfunction

        task run();
                    env = new(drv_vif, mon_vif, ref_vif);
                    env.build();
                    $display("\n\n---------------------------------------- Mormal. Cases ---------------------------------------------\n\n");

                    begin
                            env.start();
                    end
                    $display("\n\n---------------------------------------- Inp_Valid_01 Cases ---------------------------------------------\n\n");
                    begin
                            env.gen.trans = inp01;
                            env.start();
                    end
                    $display("\n\n---------------------------------------- Inp_Valid_10 Cases ---------------------------------------------\n\n");
                    begin
                            env.gen.trans = inp10;
                            env.start();
                    end
                    $display("\n\n---------------------------------------- Inp_Valid_11 Cases ---------------------------------------------\n\n");
                    begin
                            env.gen.trans = inp11;
                            env.start();
                    end
        endtask

endclass
