#!/bin/bash

# 清理上次编译的文件
rm -rf obj_dir
rm -f clktick.vcd

# 编译 SystemVerilog 模块和 C++ 测试文件
verilator -Wall --cc --trace clktick.sv --exe clktick_tb.cpp

# 进入编译目录 obj_dir 并生成可执行文件
make -j -C obj_dir -f Vclktick.mk Vclktick

# 运行仿真程序
./obj_dir/Vclktick
