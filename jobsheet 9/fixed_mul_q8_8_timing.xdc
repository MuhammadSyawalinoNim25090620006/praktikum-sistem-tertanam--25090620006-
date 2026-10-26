# Virtual clock: periode 10 ns = 100 MHz
create_clock -name virtual_clk -period 10.000

# Constraint input
set_input_delay -clock virtual_clk -max 0.000 [get_ports {a[*] b[*]}]
set_input_delay -clock virtual_clk -min 0.000 [get_ports {a[*] b[*]}]

# Constraint output
set_output_delay -clock virtual_clk -max 0.000 [get_ports {result[*]}]
set_output_delay -clock virtual_clk -min 0.000 [get_ports {result[*]}]