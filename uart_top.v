

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/02 19:55:11
// Design Name: 
// Module Name: uart_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_top(
    input clk,
    input reset_poweron,
    input btn_P16,
    
    inout [7:0] key_io,     //�������� keypad�� �־��ִ� �Է� ��ȣ
    
    output [7:0] seg_data,  //7segmant �Ѱ��� ���� 8��Ʈ¥�� ������
    output [5:0] seg_com,   //7segmant ������ 
    

    // tx
    input uart_tx_en,
    input [7:0] uart_tx_data,
    output uart_txd,


    // rx
//    input uart_rxd,
//    output [3:0] uart_rx_data
    output [3:0] test_c_state
);

wire  [7:0] uart_rx_data;   // 8bit
wire clk_60mhz, rst;
wire [4:0] key_tmp, key, key_pulse;
reg  [3:0] hex0,hex1,hex2,hex3,hex4,hex5;
wire rx_busy, dummy;
wire btn_rx_hex, btn_rx_hex_pulse;

// clk wizard instantiation (125MHz -> 60MHz )
clk_wiz_0 clk_inst_0 (clk_60mhz, reset_poweron, locked, clk);
//Reset the system after the (power off)&&(PLL locked)
assign rst = reset_poweron | (~locked);
 
// KeyPad��ư ������ ���� �Է� ��ȣ : key_io[7:0] , Output : key_tmp (��ٿ�� ����)
//    - output reg [3:0] col;           //Ű�е� �ϳ��� ǥ�� ������
//    - output reg [4:0] keypad_out;    //{Ű�е� ���� �ּ�, ���� ����}
keypad #(.CLK_KHZ(60000)) keypad_inst (
    clk_60mhz, rst,
    key_io[7:4],    //�Է�, Ű�е� ���� �ּ� row
    key_io[3:0],    //���, Ű�е� ������ �ּ� column
    key_tmp         //���, = {4bit Ű�е� ������ ���� , 1bit���� ����}    ==> ��ٿ�� ��.
);

// ��ٿ
debounce #(.SIZE(16), .BTN_WIDTH(5)) debounce_inst (
    clk_60mhz, rst,
    key_tmp, key, key_pulse
);
debounce #(.SIZE(16), .BTN_WIDTH(1)) debounce_inst_hex (
    clk_60mhz, rst,
    btn_P16, btn_rx_hex, btn_rx_hex_pulse
);

// Ű�е� �Է� ó�� �� UART ����
reg [7:0] uart_tx_data_reg;
reg uart_tx_en_reg;

//uart TX ��Ʈ��///////////////////////////////////////////////////////////////////////////
always @(posedge clk_60mhz or posedge rst) begin    
    if (rst) begin                  
        uart_tx_en_reg <= 1'b0;
    end else if (key_pulse[4]) begin    
        uart_tx_en_reg <= 1'b1;
    end else if (uart_tx_en_reg && !tx_busy) begin  
        uart_tx_en_reg <= 1'b0;         
    end
end

//Ű�е� 8bit �Է� ��ȣ generator -> TX �Է�  /////////////////////////////////////////////
wire [7:0] key_ascii;
enc_tx u_enc_tx (.enc_in(key[3:0]), .enc_out(key_ascii));

always @(posedge clk_60mhz or posedge rst) begin
    if (rst) begin
        uart_tx_data_reg <= 8'd0;
    end 
    else if (key_pulse[4]) begin
        uart_tx_data_reg <= key_ascii;
        end
end
//////////////////////////////////////////////////////////////////////////////////////////
// UART �ۼ���
wire [7:0] uart_rx_data_8b;

//wire rx_busy, dummy;

uart_tx utx (clk_60mhz, rst, uart_tx_en_reg, uart_tx_data_reg, tx_busy,  uart_txd);
//below: assign  uart_txd = uart_rxd;        //TX -> RX link
uart_rx urx (clk_60mhz, rst, uart_txd, rx_busy, uart_rx_data_8b);

assign uart_rx_data = uart_rx_data_8b[3:0];
//assign uart_rx_data = uart_rx_data_8b;

//////////////////////////////////////////////////////////////////////////////////////////
//�����ȣ ���ڵ�
wire is_digit,is_char,rx_valid;
key_dec(.clk(clk_60mhz), .rst(rst), .rx_data(uart_rx_data_8b), .rx_busy(rx_busy), .is_digit(is_digit), .is_char(is_char), .rx_valid(rx_valid));   //output : is_digit,is_char,rx_valid

/////////������///////////////////////////////////////////////////////////////////
//������ hex shifter
//wire [23:0] test_c_state;
wire [3:0] test_n_state;
wire clk_baud;
wire  [23:0] hex_before, hex_current;    // from hex_shifter

//assign  hex_current = {hex5,hex4,hex3,hex2,hex1,hex0};
//assign  hex_current = {hex5,hex4,hex3,hex2,hex1,hex0};

hex_shifter u_hex_shifter (
        .clk_60mhz(clk_60mhz),
        .rst(rst),
        .char_check(is_char),    //
        .uart_rx_data(uart_rx_data), // 4��Ʈ�� ���x
        .rx_valid(rx_valid),
        .hex_before(hex_before),
        .hex_current(hex_current),
        .test_c_state(test_c_state),
        .test_n_state(test_n_state)
    );
/////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////7-seg output node/////////////////////////////////////////////


led led_inst (
    clk_60mhz, rst,
    hex_current[3:0], hex_current[7:4], hex_current[11:8], hex_current[15:12], hex_current[19:16], hex_current[23:20],     //7seg 6��
    seg_data, seg_com
);

///////////////////////////////////probe/////////////////////////////////////////

ila_0 ila_0_inst_1(.clk(clk_60mhz), .probe0(is_digit), .probe1(is_char), 
.probe2(rx_busy), 
.probe3(key), 
.probe4(key_io), 
.probe5(seg_com), .probe6(seg_data), 
.probe7(rx_valid), .probe8(uart_txd), 
.probe9(uart_rx_data),
.probe10(hex_current[7:0]),.probe11(hex_before[7:0]),.probe12(test_c_state),.probe13(hex_current[15:8]),.probe14(hex_before[15:8])
);
/////////////////////////////////////////////////////////////////////////////////

endmodule




