lint:
	verilator --lint-only -DSIM -Wall -Wno-DECLFILENAME -Wno-MULTITOP *.v
	iverilog -E -Wall -g2012 *.v

all: lint

