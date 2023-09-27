/* ACM Class System (I) Fall Assignment 1 
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module adder(
	input  [15:0] a,
	input  [15:0] b,
	output [15:0] sum,
	output        c
);

	adder16 Add(a, b, 1'b0, sum, c);

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
    assign C[4] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))));

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
	output						c_out
	//output						Px,
	//output						Gx
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

	assign c_out = C[4];

endmodule