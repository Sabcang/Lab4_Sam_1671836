# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./alu.sv"
vlog "./regfile.sv"
vlog "./decoder1_32.sv"
vlog "./Multiplexor.sv"
vlog "./ProgramCounter.sv"
vlog "./PipliningCPU.sv"
vlog "./shifting_reg_3bit.sv"
vlog "./SE.sv"
vlog "./math.sv"
vlog "./alustim.sv"
vlog "./SingleCycleCPU_testbench.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work SingleCycleCPU_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do SingleCycleCPU_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
