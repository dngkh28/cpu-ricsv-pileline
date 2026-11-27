#!/bin/bash
# Chay UVM testbench cho hazard_detector bang Questa FSE.
# Dung: ./run.sh            (chay test mac dinh hazard_test)
#       ./run.sh <ten_test> (chay test khac)

Q=/home/thu/altera_lite/25.1std/questa_fse/linux_x86_64
export SALT_LICENSE_SERVER=/home/thu/.altera.quartus/questa_lic.dat
TEST=${1:-brancomp_test}

cd "$(dirname "$0")" || exit 1

rm -rf work transcript vsim.wlf
$Q/vlib work > /dev/null || exit 1

# RTL dung chung voi project, khong chep ban sao
$Q/vlog -work work -sv ../../rtl/branch_comp.v brancomp_if.sv brancomp_pkg.sv top.sv || exit 1

$Q/vsim -c -work work top +UVM_TESTNAME=$TEST -do "run -all; quit"
