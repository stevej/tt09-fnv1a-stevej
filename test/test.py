# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 20

    # Wait for two clock cycles to see the output values
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0b11101011

    # If we update the value, the LRC changes
    dut.ui_in.value = 21
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0b11111111

    # If we don't update the value, the LRC does not change
    await ClockCycles(dut.clk, 10)
    assert dut.uo_out.value == 0b11111111

    # Make a change, check that the LRC updates
    dut.ui_in.value = 22
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0b11101010
