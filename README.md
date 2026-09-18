# ece_481_lab3
Files
src/counter.sv - part a counter. parameterized width, counts up/down, sync reset, enable, wraps around
sim/tb_counter.sv - testbench for the counter. checks reset, hold, up/down counting, overflow, underflow, for WIDTH=4 and WIDTH=8
src/register_bank.sv - part b. M registers of W bits, parameterized. sync write, async read
sim/tb_register_bank.sv - testbench for the register bank. checks reset, write/read, reading out of order, persistence, overwrite, async read, read-after-write, for M=4/W=8 and M=8/W=4
src/tick_generator.sv - part c. makes a one-cycle pulse periodically so the counter isnt running at full 100MHz
src/lab3_top.sv - part c top level, connects tick generator + counter to the Basys3 switches/button/LEDs
constr/Basys3.xdc - pin constraints for clk, sw[0], sw[1], led[0:3], btnC
lab3_report.pdf - report with waveforms, screenshots, block diagrams, timing results, hardware photos
How to run
open the vivado project
add src/ files as design sources, sim/ files as simulation sources, constr/Basys3.xdc as constraints
part a: run sim on tb_counter, check tcl console for ALL TESTS PASSED
part b: same, on tb_register_bank
part c: set lab3_top as top, run synthesis/implementation/bitstream, check WNS in timing report, program the board
on hardware: btnC resets, sw[1] sets direction, sw[0] enables counting, led[3:0] shows the count
Problems

Register bank testbench had a race condition - the testbench changed wr_en/rst on the same clock edge the DUT reacted to, so writes/resets sometimes didnt register. Fixed with a #1 delay after each @(posedge clk) in the testbench before changing signals.

Also had issues where Vivado wasnt recompiling after edits because "Run All" reuses the old compiled sim instead of relaunching it.