`include "defines.svh"
interface alu_intf(input bit clk, rst);
    logic cin, ce, mode;
    logic [`CMD_WIDTH-1:0] cmd;
    logic [1:0] inp_valid;
    logic [`WIDTH-1:0] opa, opb;
    logic [`WIDTH:0] res;
    logic oflow, err, cout, g, l, e;

    clocking driver_cb@( posedge clk );
        default input #0 output #0;
        output ce, cin, mode, inp_valid, opa, opb, cmd;
    endclocking

    clocking monitor_cb@( posedge clk );
        default input #0 output #0;
        input ce, cin, mode, inp_valid, opa, opb, rst,cmd;
        input res, cout, oflow, err, g, l, e;
    endclocking

    clocking reference_cb@( posedge clk );
        default input #0 output #0;
        input ce, cin, mode, inp_valid, opa, opb,cmd;
        output res, cout, oflow, err, g, l, e;
    endclocking

    modport driver_modport( clocking driver_cb, input rst );
    modport monitor_modport( clocking monitor_cb );
    modport reference_modport( clocking reference_cb, input rst );

endinterface
