// 
//  Clk Gen Module -- Students should implement their tunable clock generator
//  circuit here! The input and output port list has been created for you. Do
//  not modify the port list, this will break the rest of the lab :)
// 
//  First, you must figure out what logic gates are available to us in the
//  standard cell library. The best place to figure this out is the liberty
//  file which can be found at:
//
//      <SKY130_ROOT>/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib
//
//  Open this file above to see the gates available in this cell library. This
//  will be helpful to figure out the names of the gates as well as the name of
//  the pins for the gates. Using this information you can instantiate the
//  cells you need for the circuit.
//
//  NOTE: This file is 100K lines, be sure to use the search function of your
//  text editor. Search for "cell " to find the each gate available in this
//  cell library. Under each cell definition, search for "pin " to find the
//  pins of the gate (you can ignore pg_pins, we do not need to work with
//  supply nets within this verilog file). Inside the pin definition will be
//  the "direction " to determine if it is an input or output of the gate.
//  Output pins will also have a "function " which is the boolean logic
//  expression for the gate. Timing information for each pin can also be found
//  within the pin definitions, please read the module - handout for more
//  information.
//
module clk_gen
    ( input  wire       reset_i
    , input  wire [3:0] select_i
    , output wire       clk_o
    );

    // TODO: Implement the clock generator below! Make sure that:
    //  1. The ring ends at the B pin of the reset NOR gate below.
    //  2. The ring begins with the X pin of the reset_bal NOR gate below.
    //  3. Use the 4-bit select_i to choose between your 16 clock speeds.
    //  4. The final clock should drive the clk_o port.

    wire reset_to_reset_bal_n;

    logic [14:0] buff;
    logic [15:0] mux_i;
    logic ring_start, inv;

    assign mux_i = { buff, inv };

    mux16
    clk_sel
        (.data_i(mux_i)
        ,.select_i(select_i)
        ,.output_o(clk_o)
        );

    sky130_fd_sc_hd__nor2_1
    reset
        (.A(reset_i)
        ,.B(clk_o)
        ,.Y(reset_to_reset_bal_n)
        );

    sky130_fd_sc_hd__nor2_1
    reset_bal
        (.A(reset_i)
        ,.B(reset_to_reset_bal_n)
        ,.Y(ring_start)
        );

    // inverter (2 in mux)
    sky130_fd_sc_hd__clkinv_1
    ring_inv
        (.Y(inv)
        ,.A(ring_start)
        );

    sky130_fd_sc_hd__clkbuf_2
    buff0
    (.X(buff[0])
    ,.A(inv)
    );

    sky130_fd_sc_hd__clkbuf_2
    buff1
    (.X(buff[1])
    ,.A(buff[0])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff2
    (.X(buff[2])
    ,.A(buff[1])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff3
    (.X(buff[3])
    ,.A(buff[2])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff4
    (.X(buff[4])
    ,.A(buff[3])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff5
    (.X(buff[5])
    ,.A(buff[4])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff6
    (.X(buff[6])
    ,.A(buff[5])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff7
    (.X(buff[7])
    ,.A(buff[6])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff8
    (.X(buff[8])
    ,.A(buff[7])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff9
    (.X(buff[9])
    ,.A(buff[8])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff10
    (.X(buff[10])
    ,.A(buff[9])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff11
    (.X(buff[11])
    ,.A(buff[10])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff12
    (.X(buff[12])
    ,.A(buff[11])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff13
    (.X(buff[13])
    ,.A(buff[12])
    );


    sky130_fd_sc_hd__clkbuf_2
    buff14
    (.X(buff[14])
    ,.A(buff[13])
    );

endmodule

module mux16 
    ( input logic [15:0] data_i
    , input logic [3:0] select_i
    , output logic output_o
    );

    // main meaning data going into main final mux
    logic [3:0] inter, inter_inv;
    logic main_mux_o;

    // last layer of muxes
    sky130_fd_sc_hd__mux4_2
    main_mux
        (.X(main_mux_o)
        ,.A0(inter_inv[0])
        ,.A1(inter_inv[1])
        ,.A2(inter_inv[2])
        ,.A3(inter_inv[3])
        ,.S0(select_i[2])
        ,.S1(select_i[3])
        );

    sky130_fd_sc_hd__clkinv_1
    main_inv
        (.Y(output_o)
        ,.A(main_mux_o)
        );

    // first layer of muxes
    sky130_fd_sc_hd__mux4_2
    inter_mux0
        (.X(inter[0])
        ,.A0(data_i[0])
        ,.A1(data_i[1])
        ,.A2(data_i[2])
        ,.A3(data_i[3])
        ,.S0(select_i[0])
        ,.S1(select_i[1])
        );
    
    sky130_fd_sc_hd__clkinv_1
    inter_inv0
        (.Y(inter_inv[0])
        ,.A(inter[0])
        );

    sky130_fd_sc_hd__mux4_2
    inter_mux1
        (.X(inter[1])
        ,.A0(data_i[4])
        ,.A1(data_i[5])
        ,.A2(data_i[6])
        ,.A3(data_i[7])
        ,.S0(select_i[0])
        ,.S1(select_i[1])
        );

    sky130_fd_sc_hd__clkinv_1
    inter_inv1
        (.Y(inter_inv[1])
        ,.A(inter[1])
        );

    sky130_fd_sc_hd__mux4_2
    inter_mux2
        (.X(inter[2])
        ,.A0(data_i[8])
        ,.A1(data_i[9])
        ,.A2(data_i[10])
        ,.A3(data_i[11])
        ,.S0(select_i[0])
        ,.S1(select_i[1])
        );

    sky130_fd_sc_hd__clkinv_1
    inter_inv2
        (.Y(inter_inv[2])
        ,.A(inter[2])
        );

    sky130_fd_sc_hd__mux4_2
    inter_mux3
        (.X(inter[3])
        ,.A0(data_i[12])
        ,.A1(data_i[13])
        ,.A2(data_i[14])
        ,.A3(data_i[15])
        ,.S0(select_i[0])
        ,.S1(select_i[1])
        );

    sky130_fd_sc_hd__clkinv_1
    inter_inv3
        (.Y(inter_inv[3])
        ,.A(inter[3])
        );

endmodule
