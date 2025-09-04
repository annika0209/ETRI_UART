module dec7(
    input [3:0] dec_in, //D(MSB),C,B,A(LSB)
    output [6:0] dec_out //a(MSB),¡¦,g(LSB)
    );
    
reg [6:0] dec_out; 
always @ (dec_in) begin
        case (dec_in)
            4'b0000: dec_out = 7'b1111110;
            4'b0001: dec_out = 7'b0110000;
            4'b0010: dec_out = 7'b1101101;
            4'b0011: dec_out = 7'b1111001;
            4'b0100: dec_out = 7'b0110011;
            4'b0101: dec_out = 7'b1011011;
            4'b0110: dec_out = 7'b1011111;
            4'b0111: dec_out = 7'b1110010;
            4'b1000: dec_out = 7'b1111111;
            4'b1001: dec_out = 7'b1111011;

            4'hB: dec_out = 7'b1110111; //A    
            4'hD: dec_out = 7'b0011111; //B
            4'hA: dec_out = 7'b1001110; //C
			4'hF: dec_out = 7'b0111101; //D
			
            4'hE: dec_out = 7'b1001111; //E            
            4'hC: dec_out = 7'b1100111; //F
//            4'b1010: dec_out = 5'b11010; //A
//            4'b1011: dec_out = 5'b11011; //B
//            4'b1100: dec_out = 5'b11100; //C
//			4'b1101: dec_out = 5'b11101; //D
//            4'b1110: dec_out = 5'b11110; //E            
//            4'b1111: dec_out = 5'b11111; //F
            
            default: dec_out = 7'b0000000; 
        endcase
end
endmodule
