#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vf1.h"
#include "vbuddy.cpp"     // include vbuddy code

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
    int simcyc;     // Simulation clock count
    int tick;       // Each clk cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);

    // Initialize top Verilog instance
    Vf1 *top = new Vf1;

    // Initialize trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("f1.vcd");

    // Initialize Vbuddy
    if (vbdOpen() != 1) return -1;
    vbdHeader("L3T4:F1");

    // Initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->N = 36;
    vbdSetMode(0);

    bool watch_started = false; // State flag to detect if stopwatch has started

    // Run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++) {
        // Dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++) {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        // Set up the reset signal for the first few cycles
        top->rst = (simcyc < 2); // Assert reset for the first cycle

        // Display the LED states on Vbuddy bar
        vbdBar(top->data_out & 0xFF);

        // Detect when all lights are OFF (data_out == 0) to start reaction time measurement
        if (top->data_out == 0 && !watch_started) {
            vbdInitWatch();     // Start Vbuddy stopwatch when lights go OFF
            watch_started = true; // Update flag to indicate stopwatch started
        }

        // Check if user pressed the button in Vbuddy to record reaction time
        if (vbdFlag() && watch_started) {
            int elapsed_time = vbdElapsed(); // Get the elapsed reaction time

            // Display reaction time as a four-digit decimal using vbdHex
            vbdHex(4, (elapsed_time / 1000) % 10);  // Thousands place
            vbdHex(3, (elapsed_time / 100) % 10);   // Hundreds place
            vbdHex(2, (elapsed_time / 10) % 10);    // Tens place
            vbdHex(1, elapsed_time % 10);           // Ones place

            watch_started = false; // Reset the watch flag for next cycle
        }

        // Trigger FSM based on the flag in Vbuddy
        top->fsm_trigger = vbdFlag();

        // Allow simulation to exit on command
        if (Verilated::gotFinish()) exit(0);
    }

    // Close Vbuddy and VCD file
    vbdClose();
    tfp->close();
    delete top;
    exit(0);
}
