module distortion_tb;

    logic [31:0] x;
    logic [31:0] y;
    logic clk_48;
    logic [3:0] options = 4'b1000;
    logic [3:0] en = 4'b1000;
    
    parameter real CLOCK_PERIOD = 20e-6; // 20 microseconds
    int rand_num = 0;
    
    // Instantiate the unit under test
    distortion uut (
        .x(x),
        .y(y),
        .clk_48(clk_48),
        .options(options),
        .en(en)
    );
    
    // Clock generation
    initial begin
        clk_48 = 0;
        forever #(CLOCK_PERIOD/2) clk_48 = ~clk_48;
    end
    
    // Random number generation
    initial begin
        forever begin
            rand_num = $urandom_range(0, 500000);
            x = rand_num;
            #(CLOCK_PERIOD);
        end
    end
    
    // VCD dump
    initial begin
        $dumpfile("distortion_waves.vcd");
        $dumpvars(0, distortion_tb);
    end
    
    // Test sequence
    initial begin
        // Run simulation for a reasonable time
        #(CLOCK_PERIOD * 1000);
        
        // Test different options
        options = 4'b0100;
        #(CLOCK_PERIOD * 100);
        
        options = 4'b0010;
        #(CLOCK_PERIOD * 100);
        
        options = 4'b0001;
        #(CLOCK_PERIOD * 100);
        
        $finish;
    end
    
    // Intermediate nets for monitoring
    wire signed [15:0] x_signed = signed'(x);
    wire signed [15:0] y_signed = signed'(y);
    
    // Monitor output
    initial begin
        $monitor("Time: %0t, x: %d, y: %d, options: %b", $time, x_signed, y_signed, options);
    end

endmodule
