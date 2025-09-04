module led(
    input clk, //60MHz
    input rst,
    input [3:0] hex0, hex1, hex2, hex3, hex4, hex5,  
    output reg [7:0] seg_data, 
    output reg [5:0] seg_com
    );
    
    wire seg_com_en; 
    wire [6:0] hex0_out, hex1_out, hex2_out, hex3_out, hex4_out, hex5_out;
    
    ///////////////////////////////////////////////////////////////////////    
    //for shift register of seg_com with 600Hz Speed //////////////////////
    gen_counter_en #(.SIZE(100000)) seg_com_en_inst (clk, rst, seg_com_en);
    
    always @(posedge clk or posedge rst)
    begin
        if(rst) seg_com <= 6'b100000; 
        else if (seg_com_en) seg_com <= {seg_com[0], seg_com[5:1]}; 
    end
    ///////////////////////////////////////////////////////////////////////

    dec7 dec_hex0_inst (hex0, hex0_out); 
    dec7 dec_hex1_inst (hex1, hex1_out); 
    dec7 dec_hex2_inst (hex2, hex2_out); 
    dec7 dec_hex3_inst (hex3, hex3_out); 
    dec7 dec_hex4_inst (hex4, hex4_out); 
    dec7 dec_hex5_inst (hex5, hex5_out);
    
    always @* begin
        case (seg_com)
            6'b000001: seg_data = {hex0_out, 1'b0};
            6'b000010: seg_data = {hex1_out, 1'b0};
            6'b000100: seg_data = {hex2_out, 1'b0};
            6'b001000: seg_data = {hex3_out, 1'b0};
            6'b010000: seg_data = {hex4_out, 1'b0};
            6'b100000: seg_data = {hex5_out, 1'b0};
            default: seg_data = 8'b0; 
        endcase
    end
    
endmodule
