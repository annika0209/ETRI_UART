

module uart_rx(
    input clk,
    input rst,
    input in_rxd,   // from TX
    output rx_busy, // IDLE ?�닐 ??'1'
    output reg [7:0] out_rxd // ?�신 ?�이??
);

    // ?�태 ?�의 (uart_rx?? ?�일?�게)
    parameter IDLE = 0, START = 1,
              RX_0 = 2, RX_1 = 3, RX_2 = 4, RX_3 = 5,
              RX_4 = 6, RX_5 = 7, RX_6 = 8, RX_7 = 9, STOP = 10;

    reg [3:0] current_rx, next_rx;
    reg [7:0] buffer;
    reg [10:0] count; // baud 카운??

    // ?�태???�라 rx_busy 출력
    assign rx_busy = (current_rx != IDLE);

    // BAUD RATE �????�라미터 (?�플�????�밍 조정)
    parameter SIZE = 520; // 1비트 주기 (?�럭 주파?�에 맞게 조정)
    wire trig = (count == SIZE-1);
    wire trig2 = (count == (SIZE>>1)); // 1/2 baud �??? SAMPLING RATE

    // 카운?? ?�신 중에�??�작
    always @(posedge clk or posedge rst) begin
        if (rst) count <= 0;
        else if (current_rx != IDLE) begin
            if (count == SIZE-1) count <= 0;
            else count <= count + 1;
        end else begin
            count <= 0;
        end
    end

    // FSM: next state 결정
    always @(*) begin
        case (current_rx)
            IDLE   : next_rx = (in_rxd == 0) ? START : IDLE;
            START  : next_rx = (trig) ? RX_0 : START;
            RX_0   : next_rx = (trig) ? RX_1 : RX_0;
            RX_1   : next_rx = (trig) ? RX_2 : RX_1;
            RX_2   : next_rx = (trig) ? RX_3 : RX_2;
            RX_3   : next_rx = (trig) ? RX_4 : RX_3;
            RX_4   : next_rx = (trig) ? RX_5 : RX_4;
            RX_5   : next_rx = (trig) ? RX_6 : RX_5;
            RX_6   : next_rx = (trig) ? RX_7 : RX_6;
            RX_7   : next_rx = (trig) ? STOP : RX_7;
            STOP   : next_rx = (trig) ? IDLE : STOP;
            default: next_rx = IDLE;
        endcase
    end

    // current state 갱신
    always @(posedge clk or posedge rst) begin
        if (rst) current_rx <= IDLE;
        else current_rx <= next_rx;
    end

    // ?�이???�플�? �??�이??비트??중앙(trig2)?�서 in_rxd ?�플�?
    always @(posedge clk or posedge rst) begin
        if (rst) out_rxd <= 8'b0;
        else if (trig2) begin
            case (current_rx)
                IDLE: out_rxd <= 8'b11111111;
                START: out_rxd <= 8'b00000000;
                RX_0: out_rxd[0] <= in_rxd;
                RX_1: out_rxd[1] <= in_rxd;
                RX_2: out_rxd[2] <= in_rxd;
                RX_3: out_rxd[3] <= in_rxd;
                RX_4: out_rxd[4] <= in_rxd;
                RX_5: out_rxd[5] <= in_rxd;
                RX_6: out_rxd[6] <= in_rxd;
                RX_7: out_rxd[7] <= in_rxd;
//                STOP: out_rxd <= 8'b11111111;
                default: ;
            endcase
        end
    end

    // out_rxd 출력: STOP ?�태?�서 buffer 값을 out_rxd??????
//    always @(posedge clk or posedge rst) begin
//        if (rst) out_rxd <= 8'b0;
//        else if (current_rx == STOP && trig2) out_rxd <= buffer;
//        else if (current_rx == IDLE && trig2) out_rxd <= 8'b1;
//    end


endmodule


//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/02 17:22:20
// Design Name: 
// Module Name: uart_rx
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


//module uart_rx(
//    input clk, 
//    input rst, 
//    input uart_rxd, // ���ŵ�����
//    output rx_busy, //IDLE ���°� �ƴ� �� '1'
//    output reg [7:0] uart_rx_data // ������ 8��Ʈ ������
//);
//    assign rx_busy = (c_state !=ST_IDLE);
    
//    //STEP1
//    reg [3:0] n_state, c_state;
//    parameter ST_IDLE=0, ST_START=1, ST_D0=2, ST_D1=3, ST_D2=4, ST_D3=5, ST_D4=6, ST_D5=7, ST_D6=8, ST_D7=9, ST_STOP=10;
    
//    wire trig, trig2;
//    //assign uart_tx_en=btn_start_pulse;
//    reg [10:0] count;
//    //trig��ȣ ����� �ڵ�
//    always @(posedge clk, posedge rst) begin
//        if(rst) count <= 0;
//        else if (c_state != ST_IDLE) begin
//            if(count==520) count<=0; 
//            else count <= count+1;
//        end
//    end
    
//    assign trig = (count==520)? 1: 0;
//    assign trig2 = (count==260)? 1: 0;
    
//    //STEP2 : FSM
//     always @(*) begin
//        case (c_state)
//            ST_IDLE:  n_state = (uart_rxd == 0) ? ST_START : ST_IDLE;
//            ST_START: n_state = (trig) ? ST_D0 : ST_START;
//            ST_D0:    n_state = (trig) ? ST_D1 : ST_D0;
//            ST_D1:    n_state = (trig) ? ST_D2 : ST_D1;
//            ST_D2:    n_state = (trig) ? ST_D3 : ST_D2;
//            ST_D3:    n_state = (trig) ? ST_D4 : ST_D3;
//            ST_D4:    n_state = (trig) ? ST_D5 : ST_D4;
//            ST_D5:    n_state = (trig) ? ST_D6 : ST_D5;
//            ST_D6:    n_state = (trig) ? ST_D7 : ST_D6;
//            ST_D7:    n_state = (trig) ? ST_STOP : ST_D7;
//            ST_STOP:  n_state = (trig) ? ST_IDLE : ST_STOP;
//            default:  n_state = ST_IDLE;
//        endcase
//    end
     
//     //STEP3: c_state ����
//     always @(posedge clk, posedge rst) begin
//        if(rst) c_state <= ST_IDLE;
//        else c_state <= n_state;
//     end
    
    
//    //STEP4: ���� ������ ����
//     always @(posedge clk or posedge rst)  begin
//        if (rst) uart_rx_data <= 8'b0;
//        else if (trig2) begin
//            case (c_state)
//                ST_IDLE: uart_rx_data <= 1;
//                ST_START: uart_rx_data <= 0;
//                ST_D0: uart_rx_data[0] <= uart_rxd;
//                ST_D1: uart_rx_data[1] <= uart_rxd;
//                ST_D2: uart_rx_data[2] <= uart_rxd;
//                ST_D3: uart_rx_data[3] <= uart_rxd;
//                ST_D4: uart_rx_data[4] <= uart_rxd;
//                ST_D5: uart_rx_data[5] <= uart_rxd;
//                ST_D6: uart_rx_data[6] <= uart_rxd;
//                ST_D7: uart_rx_data[7] <= uart_rxd;
//                ST_STOP: uart_rx_data <= 1;
//            endcase
//        end
//     end
//endmodule

