`include "alu_interface.sv"
`include "alu.v"
`include "alu_pkg.sv"
module top( );
  import alu_package::*;
  bit clk;
  bit rst;

  initial
    begin
     forever #10 clk=~clk;
  end

  initial
    begin
      @(posedge clk);
      rst = 1;
      repeat(1) @(posedge clk);
      rst = 0;
  end

  alu_intf intf_alu(clk,rst);

  ALU_DESIGN DUT(.OPA(intf_alu.opa),
            .OPB(intf_alu.opb),
            .CMD(intf_alu.cmd),
            .CE(intf_alu.ce),
            .CIN(intf_alu.cin),
            .INP_VALID(intf_alu.inp_valid),
            .MODE(intf_alu.mode),
            .G(intf_alu.g),
            .L(intf_alu.l),
            .E(intf_alu.e),
            .ERR(intf_alu.err),
            .COUT(intf_alu.cout),
            .OFLOW(intf_alu.oflow),
            .RES(intf_alu.res),
            .CLK(clk),
            .RST(rst)
           );
	assertion dut_assertion(clk,rst,intf_alu.ce,intf_alu.mode,intf_alu.cmd,intf_alu.inp_valid,intf_alu.opa,intf_alu.opb,intf_alu.cin,intf_alu.res);
	   test tb;  
  initial
   begin
 tb = new(intf_alu ,intf_alu ,intf_alu);

    tb.run();
    $finish;
  end
endmodule
