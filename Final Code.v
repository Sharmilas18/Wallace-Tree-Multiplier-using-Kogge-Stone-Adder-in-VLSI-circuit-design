module half_adder(a,b,sum,carry);
input a,b;
output sum,carry;
assign sum=a^b;
assign carry=a&b;
endmodule
module full_adder(a,b,cin,sum,carry);

input a,b,cin;

output sum,carry;

reg T1,T2,T3,carry;

assign sum=a^b^cin;

always @(a or b or cin)

begin

T1=a&b;

T2=a&cin;

T3=a&cin;

carry=T1|T2|T3;

end

endmodule
module Wallace_KSA(A,B,prod);
    
    //inputs and outputs
    input [3:0] A,B;
    output [7:0] prod;
    //internal variables.
    wire s11,s12,s13,s14,s15,s22,s23,s24,s25,s26,s32,s33,s34,s35,s36,s37;
    wire c11,c12,c13,c14,c15,c22,c23,c24,c25,c26,c32,c33,c34,c35,c36,c37;
    wire [6:0] p0,p1,p2,p3;

//initialize the p's.
    assign  p0 = A & {4{B[0]}};
    assign  p1 = A & {4{B[1]}};
    assign  p2 = A & {4{B[2]}};
    assign  p3 = A & {4{B[3]}};

//final product assignments   
    assign prod[0] = p0[0];
    assign prod[1] = s11;
    assign prod[2] = s22;
    assign prod[3] = s32;
    assign prod[4] = s34;
    assign prod[5] = s35;
    assign prod[6] = s36;
    assign prod[7] = s37;
//first stage
    half_adder ha11 (p0[1],p1[0],s11,c11);
    full_adder fa12(p0[2],p1[1],p2[0],s12,c12);
    full_adder fa13(p0[3],p1[2],p2[1],s13,c13);
    full_adder fa14(p1[3],p2[2],p3[1],s14,c14);
    half_adder ha15(p2[3],p3[2],s15,c15);

//second stage
    half_adder ha22 (c11,s12,s22,c22);
    full_adder fa23 (p3[0],c12,s13,s23,c23);
    full_adder fa24 (c13,c23,s14,s24,c24);
    full_adder fa25 (c14,c24,s15,s25,c25);
    full_adder fa26 (c15,c25,p3[3],s26,c26);

//third stage Kogge Stone Adder
 ksa4 wks1({c26,c25,c24,c23,c22},{0,s26,s25,s24,s23},{s37,s36,s35,s34,s32},c37);


endmodule

module wksa_tb;
wire [7:0] prod;
reg [3:0] A,B;
Wallace_KSA w1(A,B,prod);
initial begin
#5 A=4'b0000; B=4'b1111;
#5 A=4'b0001; B=4'b1110;
#5 A=4'b0011; B=4'b1100;
#5 A=4'b0100; B=4'b1011;
#5 A=4'b0110; B=4'b1001;
#5 A=4'b1111; B=4'b1111;
#5 A=4'b1111; B=4'b1110;
#5 A=4'b1101; B=4'b1110;

#5 $stop;
end
endmodule	
