`timescale 1ns/1ps

module tb_fir;

// 1. Declare inputs as 'reg' and outputs as 'wire'
reg clk;
reg signed [15:0] x;
wire signed [35:0] y;

// Coefficient inputs (User programmable)
reg signed [15:0] h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10;

// 2. Instantiate the Unit Under Test (UUT)
fir_11tap_cshm uut(
    .clk(clk), 
    .x(x),
    .h0(h0), .h1(h1), .h2(h2), .h3(h3), .h4(h4),
    .h5(h5), .h6(h6), .h7(h7), .h8(h8), .h9(h9), .h10(h10),
    .y(y)
);

// 3. Clock Generation (350 MHz equivalent approx, 10ns period = 100MHz for easy viewing)
initial clk = 0;
always #5 clk = ~clk; 

// ==========================================
// 4. TASKS: Filter Coefficient Configurations
// ==========================================

task load_LPF;
// Low Pass Filter
begin
    h0=1; h1=2; h2=3; h3=4; h4=5;
    h5=6; h6=5; h7=4; h8=3; h9=2; h10=1;
end
endtask

task load_HPF;
// High Pass Filter
begin
    h0=-1; h1=-1; h2=-1; h3=-1; h4=8;
    h5=-1; h6=-1; h7=-1; h8=-1; h9=-1; h10=0;
end
endtask

task load_BPF;
// Band Pass Filter
begin
    h0=0; h1=1; h2=0; h3=-2; h4=0;
    h5=4; h6=0; h7=-2; h8=0; h9=1; h10=0;
end
endtask

task load_BSF;
// Band Stop Filter
begin
    h0=1; h1=0; h2=-1; h3=0; h4=2;
    h5=-4; h6=2; h7=0; h8=-1; h9=0; h10=1;
end
endtask

// ==========================================
// 5. TASK: Input Signal Generation
// ==========================================
task apply_signal;
integer i;
begin
    // Generate 40 samples of a square wave
    for(i=0; i<40; i=i+1) begin
        @(posedge clk);
        // Creates an alternating signal: 5 positive samples, 5 negative samples...
        x = (i%10 < 5) ? 50 : -50; 
    end
end
endtask

// ==========================================
// 6. MAIN SIMULATION BLOCK
// ==========================================
initial begin
    // Setup waveform dumping for GTKWave / SimVision
    $dumpfile("fir_filter_waves.vcd");
    $dumpvars(0, tb_fir);

    // Initialize input
    x = 0;
    #10;

    // Test 1: Configure as Low Pass Filter
    $display("--- Testing LOW PASS FILTER ---");
    load_LPF;
    apply_signal;

    // Test 2: Configure as High Pass Filter
    $display("--- Testing HIGH PASS FILTER ---");
    load_HPF;
    apply_signal;

    // Test 3: Configure as Band Pass Filter
    $display("--- Testing BAND PASS FILTER ---");
    load_BPF;
    apply_signal;

    // Test 4: Configure as Band Stop Filter
    $display("--- Testing BAND STOP FILTER ---");
    load_BSF;
    apply_signal;

    // End simulation
    #100 $finish;
end

endmodule
