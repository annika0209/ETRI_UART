//////////////////////////////////////////////////////////////////////////////////


module hex_shifter(
    input clk_60mhz, rst, 
    input char_check,    
    input [3:0] uart_rx_data,
    
    input rx_valid,
    output reg [23:0] hex_before,
    output reg [23:0] hex_current,
    // �׽�Ʈ�� ��Ʈ �߰�
    output [3:0] test_c_state,
    output [3:0] test_n_state
    );
    
//////////////////////////////////////////////////////////////////////////////////

parameter IDLE =    0;
parameter WRITE0 =  1;
parameter WRITE1 =  2;
parameter WRITE2 =  3;
parameter WRITE3 =  4;
parameter WRITE4 =  5;
parameter WRITE5 =  6;
parameter WAIT =    7;
//parameter SEND =    8;


//////////////////////////////////////////////////////////////////////////////////

reg [3:0] c_state, n_state;
//wire clk;
//clk_divider #(.DIVISOR(520)) clk_baudrate (.clk_in(clk_60mhz), .rst(rst), .clk_out(clk)); 
assign test_c_state = c_state; // ���� ���� ���
assign test_n_state = n_state; // ���� ���� ���
//////////////////////////////////////next_state logic/////////////////////////

 wire char_check;

//////////////////////////////////////next_state logic/////////////////////////

always @(*) begin
    case(c_state)
    IDLE:    n_state = char_check ? IDLE : (rx_valid ? WRITE0 : IDLE)   ;  
    WRITE0:  n_state = char_check ? WAIT : (rx_valid ? WRITE1 : WRITE0)  ;   
    WRITE1:  n_state = char_check ? WAIT : (rx_valid ? WRITE2 : WRITE1)  ;   
    WRITE2:  n_state = char_check ? WAIT : (rx_valid ? WRITE3 : WRITE2)  ;   
    WRITE3:  n_state = char_check ? WAIT : (rx_valid ? WRITE4 : WRITE3)  ;   
    WRITE4:  n_state = char_check ? WAIT : (rx_valid ? WRITE5 : WRITE4)  ;   
    WRITE5:  n_state = (char_check) ? WAIT : WRITE5;  
    WAIT:    n_state = rx_valid ? ( char_check ? WAIT : WRITE0) : WAIT ;                            
//    SEND:    n_state = rx_valid ? WRITE0 : SEND ; //SEND ->  //////RE
        
    endcase
end

////////////////////////////////////current_state logic////////////////////////

always @(posedge clk_60mhz or posedge rst) begin
    if (rst)    c_state <= IDLE;
    else        if(rx_valid) c_state <= n_state;
end

////////////////////////////////////output logic/////////////////////////

always @(posedge clk_60mhz or posedge rst) begin
    if (rst) begin
        hex_before  <= 24'd0;
        hex_current <= 24'd0;
    end else begin
         case (c_state)
            IDLE: begin
                if(rx_valid) hex_current <= 24'd0; 
            end
            WRITE0: begin
                if(rx_valid & ~char_check) hex_current[3:0]   = uart_rx_data;
            end
            WRITE1: begin
                if(rx_valid & ~char_check) hex_current[7:4]   = uart_rx_data;
            end
            WRITE2: begin
                if(rx_valid & ~char_check) hex_current[11:8]  = uart_rx_data;
            end
            WRITE3: begin
                if(rx_valid & ~char_check) hex_current[15:12] = uart_rx_data;
            end
            WRITE4: begin
                if(rx_valid & ~char_check) hex_current[19:16] = uart_rx_data;
            end
            WRITE5: begin
                if(rx_valid & ~char_check) hex_current[23:20] = uart_rx_data;
            end
            WAIT: begin
                if(rx_valid) begin
                hex_before  = hex_current; // SEND������ hex_before�� hex_current ����
                //                    hex_before <= hex_current;
//                hex_current[3:0]   <= uart_rx_data; // SEND���� rx_busy�� 0�̸� hex_current �ʱ�ȭ
                end
            end
//            SEND: begin
////                if(rx_valid) begin
////                hex_before <= hex_current; // SEND������ hex_before�� hex_current ����
//                //                    hex_before <= hex_current;
////                hex_current <= 24'd0; // SEND���� rx_busy�� 0�̸� hex_current �ʱ�ȭ
//                hex_current[3:0]   <= uart_rx_data;
////                end
//            end
            default: if(rx_valid) hex_current = 0; // �Է°��� �״�� hex_current�� ����
            
        endcase
    end
end

//////////////////////////////////////////////////////////////////////////////////
    
    
endmodule
