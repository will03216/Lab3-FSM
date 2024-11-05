#include "Vf1_fsm.h"      // 自动生成的 FSM 顶层模块
#include "verilated.h"
#include "vbuddy.cpp"     // Vbuddy 库文件

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vf1_fsm* top = new Vf1_fsm;

    // 初始化 Vbuddy
    if (vbdOpen() != 1) return -1;
    vbdHeader("F1 Light Sequence");

    top->clk = 0;
    top->rst = 1;
    top->en = 0;

    // 复位 FSM
    for (int i = 0; i < 10; i++) {
        top->clk = !top->clk;
        top->eval();
    }
    top->rst = 0;

    while (!Verilated::gotFinish()) {
        // 每个时钟周期切换时钟信号
        top->clk = !top->clk;

        // 控制 FSM 的使能信号
        if (vbdFlag()) {          // 读取旋转开关的输入
            top->en = 1;
        } else {
            top->en = 0;
        }

        // 评估 FSM 的状态
        top->eval();

        // 将 FSM 输出显示在 neopixel 灯条上
        vbdBar(top->data_out & 0xFF);  // 确保输出为 8 位

        // 小延时，确保稳定显示
        vbdCycle(1);
    }

    vbdClose();    // 关闭 Vbuddy
    delete top;    // 释放资源
    return 0;
}

