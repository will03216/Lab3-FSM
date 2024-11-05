#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vf1_light_system.h"

#include "vbuddy.cpp" // Vbuddy库文件
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env)
{
    int simcyc;     // 仿真时钟计数
    int tick;       // 每个时钟周期包含两个tick
    Verilated::commandArgs(argc, argv);

    // 初始化顶层实例
    Vf1_light_system *top = new Vf1_light_system;

    // 初始化 VCD 文件
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("f1_light_system.vcd");

    // 初始化 Vbuddy
    if (vbdOpen() != 1) return -1;
    vbdHeader("F1 Light System");

    // 初始化仿真输入
    top->clk = 1;
    top->rst = 1;

    // 仿真循环
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // 时钟周期内的上升沿和下降沿
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        // 复位仅在前两个周期内有效
        top->rst = (simcyc < 2);

        // 将当前灯状态输出到 Vbuddy
        vbdBar(top->data_out & 0xFF);  // 确保仅输出 8 位状态
        vbdCycle(simcyc);

        if (Verilated::gotFinish()) exit(0);
    }

    vbdClose(); // 关闭 Vbuddy
    tfp->close();
    exit(0);
}
