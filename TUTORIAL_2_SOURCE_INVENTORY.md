# Verified Tutorial 2 source inventory

The uploaded `Tutorial_2.zip` contains **two separate Simulink models** and two matching Model Composer exports.

| Design | Simulink model | Model Composer HDL export | Hardware evidence |
|---|---|---|---|
| **4-bit counter** | `couter_test.slx` (original filename; typo preserved) | `netlist_counter/ip/Subsystem/src/`, top `subsystem` | `subsystem.bit`, `counter_flash.mcs`, successful standalone boot |
| **Sample delay** | `delay_block.slx` | `netlist_delay_block/ip/Sample_Delay/src/`, top `sample_delay` | Generated HDL and reports only; missing I/O constraints in DRC |

**Source-file availability:** The original binary `.slx` models, bitstream, and AMD/Xilinx-generated support files are in the matching ZIP source bundles delivered in the conversation. Those files **have not been committed to this public GitHub repository**. The ZIP bundles avoid mixing project contents and preserve the originals. No change has been made to the original ZIP.

## Relevant extracted settings

**Counter:** Four-bit unsigned binary up counter, reset and enable inputs, `1/2` second counter block sample period and 100 MHz system clock; includes output pin mappings for the Basys 3. The hardware build compiled with `SPI_BUSWIDTH = 1`; MCS generation therefore worked with `SPIx1`.

**Delay:** Final exported Delay block latency is **4 samples** with sample period `1/100e6` seconds (40 ns total delay). Its Vivado clock input constraints were set, but external gateway I/O ports were not mapped, producing UCIO-1 and NSTD-1 warnings.

## Publishing considerations

- The ZIP includes the tutorial publisher's PDF, which was **not republished** to this public repo.
- Generated AMD/Xilinx support modules include proprietary/licence notices. Do not blindly publish them without checking applicable licence terms.
- Local FPGA build caches, machine-specific paths, Vivado log files, routed checkpoints and timing databases were left out of GitHub.
- The counter's routed timing report records **WNS +7.181 ns, WHS +0.179 ns, TNS 0** at a 10 ns clock target, but earlier Model Composer `set_multicycle_path` constraints produced a missing-startpoint warning requiring review.
- The counter's routed DRC shows a **CFGBVS-1** configuration-voltage warning. The delay exercise additionally has **UCIO-1/NSTD-1** blocking hardware configuration.
