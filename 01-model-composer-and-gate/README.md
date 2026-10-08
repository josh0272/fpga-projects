# Basys 3 Model Composer AND Gate

My first end-to-end FPGA project using **AMD Vitis Model Composer** and **Vivado**. A two-input AND gate is created as a Simulink/Model Composer subsystem, exported to **Verilog**, synthesized and implemented for the **Digilent Basys 3**, and tested on real hardware.

## What it does

Two Basys 3 slide switches drive the two inputs. LED0 displays the registered AND result.

| SW0 | SW1 | LED0 |
|---:|---:|---:|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

The Model Composer Logical block was configured with **latency = 1**, so the AND result passes through one flip-flop before reaching the LED.

## Hardware and tools

- Digilent **Basys 3**
- Xilinx/AMD **Artix-7 XC7A35T-1CPG236C**
- **Vitis Model Composer 2025.1**
- **Vivado 2025.1**
- Generated HDL language: **Verilog**
- FPGA clock: **100 MHz**

## FPGA I/O mapping

| Signal | Basys 3 resource | FPGA pin |
|---|---|---|
| `gateway_in[0]` | SW0 | V17 |
| `gateway_in1[0]` | SW1 | V16 |
| `clk` | 100 MHz oscillator | W5 |
| `gateway_out[0]` | LED0 | U16 |

All user I/O uses `LVCMOS33`.

## Design flow

```text
Simulink / Vitis Model Composer
            |
            v
      Little_Logic subsystem
            |
            v
     Generated Verilog HDL
            |
            v
       Vivado synthesis
            |
            v
  Implementation / place & route
            |
            v
       Bitstream generation
            |
            v
          Basys 3
```

## Where the AND gate appears in the generated Verilog

Model Composer wraps the logical operation in a generated module named `sysgen_logical_de1f85cd97`.

The top-level structural file instantiates it in `generated_hdl/little_logic.v`:

```verilog
sysgen_logical_de1f85cd97 logical (
    .clr(1'b0),
    .d0(gateway_in_net),
    .d1(gateway_in1_net),
    .clk(clk_net),
    .ce(ce_net),
    .y(logical_y_net)
);
```

The actual Boolean AND is visible in `generated_hdl/little_logic_entity_declarations.v`:

```verilog
assign fully_2_1_bit = d0_1_24 & d1_1_27;
```

The generated block also contains a register stage, matching the one-cycle latency configured in Model Composer.

## Synthesis result

Vivado 2025.1 synthesized the design for `xc7a35tcpg236-1` using approximately:

| Primitive/resource | Used |
|---|---:|
| LUT | 1 |
| Flip-flop | 1 |
| BUFG | 1 |
| Input buffers | 3 |
| Output buffers | 1 |

## Repository structure

```text
01-model-composer-and-gate/
├── model/
│   └── first_model.slx
├── generated_hdl/
│   ├── little_logic.v
│   ├── little_logic_entity_declarations.v
│   └── ... Model Composer support HDL
├── constraints/
│   └── little_logic_clock.xdc
├── reports/
│   └── little_logic_utilization_synth.rpt
├── scripts/
│   └── create_vivado_project.tcl
└── README.md
```

## Rebuilding in Vivado

From a Vivado-enabled command prompt inside this project folder:

```bash
vivado -mode batch -source scripts/create_vivado_project.tcl
```

The script creates a fresh Vivado project under `build/vivado`, runs synthesis and implementation, and generates a bitstream.

> **Path note:** Model Composer can fail when its export path contains spaces. Keeping the working/project path free of spaces avoids that issue.

## Hardware verification

The design was programmed onto a Basys 3 and tested using the physical switches:

- neither switch on -> LED0 off
- either switch on alone -> LED0 off
- both switches on -> LED0 on

This verifies the complete flow from graphical FPGA design through generated HDL, synthesis, implementation, bitstream generation, and physical hardware operation.

## Build note

The Model Composer-generated clock constraint initially referred to `clk[0]`, while the generated top-level Verilog declares `clk` as a scalar. The checked-in XDC uses the corrected scalar constraint:

```tcl
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
```

This removed Vivado's `UCIO-1` unconstrained-port issue for the clock.
