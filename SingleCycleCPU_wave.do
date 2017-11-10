onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /SingleCycleCPU_testbench/clk
add wave -noupdate /SingleCycleCPU_testbench/reset
add wave -noupdate /SingleCycleCPU_testbench/i
add wave -noupdate -radix hexadecimal /SingleCycleCPU_testbench/dut/nextData
add wave -noupdate -radix unsigned /SingleCycleCPU_testbench/dut/Db
add wave -noupdate -radix binary /SingleCycleCPU_testbench/dut/instruction
add wave -noupdate -radix decimal /SingleCycleCPU_testbench/dut/instruAddress
add wave -noupdate -radix decimal /SingleCycleCPU_testbench/dut/ALUA
add wave -noupdate -radix decimal /SingleCycleCPU_testbench/dut/ALUB
add wave -noupdate -radix decimal /SingleCycleCPU_testbench/dut/AluResult
add wave -noupdate -radix decimal /SingleCycleCPU_testbench/dut/dataFromMem
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[0]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[1]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[2]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[3]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[4]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[5]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[6]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[7]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[8]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[9]/regs/regToOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[10]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[11]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[12]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[13]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[14]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[15]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[16]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[17]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[18]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[19]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[20]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[21]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[22]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[23]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[24]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[25]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[26]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[27]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[28]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[29]/regs/dataOut}
add wave -noupdate -radix decimal {/SingleCycleCPU_testbench/dut/rf/eachReg[30]/regs/dataOut}
add wave -noupdate -radix decimal /SingleCycleCPU_testbench/dut/rf/x31/dataOut
add wave -noupdate /SingleCycleCPU_testbench/dut/zero
add wave -noupdate /SingleCycleCPU_testbench/dut/overflow
add wave -noupdate /SingleCycleCPU_testbench/dut/carryout
add wave -noupdate /SingleCycleCPU_testbench/dut/negative
add wave -noupdate -expand /SingleCycleCPU_testbench/dut/dm/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2444273370 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 348
configure wave -valuecolwidth 92
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2435073722 ps} {2449624560 ps}
