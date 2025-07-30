`include "defines.svh"
class reference_model;
    transaction ref_trans;
   mailbox #(transaction) mbx_rs;
   mailbox #(transaction) mbx_dr;
   virtual alu_intf.reference_modport vif;
   bit [`ROT_BITS-1:0] rot_val;
            reg  ce;
            reg mode;
            reg cin;
            reg [`CMD_WIDTH-1:0] cmd;
            reg [1:0] inp_valid;
            reg [`WIDTH-1:0] opa;
            reg [`WIDTH-1:0] opb;
            reg [`WIDTH:0] res;
            reg [2*`WIDTH-1:0] res_mul;
            reg g, l, e;
            reg oflow, cout, err;
            reg [3:0]count = 0;



//METHODS
  //Explicitly overriding the constructor to make mailbox connection from driver
  //to reference model, to make mailbox conAnection from reference model to scoreboard
  //and to connect the virtual interface from reference model to enviornment
  function new(mailbox #(transaction) mbx_dr,
               mailbox #(transaction) mbx_rs,
               virtual alu_intf.reference_modport vif);
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs;
    this.vif=vif;
  endfunction

  //Task which mimics the functionality of the RAM
  task start();
          repeat(4)@(vif.reference_cb);
    for(int i=0;i<`no_of_trans;i++)
     begin
     ref_trans = new();
     //getting the driver transaction from mailbox
       mbx_dr.get(ref_trans) ;
       repeat(1) @(vif.reference_cb)
       begin
         res = {`WIDTH{1'bz}};
        err = 1'bz;
        g = 1'bz;
        e = 1'bz;
         l = 1'bz;
        oflow = 1'bz;
        cout = 1'bz;
         if(vif.rst)begin
            res = {`WIDTH{1'bz}};
             err = 1'bz;
             g = 1'bz;
             e = 1'bz;
             l = 1'bz;
             oflow = 1'bz;
             cout = 1'bz;
                  $display("reference op opa=%d,opb=%d,cmd=%d,inp_valid=%d,res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d",opa,opb,cmd,inp_valid, res, err, oflow, cout, g, l, e,$time);
        end
         else if(((ref_trans.mode && (((ref_trans.cmd < 4) || (ref_trans.cmd > 7)) && (ref_trans.cmd < 11))) || (!ref_trans.mode && (((ref_trans.cmd < 6) || (ref_trans.cmd > 11)) && (ref_trans.cmd < 14)))) && (ref_trans.inp_valid != 2'b11)) begin
            if (count == 0)begin
                cmd = ref_trans.cmd;
                mode = ref_trans.mode;
                count = count+1;
            end
            else if(count == 16)begin
                err = 1;
                count = 0;
            end
            else begin
                count = count + 1;
            end
                 $display("reference op opa=%d,opb=%d,cmd=%d,inp_valid=%d,res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d",opa,opb    ,cmd,inp_valid, res, err, oflow, cout, g, l, e,$time);

         end
         else if(ref_trans.ce && !vif.rst)begin
             if(count > 0)begin
                 opa = ref_trans.opa;
                 opb = ref_trans.opb;
                 cin = ref_trans.cin;
                 inp_valid = ref_trans.inp_valid;
                 count = 0;
             end
             else begin
                 opa = ref_trans.opa;
                 opb = ref_trans.opb;
                 cin = ref_trans.cin;
                 mode = ref_trans.mode;
                 inp_valid = ref_trans.inp_valid;
                 cmd = ref_trans.cmd;
             end
           case ( inp_valid)
                2'b00: begin
                   err = 1'b1;
                   res = {`WIDTH{1'bz}};
                end
                2'b01: begin
                    if ( mode) begin
                        case ( cmd)
                            `INC_A: begin
                                     res =  opa + 1;
                                     cout =  res[`WIDTH];
                            end
                            `DEC_A: begin
                                     res =  opa - 1;
                                     cout =  res[`WIDTH];
                            end
                            default: begin
                                 err = 1'b1;
                                 res = {`WIDTH{1'bz}};
                            end
                        endcase
                    end else begin
                        case ( cmd)
                          `NOT_A: begin  res = {1'b0, ~ opa};end
                          `SHR1_A: begin  res = {1'b0,  opa >> 1};end
                          `SHL1_A: begin  res = {1'b0,  opa << 1};end
                            default: begin
                                 err = 1'b1;
                                 res = {`WIDTH{1'bz}};
                            end
                        endcase
                    end
                end
                2'b10: begin
                    if ( mode) begin
                        case ( cmd)
                            `INC_B: begin
                                 res =  opb + 1;
                                 cout =  res[`WIDTH];
                            end
                            `DEC_B: begin
                                 res =  opb - 1;
                                 cout =  res[`WIDTH];
                            end
                            default: begin
                                 err = 1'b1;
                                 res = {`WIDTH{1'bz}};
                            end
                        endcase
                    end else begin
                        case ( cmd)
                          `NOT_B: begin  res = {1'b0, ~ opb};end
                          `SHR1_B: begin  res = {1'b0,  opb >> 1};end
                          `SHL1_B: begin  res = {1'b0,  opb << 1};end
                            default: begin
                                 err = 1'b1;
                                 res = {`WIDTH{1'bz}};
                            end
                        endcase
                    end
                end
                2'b11: begin
                    if ( mode) begin
                        case ( cmd)
                            `ADD: begin
                                 res =  opa +  opb;
                                 cout =  res[`WIDTH];
                            end
                            `SUB: begin
                                 res =  opa -  opb;
                                 oflow =  res[`WIDTH];
                            end
                            `ADD_CIN: begin
                                 res =  opa +  opb +  cin;
                                 cout =  res[`WIDTH];
                            end
                            `SUB_CIN: begin
                                 res =  opa -  opb -  cin;
                                 oflow =  res[`WIDTH];
                            end
                            `INC_A: begin
                                 res =  opa + 1;
                                 cout =  res[`WIDTH];
                            end
                            `DEC_A: begin
                                 res =  opa - 1;
                                 //oflow =  res[`WIDTH];
                            end
                            `INC_B: begin
                                 res =  opb + 1;
                                 cout =  res[`WIDTH];
                            end
                            `DEC_B: begin
                                 res =  opb - 1;
                                 oflow =  res[`WIDTH];
                            end
                            `CMP: begin
                                    if(opa <  opb) l = 1;
                                 else if(opa ==  opb) e = 1;
                                    else g = 1;
                            end
                            `INC_MUL: begin

                                     res = ( opa + 1) * ( opb + 1);
                        //          repeat(2) @(vif.reference_cb);
                                end

                            `SHL1_A_MUL_B: begin

                                     res = ( opa << 1) * ( opb);
                                end
                            default: begin
                                 err = 1;
                                    res = {`WIDTH{1'bz}};
                            end
                        endcase
                    end else begin
                        case ( cmd)
                          `AND: begin  res = {1'b0,  opa &  opb};end
                          `NAND: begin  res ={1'b0, ~( opa &  opb)};end
                          `OR: begin  res = {1'b0,  opa |  opb};end
                          `NOR: begin  res = {1'b0, ~( opa |  opb)};end
                          `XOR: begin  res = {1'b0,  opa ^  opb};end
                          `XNOR: begin  res = {1'b0, ~( opa ^  opb)};end
                          `NOT_A: begin  res = {1'b0, ~ opa};end
                          `NOT_B: begin  res = {1'b0, ~ opb};end
                          `SHR1_A: begin  res = {1'b0,  opa >> 1};end
                          `SHL1_A: begin  res = {1'b0,  opa << 1};end
                          `SHR1_B: begin  res = {1'b0,  opb >> 1};end
                          `SHL1_B: begin  res = {1'b0,  opb << 1};end
                            `ROL_A_B: begin

                             rot_val =  opb[`ROT_BITS-1:0];
                                 res = {( opa << rot_val) | ( opa >> (`WIDTH - rot_val))};
                                 if( opb[7] || opb[6] || opb[5] || opb[4])
                                         err = 1;
                            end
                            4'b1101: begin

                              rot_val =  opb[`ROT_BITS-1:0];
                                 res = {( opa >> rot_val) | ( opa << (`WIDTH - rot_val))};
                                 if(opb[7] || opb[6] || opb[5] || opb[4])
                                         err = 1;
                            end
                            default: begin
                                    res = {`WIDTH{1'bz}};
                                 err = 1'b1;
                            end
                        endcase
                    end
                end
                default: begin

                        res = {`WIDTH{1'bz}};
                     err = 1'b1;
                end
            endcase
             ref_trans.res = res;
             ref_trans.err = err;
             ref_trans.g = g;
             ref_trans.e = e;
             ref_trans.l = l;
             ref_trans.oflow = oflow;
             ref_trans.cout = cout;
 $display("reference op opa=%d,opb=%d,cmd=%d,inp_valid=%d,res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d",opa,opb,cmd,inp_valid, res, err, oflow, cout, g, l, e,$time);

        end
        else begin
             ref_trans.res =  res;
                ref_trans.err = {`WIDTH{1'bz}};
                ref_trans.g = {`WIDTH{1'bz}};
                ref_trans.e = {`WIDTH{1'bz}};
                ref_trans.l = {`WIDTH{1'bz}};
                ref_trans.oflow = {`WIDTH{1'bz}};
                ref_trans.cout = {`WIDTH{1'bz}};
        end
          end
             mbx_rs.put( ref_trans);
             repeat(1)@(vif.reference_cb);
     end
  endtask
endclass
