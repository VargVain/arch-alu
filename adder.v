

module Add(
	input  		[31:0] 			a,
	input  		[31:0] 			b,
	output reg	[31:0] 			sum
);

	wire[31:0] tmp;
	wire g;

	adder16 adder16_1(a[15:0], b[15:0], 1'b0, tmp[15:0], , ,g);
	adder16 adder16_2(a[31:16], b[31:16], g, tmp[31:16], , ,);

	always @(*) #121 sum = tmp;

endmodule

module adder4(
    input       [3:0]           a,
    input       [3:0]           b,
    input                       c_in,
    output      [3:0]           sum,
	output      	            Px,
	output      	            Gx
);

    wire[4:0] C, P, G;

    assign C[0] = c_in;
    assign P = a ^ b;
    assign G = a & b;

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & (G[0] | (P[0] & C[0])));
    assign C[3] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))));
    //assign C[4] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))));

    assign sum[0] = P[0] ^ C[0];
    assign sum[1] = P[1] ^ C[1];
    assign sum[2] = P[2] ^ C[2];
    assign sum[3] = P[3] ^ C[3];

	assign Px = P[0] & P[1] & P[2] & P[3];
	assign Gx = G[3] ^ (P[3] & G[2]) ^ (P[3] & P[2] & G[1]) ^ (P[3] & P[2] & P[1] & G[0]);

endmodule

module adder16(
	input		[15:0]			a,
	input		[15:0]			b,
	input						c_in,
	output		[15:0]			sum,
	output						c_out,
	output						Px,
	output						Gx
);

	wire[4:0] C, P, G;

	assign C[0] = c_in;

	assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & (G[0] | (P[0] & C[0])));
    assign C[3] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))));
    assign C[4] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))));

	adder4 adder4_1(a[3:0], b[3:0], C[0], sum[3:0], P[0], G[0]);
	adder4 adder4_2(a[7:4], b[7:4], C[1], sum[7:4], P[1], G[1]);
	adder4 adder4_3(a[11:8], b[11:8], C[2], sum[11:8], P[2], G[2]);
	adder4 adder4_4(a[15:12], b[15:12], C[3], sum[15:12], P[3], G[3]);

	assign Px = P[0] & P[1] & P[2] & P[3];
	assign Gx = G[3] ^ (P[3] & G[2]) ^ (P[3] & P[2] & G[1]) ^ (P[3] & P[2] & P[1] & G[0]);

	assign c_out = C[4];

endmodule