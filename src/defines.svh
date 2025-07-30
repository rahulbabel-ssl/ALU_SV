`define no_of_trans 1000
`define WIDTH 8
`define CMD_WIDTH 4
`define ROT_BITS ($clog2(`WIDTH))
`define MAX ((1<<`WIDTH)-1)
// Arithmetic Operation Defines
`define ADD        4'd0   // arithmetic operation
`define SUB        4'd1
`define ADD_CIN    4'd2
`define SUB_CIN    4'd3
`define INC_A      4'd4
`define DEC_A      4'd5
`define INC_B      4'd6
`define DEC_B      4'd7
`define CMP        4'd8
`define INC_MUL    4'd9
`define SHL1_A_MUL_B  4'd10


// Logical Operation Defines
`define AND        4'd0   // logical operation
`define NAND       4'd1
`define OR         4'd2
`define NOR        4'd3
`define XOR        4'd4
`define XNOR       4'd5
`define NOT_A      4'd6
`define NOT_B      4'd7
`define SHR1_A     4'd8
`define SHL1_A     4'd9
`define SHR1_B     4'd10
`define SHL1_B     4'd11
`define ROL_A_B    4'd12
`define ROR_A_B    4'd13
