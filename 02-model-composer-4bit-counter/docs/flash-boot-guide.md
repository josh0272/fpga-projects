# Program the Basys 3 SPI flash — GUI-only repeatable guide

**Tested 15 October 2026 on Vivado 2025.1 / Basys 3.** Follow this after a counter/design works when programmed from a laptop. It preserves the circuit across power cycles by storing the configuration in onboard SPI flash.

> **Before starting:** Flash erase/program replaces the saved configuration (possibly including the factory demo). Keep copies of files you want. Simply generating MCS does **not** program hardware.

## 1. Confirm the implemented design works

1. Open the Vivado `.xpr` project exported by Model Composer.
2. Check active XDC files include the FPGA **100 MHz clock** pin `W5` and `LVCMOS33` IOSTANDARD for scalar top-level `clk`. Keep one valid `create_clock -name clk -period 10.0000000 [get_ports clk]` (no duplicates). Confirm slide switch and LED constraints.
3. Run **Generate Bitstream**; ensure it completes.
4. **Hardware Manager → Open Target → Auto Connect → Program Device** with the resulting `.bit`. Test actual output on the FPGA.
5. Locate the complete `.bit` in your Vivado project’s `subsystem.runs/impl_1/subsystem.bit`, not inside an unrelated IP-only folder. `impl_1` means **Implementation Run 1**.

## 2. Create the flash `.mcs` file

1. Menu **Tools → Generate Memory Configuration File** (opens **Write Memory Configuration File**).
2. Choose **Format: MCS**.
3. Set **Custom Memory Size (MB): 4** (the S25FL032P flash is 32 Mbit = 4 MB), or select the matching memory device.
4. Enter a **Filename** such as `counter_flash.mcs` in an existing folder: this is the *output* file name.
5. **Interface: SPIx1** for this verified `subsystem.bit`. Why? The project’s bitstream had `SPI_BUSWIDTH = 1`. The flash's name includes x4 because the *chip* can support it, not because this `.bit` was built for it.
6. Tick **Load bitstream files** and browse to the **working `subsystem.bit`** in `impl_1`.
7. Keep **Start address = 00000000**, **Direction = up**, and leave Daisy-chain and Load data files off.
8. Click **OK**; ensure the MCS file is created successfully.

## 3. Program the onboard flash, not just the FPGA

1. Connect the powered Basys 3 to your PC. **Hardware Manager → Open Target → Auto Connect**.
2. In the **Hardware** panel, expand **localhost → xilinx_tcf/Digilent/... → xc7a35t_0**.
3. Find `s25fl032p-spi-x1_x2_x4` listed **beneath the FPGA**, alongside **XADC (System Monitor)**.
4. If **already present**, right-click this flash entry → **Program Configuration Memory Device**. **Do not add a duplicate**. If truly absent, right-click the FPGA → **Add Configuration Memory Device** and select `s25fl032p-spi-x1_x2_x4`.
5. Select your `.mcs` file. **Address Range: Configuration File Only**. Ensure **Erase**, **Program**, **Verify** are checked.
6. Click **OK**; wait for **Flash programming completed successfully**.

## 4. Test completely standalone

1. Switch Basys 3 **OFF**.
2. Set physical jumper **JP1 = SPI Flash/QSPI** using the actual printed board label/manual; avoid guessing orientation. Set **JP2 = USB** when powering through **J4**.
3. Disconnect laptop; plug a USB power bank into the board’s **J4 Micro-USB power/programming port**; switch board **ON**.
4. Confirm **power LED** then **DONE LED**. The power LED alone is not enough: DONE signals successful FPGA configuration.
5. Test functional outputs. Our counter uses **SW15 reset**, **SW14 enable**, and **LD15, LD10, LD5, LD0**.

## If something goes wrong

| Error / symptom | Resolution |
|---|---|
| `[Writecfgmem 68-20] SPI_BUSWIDTH ... 1 ... SPIX4` | The selected `.bit` was built for SPIx1. Set the MCS dialog interface to **SPIx1**. Don't regenerate with SPIx4 unless the bitstream itself is rebuilt/configured accordingly. |
| **Add Configuration Memory Device** greyed out | Often the flash was **already added**. Click the little **maximise** icon in the Hardware pane, expand `xc7a35t_0`, and right-click `s25fl032p-spi-x1_x2_x4`. This exact fix worked. |
| Hardware Target shutdown | Reconnect via **Open Target → Auto Connect** if the target actually closed. |
| **Program Device** succeeds but standalone boot doesn't | Programmed SRAM is volatile. You must **program flash**, switch **JP1 = SPI Flash**, then power-cycle. Check **DONE**. |
| `[DRC UCIO-1]` / `[DRC NSTD-1]` for `clk` | Check W5 package pin, LVCMOS33 and one 10 ns clock timing constraint; see `constraints/basys3_counter_reference.xdc`. |
| `[Constraints 18-513] set_multicycle_path` | Separate timing-exception warning seen in the original project; inspect constraint paths rather than treating timing as fully verified. |
| PC freezes simulating a 2 Hz output | Don't simulate billions of 100 MHz cycles in Simulink. Design a hardware clock enable/divider or use a smaller simulation stop time. |

## Going back to JTAG development

You can **leave JP1 on SPI Flash and still use JTAG**, but you can move it back to **JTAG** with power **off** for regular development. Programming another `.bit` via **Hardware Manager → Program Device** does **not** erase flash; setting JP1 to SPI Flash and power-cycling reloads the saved counter. Only another flash programming operation replaces it.

## Record for each new flash project

- Project/name/date:
- Vivado project and `.bit` path:
- `.mcs` path:
- SPI width and flash memory part:
- Flash Erase / Program / Verify result:
- DONE LED after power cycle:
- Actual design test:

**Related:** [Full Notion guide](https://app.notion.com/p/3faf247c372281958703fe9b4b28a10b) · [Digilent Basys 3 reference manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual).
