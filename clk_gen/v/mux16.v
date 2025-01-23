
module mux16 
    ( input logic [15:0] data_i
    , input logic [3:0] select_i
    , output logic output_o
    );

    // main meaning data going into main final mux
    logic [3:0] inter, inter_inv;
    logic main_mux_o;

    // last layer of muxes
    sky130_fd_sc_hd__mux4_1
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
    sky130_fd_sc_hd__mux4_1
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

    sky130_fd_sc_hd__mux4_1
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

    sky130_fd_sc_hd__mux4_1
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

    sky130_fd_sc_hd__mux4_1
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
