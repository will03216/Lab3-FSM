#!/bin/bash

# 清理上次编译的文件
rm -rf obj_dir
rm -f f1_light_system.vcd

# 使用 Verilator 编译 SystemVerilog 模块和 C++ 测试文件
verilator -Wall --cc --trace f1_light_system.sv clktick.sv f1_fsm.sv --exe _f1_light_system_tb.cpp

# 进入 obj_dir 目录并生成可执行文件
make -j -C obj_dir -f Vf1_light_system.mk Vf1_light_system

# 运行仿真程序
./obj_dir/Vf1_light_system
