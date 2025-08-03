## Generated SDC file "SNAKE.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"

## DATE    "Tue Jul 22 21:58:11 2025"

##
## DEVICE  "10M50DAF484C7G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {ADC_CLK_10} -period 100.000 -waveform { 0.000 50.000 } [get_ports {ADC_CLK_10}]
create_clock -name {MAX10_CLK1_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {MAX10_CLK1_50}]
create_clock -name {MAX10_CLK2_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {MAX10_CLK2_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {u0|pll|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {u0|pll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 2 -master_clock {MAX10_CLK1_50} [get_pins {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {u0|pll|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {u0|pll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 5000 -master_clock {MAX10_CLK1_50} [get_pins {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[1]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {u0|pll|altpll_component|auto_generated|pll1|clk[0]}]  0.010  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {KEY[0]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {KEY[1]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[0]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[1]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[2]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[3]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[4]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[5]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[6]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[7]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[8]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[9]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[8]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {LEDR[9]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_B[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_B[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_B[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_B[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_G[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_G[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_G[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_G[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_HS}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_R[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_R[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_R[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_R[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {VGA_VS}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

