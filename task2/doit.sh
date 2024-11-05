#!/bin/bash

# 清理上次编译的文件
rm -rf obj_dir
rm -f Vf1_fsm.vcd

# 运行 Verilator，将 SystemVerilog 代码转换为 C++
verilator -Wall --cc --trace f1_fsm.sv --exe _f1_fsm_tb.cpp

# 进入 obj_dir 编译目录
make -j -C obj_dir -f Vf1_fsm.mk Vf1_fsm

# 运行仿真程序
./obj_dir/Vf1_fsm

