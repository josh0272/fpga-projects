# Tutorial 02 — Model Composer 4-Bit Counter (Basys 3)

Second FPGA tutorial in this repository. Built a **4-bit binary up-counter** in **AMD Vitis Model Composer 2025.1**, simulated its output, generated HDL, implemented it with **Vivado 2025.1**, and verified it on a physical **Digilent Basys 3**. Then programmed the onboard **S25FL032P SPI flash** so it boots and operates independently from a **USB power bank**.

**Verified:** 15 October 2026 — successful Vivado flash programming and standalone board operation.

## What it does

- Four LEDs show the unsigned 4-bit binary counter value (0–15, then wrap to 0).
- A slide switch enables counting and another provides reset.
- The FPGA runs from the Basys 3's onboard **100 MHz oscillator**; a slower sample/update rate can be used for observable outputs.
- Unlike ordinary JTAG programming, the final design was also stored in nonvolatile flash and successfully booted without a laptop.

### Controls / physical connections

| Function | Model Composer / Vivado port | Basys 3 | FPGA pin |
|---|---|---|---|
| Clock, 100 MHz | `clk` | Oscillator | `W5` |
| Synchronous reset | `gateway_in[0]` | `SW15` | `R2` |
| Enable | `gateway_in1[0]` | `SW14` | `T1` |
| Count bit 3 (MSB) | `gateway_out[3]` | `LD15` | `L1` |
| Count bit 2 | `gateway_out[2]` | `LD10` | `W3` |
| Count bit 1 | `gateway_out[1]` | `LD5` | `U15` |
| Count bit 0 (LSB) | `gateway_out[0]` | `LD0` | `U16` |

All listed FPGA I/O uses `LVCMOS33`. See [`constraints/basys3_counter_reference.xdc`](constraints/basys3_counter_reference.xdc), which is a **reference**, not a replacement for checking the constraints exported by Model Composer.

## Design and learning objectives

1. Configure a **4-bit unsigned binary Counter** block, with enable and reset, in Model Composer.
2. Understand the distinction between **100 MHz FPGA/system clock (10 ns)** and a slower **sample period** controlling when the counter updates.
3. Simulate in Simulink / Model Composer. During this tutorial an example sample period of `4/100e6` s gives **25 MSamples/s**, while the basic clock stays at 100 MHz.
4. Export generated HDL and open the generated `.xpr` Vivado project.
5. Check physical pin constraints, synthesize, implement, and generate the `.bit`.
6. Program the design via JTAG to test it; then write an `.mcs` image to flash for standalone operation.

```text
Vitis Model Composer / Simulink (counter, reset, enable, gateways)
                         |
                    HDL export
                         |
                  Vivado synthesis
                         |
                Place and route (impl_1)
                         |
                      .bit file
                 ________|________
                |                 |
       Program Device       Generate .mcs
       (volatile JTAG)      + program SPI flash
                |                 |
     Runs with PC connected  Auto-boots on power bank
```

## Key Vivado files

- `subsystem.xpr`: exported Vivado project.
- `subsystem.runs/impl_1/subsystem.bit`: bitstream produced after implementation (`impl_1` means *Implementation Run 1*).
- `subsystem.xdc`: model-generated I/O constraints; `subsystem_clock.xdc`: model-generated clock constraints. **Both must be checked**.
- `counter_flash.mcs` (example output filename): configuration image for nonvolatile SPI flash.

**Important:** `.bit` and `.mcs` are build outputs; they are **not** the Verilog source. The actual Tutorial 2 `.slx` Simulink model and Model Composer generated HDL are **not yet uploaded to this folder**. They must be added from the original local Tutorial 2 project for a full rebuildable example; please do not mistake the XDC reference for the complete design.

## Hardware success and flash programming

The board's flash was identified as **Spansion S25FL032P** (`s25fl032p-spi-x1_x2_x4` in Vivado), capacity **32 Mbit = 4 MB**.

