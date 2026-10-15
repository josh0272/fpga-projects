# Tutorial 2 — Sample Delay in Model Composer

**Separate exercise from the four-bit counter.** This entry comes from the uploaded `Tutorial_2.zip`. The two Simulink models and their HDL exports were inspected and separated rather than mixing the delay example into the counter.

## Actual source files in the archive

- **Original Simulink model:** `delay_block.slx`
- **Model Composer export:** `netlist_delay_block/ip/Sample_Delay/src/`
- **Generated top-level Verilog:** `sample_delay.v`, top module `sample_delay`
- **Vivado project:** `sample_delay.xpr`
- **Target:** Digilent Basys 3 (Artix-7 XC7A35T), 100 MHz clock, Vivado / Vitis Model Composer 2025.1.

The original binary Simulink model and vendor-generated support HDL are included in the **separate downloadable source bundle**, rather than reproduced in this public repository. AMD-generated support modules are marked proprietary in their file headers.

## What the design does

A **Step** stimulus drives a **Gateway In → Delay → Gateway Out** path, observed using a Time Scope. The Model Composer-generated Verilog confirms:

- Data width: **1 bit** at the exported gateway;
- Delay block **latency = 4 samples**;
- Gateway sample period **`1/100e6` seconds = 10 ns**;
- Clock rate **100 MHz** (one sample per clock cycle).

So, for this exported version, the nominal pipeline delay is:

```text
delay = latency × sample period = 4 × 10 ns = 40 ns
```

The delay is **four samples**, which happens also to equal four clock cycles in this specific file. In general, a Model Composer sample may span multiple clock cycles.

### Signal flow

```text
Step → Gateway In → 4-sample Delay → Gateway Out → Time Scope
                     |
                 HDL export
                     |
             Vivado implementation
```

## Implementation status — important

The archive contains a Vivado project, generated HDL, and synthesis/implementation reports for this delay exercise. **It does not contain a completed `sample_delay.bit` or evidence of a successful physical-board demonstration.**

The routed DRC report for `sample_delay` includes **UCIO-1 and NSTD-1 critical warnings**: `gateway_in[0]` and `gateway_out[0]` have missing external pin assignments and I/O standards. The clock is mapped to W5 and LVCMOS33. Consequently, **this is documented as a simulation/HDL/implementation exercise—not a proven standalone board design**.

If you decide to test it on hardware, connect input/output to valid Basys 3 switch/LED pins, specify `LVCMOS33` for all ports, verify the constraints, rerun DRC and generate a bitstream.

## What I learned

- A Model Composer **sample period** is distinct from its fundamental clock.
- Delay **latency is expressed in samples**, not automatically in system clock cycles.
- FPGA implementation timing results are not enough on their own: **I/O pin constraints are required to generate a safe, usable bitstream**.
- Model Composer outputs generated RTL and a Vivado project; keep source models and the right export separate from transient build caches.

## Repository note

Only the hand-written project documentation is committed here. The unmodified `delay_block.slx` source model and the vendor HDL/report files are preserved in the accompanying **`03-model-composer-sample-delay-source-bundle.zip`** delivered in chat. A source model can be added to the repository separately after reviewing contents and licensing.

See the related [four-bit counter project](../02-model-composer-4bit-counter/) for the complete verified hardware and SPI-flash boot workflow.

## Build checklist

- [ ] Open `delay_block.slx` in Simulink with Model Composer 2025.1.
- [ ] Inspect/verify the four-sample delay at 10 ns sampling.
- [ ] Export HDL and verify the top-level `sample_delay` ports.
- [ ] For board use, assign input/output pins and IOSTANDARD correctly.
- [ ] Synthesize, run DRC and timing analysis, then generate bitstream only when safe.
