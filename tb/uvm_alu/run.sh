#!/bin/bash
# Chay UVM testbench cho alu bang Questa FSE.
# Dung: ./run.sh            (chay test mac dinh alu_test)
#       ./run.sh <ten_test> (chay test khac)

Q=/home/thu/altera_lite/25.1std/questa_fse/linux_x86_64
export SALT_LICENSE_SERVER=/home/thu/.altera.quartus/questa_lic.dat
TEST=${1:-alu_test}

cd "$(dirname "$0")" || exit 1

rm -rf work transcript vsim.wlf
$Q/vlib work > /dev/null || exit 1

# RTL dung chung voi project, khong chep ban sao
$Q/vlog -work work -sv ../../rtl/alu.v alu_if.sv alu_pkg.sv top.sv || exit 1

$Q/vsim -c -work work top +UVM_TESTNAME=$TEST -do "run -all; quit"
