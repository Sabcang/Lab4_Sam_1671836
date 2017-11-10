onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alustim/ALU_PASS_B
add wave -noupdate /alustim/ALU_ADD
add wave -noupdate /alustim/ALU_SUBTRACT
add wave -noupdate /alustim/ALU_AND
add wave -noupdate /alustim/ALU_OR
add wave -noupdate /alustim/ALU_XOR
add wave -noupdate -radix decimal /alustim/A
add wave -noupdate -radix decimal /alustim/B
add wave -noupdate /alustim/cntrl
add wave -noupdate -radix decimal /alustim/result
add wave -noupdate /alustim/negative
add wave -noupdate /alustim/zero
add wave -noupdate /alustim/overflow
add wave -noupdate /alustim/carry_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10700000600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 66
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
WaveRestoreZoom {0 ps} {32023431300 ps}