Our existing counter `.bit` was built with **SPI_BUSWIDTH = 1**, so the matching MCS interface for this build was **SPIx1**, *not SPIx4*. We generated the MCS with **MCS**, **4 MB**, **SPIx1**, start address `00000000`, direction **up**, and the fully implemented `subsystem.bit`.

In Vivado **Hardware Manager**, we right-clicked the **existing flash memory device** and selected **Program Configuration Memory Device**, then checked **Erase**, **Program**, and **Verify**. Vivado displayed **“Flash programming completed successfully.”** After setting the physical **JP1 to SPI Flash**, the design ran when powered from a USB power bank through **J4**, with the **JP2 USB power setting**.

Read the full GUI guide (including common problems) in [`docs/flash-boot-guide.md`](docs/flash-boot-guide.md).

## Problems solved

| Symptom | What fixed it |
|---|---|
| `[DRC UCIO-1]` / `[DRC NSTD-1]` for `clk` | Check top-level clock port has physical FPGA pin **W5**, `LVCMOS33`, and correct 10 ns timing constraint. |
| `[Writecfgmem 68-20] SPI_BUSWIDTH ... 1 ... SPIX4` | MCS Interface was SPIx4 but the bitstream was SPIx1. Set MCS Interface **SPIx1**, which successfully generated the MCS without rebuilding. |
| `Add Configuration Memory Device` greyed out | Flash device was already registered; maximise Hardware panel, expand FPGA and right-click the existing S25FL032P device. |
| Power bank lights the board, but nothing runs | FPGA JTAG configuration is volatile; program **SPI flash**, select **JP1 = SPI Flash**, power-cycle and check **DONE LED**. |
| Very slow sample-time simulation freezes PC | Avoid simulating multiple seconds at 100 MHz base rate. Prefer a hardware clock divider/clock enable for visibly slow designs. |

**Unresolved timing follow-up:** An earlier `[Constraints 18-513] set_multicycle_path ... no valid startpoints` warning appeared in `subsystem.xdc:3`. That is separate from the successful flash-programming result and should be investigated before claiming timing is fully verified.

## Returning to normal development

Set **JP1 to JTAG** (with power off) if you want predictable JTAG-first development, though Vivado's JTAG programming is available regardless of the JP1 position. **Hardware Manager → Program Device** loads a new `.bit` temporarily and **does not erase the stored flash image**. To replace the saved auto-booting design, repeat the MCS creation and configuration-memory programming procedure.

## More notes

- [Tutorial 2 — repeatable GUI flash guide in Notion](https://app.notion.com/p/3faf247c372281958703fe9b4b28a10b)
- [Digilent Basys 3 reference manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)


## Original Tutorial 2 ZIP inspection (15 October 2026)

We split the supplied archive into two separate designs; the companion [Sample Delay](../03-model-composer-sample-delay/) is not part of this counter project. See [source inventory](../TUTORIAL_2_SOURCE_INVENTORY.md).

The original counter model is named **`couter_test.slx`** (misspelling preserved). Its Counter and Gateway block sample period is **`1/2` seconds**; generated `subsystem.v` contains a rate/clock-enable period of **50,000,000** base clock cycles at **100 MHz**. This is intended to make updates slow enough to observe without simulating a multisecond interval in Simulink. The generated design uses vendor `c_counter_binary` IP.

**Actual report excerpts:** Vivado routed timing summary at a 10 ns constraint: WNS **+7.181 ns**, WHS **+0.179 ns**, and TNS **0**. Reported synthesis resources include **12 Slice LUTs** and **32 Slice registers**. A routed DRC warning **CFGBVS-1** remains; the earlier Model Composer multicycle-path no-valid-startpoint warning also needs reviewing. These are evidence from the archive, not evidence of fully audited timing exceptions.

**Source-file note:** The supplied `couter_test.slx`, generated AMD/Xilinx support HDL and flash configuration images are preserved in the separately prepared counter source bundle, not yet uploaded into this **public** repository. Generated modules contain vendor licence notices, and the course's third-party PDF has not been republished. This repository includes the hardware wiring and reproducible steps, but **the posted GitHub folder alone is not yet a full source rebuild**.
