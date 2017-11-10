module decoder1_32 (regWrite, writeRegister, we);
    input logic regWrite;
    input logic [4:0] writeRegister;
    output logic [31:0] we; //careful about 31

    logic wire1, wire2;
    decoder1_16 d1 (wire1, writeRegister[3:0], we[31:16]);
    decoder1_16 d1 (wire2, writeRegister[3:0], we[15:0]);
    decoder1_2 d (regWrite, wire1, wire2, writeRegister[4]);
endmodule