`ifndef COVER_AGE_SV
`define COVER_AGE_SV

`include "defines.svh"

module assertion(
    input  clk, 
    input  rst, 
    input  CE, 
    input  MODE, 
    input  CIN, 
    input  [`CMD_WIDTH-1:0] CMD,
    input  [1:0] INP_VALID, 
    input  [`WIDTH-1:0] OPA, OPB,
    input  [`WIDTH:0] RES,
    input  ERR,
    input  OFLOW, 
    input  COUT, 
    input  G, L, E
);

property alu_not_known;
    @(posedge clk) !($isunknown({rst,CE,MODE,CMD,INP_VALID,OPA,OPB,CIN}));
endproperty

property both_operands_required_arithmetic;
    @(posedge clk) disable iff(rst)
    (CE && MODE && ((CMD < 4 || CMD > 8) && (CMD < 11))) |-> (INP_VALID == 2'b11);
endproperty

property both_operands_required_logical;
    @(posedge clk) disable iff(rst)
    (CE && !MODE && ((CMD < 6 || CMD > 11) && (CMD < 14))) |-> (INP_VALID == 2'b11);
endproperty

property check_INP_VALID_for_01_arithmetic;
    @(posedge clk) disable iff(rst)
    (CE && MODE && ((CMD == 4) || (CMD == 5))) |-> (INP_VALID == 2'b01);
endproperty

property check_INP_VALID_for_10_arithmetic;
    @(posedge clk) disable iff(rst)
    (CE && MODE && ((CMD == 6) || (CMD == 7))) |-> (INP_VALID == 2'b10);
endproperty

property check_INP_VALID_for_01_logical;
    @(posedge clk) disable iff(rst)
    (CE && !MODE && ((CMD == 6) || (CMD == 8) || (CMD == 9))) |-> (INP_VALID == 2'b01);
endproperty

property check_INP_VALID_for_10_logical;
    @(posedge clk) disable iff(rst)
    (CE && !MODE && ((CMD == 7) || (CMD == 10) || (CMD == 11))) |-> (INP_VALID == 2'b10);
endproperty

property rol_ror_err_check;
    @(posedge clk) disable iff(rst)
    (CE && MODE == 0 && (CMD == 12 || CMD == 13)) |-> (OPB[7:4] == 0 || ERR == 1);
endproperty

property cmp_output_check;
    @(posedge clk) disable iff(rst)
    (CE && MODE && CMD == 8 && INP_VALID == 2'b11) |-> (
        (OPA > OPB && G == 1 && L == 0 && E == 0) ||
        (OPA < OPB && G == 0 && L == 1 && E == 0) ||
        (OPA == OPB && G == 0 && L == 0 && E == 1)
    );
endproperty

property oflow_set_only_arithmetic;
    @(posedge clk) disable iff(rst)
    (CE && MODE == 1 && (CMD inside {0,1,2,3})) |-> (OFLOW === 0 || OFLOW === 1);
endproperty

property oflow_set_only_logical;
    @(posedge clk) disable iff(rst)
    (CE && MODE == 0) |-> (OFLOW == 0 && COUT == 0);
endproperty

check_rst_assert: assert property(@(posedge clk) !rst)
    else $error("Reset is asserted at posedge clk");

clock_enable_assert: assert property(@(posedge clk) !CE |=> RES == $past(RES))
    else $error("Output changed on clock when clock enable is 0");

both_operands_required_arithmetic_assert: assert property(both_operands_required_arithmetic)
    else $error("Arithmetic operations requiring two operands are missing input valid 11");

both_operands_required_logical_assert: assert property(both_operands_required_logical)
    else $error("Logical operations requiring two operands are missing input valid 11");

check_INP_VALID_for_01_arithmetic_assert: assert property(check_INP_VALID_for_01_arithmetic)
    else $error("Arithmetic operations requiring operand A only are missing input valid");

check_INP_VALID_for_10_arithmetic_assert: assert property(check_INP_VALID_for_10_arithmetic)
    else $error("Arithmetic operations requiring operand B only are missing input valid");

check_INP_VALID_for_01_logical_assert: assert property(check_INP_VALID_for_01_logical)
    else $error("Logical operations requiring operand A only are missing input valid");

check_INP_VALID_for_10_logical_assert: assert property(check_INP_VALID_for_10_logical)
    else $error("Logical operations requiring operand B only are missing input valid");

oflow_set_only_logical_assert: assert property(oflow_set_only_logical)
    else $error("Overflow is high during logical operation");

rolror_OPB_upper_assert: assert property(rol_ror_err_check)
    else $error("ROL/ROR did not raise ERR");

oflow_set_only_arithmetic_assert: assert property(oflow_set_only_arithmetic)
    else $error("Overflow check failed for arithmetic");

cmp_out_assert: assert property(cmp_output_check)
    else $error("Comparator output incorrect for CMP");
endmodule   
`endif
