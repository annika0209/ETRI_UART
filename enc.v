module enc_tx(
    input [3:0] enc_in, 
    output [8:0] enc_out 
    );
    
reg [8:0] enc_out; 
always @ (enc_in) begin
        case (enc_in)
            4'b0000: enc_out = 8'h30; //0
            4'b0001: enc_out = 8'h31; //1
            4'b0010: enc_out = 8'h32; //2
            4'b0011: enc_out = 8'h33; //3
            4'b0100: enc_out = 8'h34; //4
            4'b0101: enc_out = 8'h35; //5
            4'b0110: enc_out = 8'h36; //6
            4'b0111: enc_out = 8'h37; //7
            4'b1000: enc_out = 8'h38; //8
            4'b1001: enc_out = 8'h39; //9
            4'b1010: enc_out = 8'h61; //A
            4'b1011: enc_out = 8'h62; //B
            4'b1100: enc_out = 8'h63; //C
			4'b1101: enc_out = 8'h64; //D
            4'b1110: enc_out = 8'h65; //E         
            4'b1111: enc_out = 8'h66; //F
            default: enc_out = 8'h40; 
        endcase
end
endmodule
