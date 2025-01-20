//  FO4 Module -- Students should implement the FO4 circuit that they see in
//  the Module 0 handout. Note that we already have a 2-input OR gate
//  instantiated in this design. This both serves as an example of how a gate
//  is instantiated as well as implements a reset which allows us to put the
//  ring oscillator into a known state for digital simulations.
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
//  expression for the gate.
//

module fo4
    ( input  wire reset_i       // reset input
    , output wire probe_in_o    // first output probe
    , output wire probe_out_o   // second output probe
    );

    // TODO: Implement the FO4 ring below! Make sure that:
    //    1. The ring ends at the B pin of the reset OR gate below.
    //    2. The ring begins with the X pin of the reset OR gate below.
    //    3. Connect the probe_in_o pin to the input of the inverter you want
    //       to measure the propgation delay through. (NOTE: you should choose
    //       an inverter several stages away from the reset gate, so the fo4
    //       will not be influenced by it.)
    //    4. Connect the probe_out_o pin to the output of the inverter you want
    //       to measure the propgation delay through.

    parameter inv_num = 3;

    logic or_i, or_o;
    logic [inv_num-1:0] ring_i, ring_o,
                dangle1_i, dangle1_o,
                dangle2_i, dangle2_o,
                dangle3_i, dangle2_o,
                load1_i, load1_o,
                load2_i, load2_o,
                load3_i, load3_o;

    assign ring_i[0] = or_o;
    assign or_i = ring_o[inv_num-1];

    // Reset Gate (DO NOT REMOVE OR RENAME)
    sky130_fd_sc_hd__or2_1
    reset
        (.A(reset_i)
        ,.B(or_i)
        ,.X(or_o)
        );

    

    genvar i; 
    generate;
        for (i = 1; i < inv_num; i++) begin : inverter
            assign ring_i[i] = ring_o[i-1];
        end
    endgenerate

    generate;
        for (i = 0; i < inv_num; i++) begin : fan_load
            assign ring_o[i] = dangle1_i[i];
            assign ring_o[i] = dangle2_i[i];
            assign ring_o[i] = dangle3_i[i];
            assign load1_i[i] = dangle1_o[i];
            assign load2_i[i] = dangle2_o[i];
            assign load3_i[i] = dangle3_o[i];

            sky130_fd_sc_hd__inv_1
            std_inv
                (.Y(ring_o[i])
                ,.A(ring_i[i])
                );

            sky130_fd_sc_hd__inv_1
            fan_inv1
                (.Y(dangle1_o[i])
                ,.A(dangle1_i[i])
                );

            sky130_fd_sc_hd__inv_1
            fan_inv2
                (.Y(dangle2_o[i])
                ,.A(dangle2_i[i])
                );

            sky130_fd_sc_hd__inv_1
            fan_inv3
                (.Y(dangle3_o[i])
                ,.A(dangle3_i[i])
                );

            sky130_fd_sc_hd__inv_4
            load_inv1
                (.Y(load1_o[i])
                ,.A(load1_i[i])
                );

            sky130_fd_sc_hd__inv_4
            load_inv2
                (.Y(load2_o[i])
                ,.A(load2_i[i])
                );

            sky130_fd_sc_hd__inv_4
            load_inv3
                (.Y(load3_o[i])
                ,.A(load3_i[i])
                );
        end
    endgenerate 

endmodule

