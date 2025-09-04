module uart_tx(
    input clk,
    input rst,	
    input uart_tx_en,	//start 버튼, debouncer사용
    input [7:0] uart_tx_data,
    input tx_busy,
    output reg uart_txd 	//송신 데이터
);
 
    debounce debounce_inst (clk, rst, uart_tx_en, , uart_start_pulse); //for kit
    
    //
    reg [3:0] n_state, c_state;
    parameter ST_IDLE=0, ST_START=1, ST_D0=2, ST_D1=3, ST_D2=4, ST_D3=5, ST_D4=6, ST_D5=7, ST_D6=8, ST_D7=9, ST_STOP=10;
    
    wire trig;
    //assign uart_tx_en=btn_start_pulse;
    reg [10:0] count;
    //TX의 trig신호 (trigger 신호 한 주기마다 data 1bit씩 송신)
    always @(posedge clk, posedge rst) begin
        if(rst) count <= 0;
        else if (c_state != ST_IDLE) begin
            if(count==520) count<=0;
            else count <= count+1;
        end
    end
    
    assign trig = (count==520)? 1: 0;
    
    //Next State
     always @* begin
        case(c_state)
            ST_IDLE:if(uart_tx_en) n_state = ST_START;
                 else n_state = ST_IDLE;
            ST_START: if(trig) n_state = ST_D0;
                 else n_state = ST_START;
            ST_D0: if(trig) n_state = ST_D1;
                 else n_state = ST_D0;
            ST_D1: if(trig) n_state = ST_D2;
                 else n_state = ST_D1;
            ST_D2: if(trig) n_state = ST_D3;
                 else n_state = ST_D2;
            ST_D3: if(trig) n_state = ST_D4;
                 else n_state = ST_D3;
            ST_D4: if(trig) n_state = ST_D5;
                 else n_state = ST_D4;
            ST_D5: if(trig) n_state = ST_D6;
                 else n_state = ST_D5;
            ST_D6: if(trig) n_state = ST_D7;
                 else n_state = ST_D6;
            ST_D7: if(trig) n_state = ST_STOP;
                 else n_state = ST_D7;
            ST_STOP: if(trig) n_state = ST_IDLE;
                 else n_state = ST_STOP;
            default: n_state = ST_IDLE;
        endcase
     end
     
     //Current State
     always @(posedge clk, posedge rst) begin
        if(rst) c_state <= ST_IDLE;
        else c_state <= n_state;
     end

    //Output Logic 
     always @(posedge clk or posedge rst) begin
        if (rst) begin
            uart_txd <= 1'b1;
        end else begin
            case (c_state)
                ST_IDLE:   if (trig) uart_txd <= 1'b1;
                ST_START:  if (trig) uart_txd <= 1'b0;
                ST_D0:     if (trig) uart_txd <= uart_tx_data[0];
                ST_D1:     if (trig) uart_txd <= uart_tx_data[1];
                ST_D2:     if (trig) uart_txd <= uart_tx_data[2];
                ST_D3:     if (trig) uart_txd <= uart_tx_data[3];
                ST_D4:     if (trig) uart_txd <= uart_tx_data[4];
                ST_D5:     if (trig) uart_txd <= uart_tx_data[5];
                ST_D6:     if (trig) uart_txd <= uart_tx_data[6];
                ST_D7:     if (trig) uart_txd <= uart_tx_data[7];
                ST_STOP:   if (trig) uart_txd <= 1'b1;
            endcase
        end
    end
    
    //ila_0 ila_0_inst(clk, uart_start_pulse, c_state, n_state, count, trig, uart_txd);

endmodule