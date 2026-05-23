# High-Performance FIR Filter Design Based on Computational Sharing Multiplier (CSHM)

> Full RTL-to-GDSII ASIC implementation of an 11-tap FIR filter using CSHM architecture  
> **90nm CMOS | 200 MHz | DRC-Clean | Zero Timing Violations**  
> EC3152 — Department of ECE & VLSI, IIIT Manipur (Sem 6)

---

## Overview

This project implements a high-performance, multiplier-less 11-tap FIR filter using the **Computational Sharing Multiplier (CSHM)** architecture. Instead of using conventional hardware multipliers, CSHM replaces all multiplications with precomputed shift-and-add operations, reducing area and dynamic power while maintaining 1-output-per-clock throughput.

Three coefficient strategies are designed, implemented, and compared under identical ASIC constraints:
- **Conventional** (user-defined coefficients)
- **Hamming Window** (improved frequency response, exploits symmetry)
- **Sparse Method** (small coefficients zeroed — ~35% area, ~37% power reduction)

---

## Key Results

| Metric | Value |
|---|---|
| Technology Node | 90nm CMOS |
| Clock Frequency | 200 MHz |
| Throughput | 1 output per clock cycle |
| Total Area | 119,952.75 µm² |
| Total Power | 16.808 mW |
| Critical Path Delay | 4.77 ns |
| Pre-CTS Setup WNS | +0.001 ns (0 violations) |
| Post-CTS Hold WNS | 0.000 ns (0 violations) |
| Routing Overflow | 0.00% (H and V) |
| Layout Density | 86.068% (post-CTS) |
| Standard Multiplications | **0** (multiplier-less) |
| DRC Status | **Clean** |

### vs. Reference Paper (Park et al., 2003)

| Metric | Paper (8-tap) | This Work (11-tap) | Result |
|---|---|---|---|
| Total Power | 83.69 mW | 16.808 mW | **80% reduction** |
| Total Area | 132,185 µm² | 119,952 µm² | **9% improvement** |
| Throughput | 1 cycle | 1 cycle | Maintained |

---

## Architecture

The design is a **7-stage pipeline**:

```
Input → Delay Line (11-tap shift register)
      → Precompute Unit (x1, x3, x5, x7, x9, x11, x13, x15)
      → Select Unit (16-way MUX per 4-bit coefficient segment)
      → CSHM Multiplier (Shift + Add, CSA pipeline)
      → Pipeline Stage 1 (Register)
      → Adder Tree (Transposed accumulation)
      → Pipeline Stage 2 (Output Register)
      → y[n]
```

### Module Hierarchy

```
fir_11tap_cshm.v         ← Top-level: 11 CSHM multipliers + transposed adder tree
├── precompute.v         ← Generates odd multiples: x1, x3, x5...x15
├── cshm_mult.v          ← Coefficient-based multiplier (4 × select_unit + CSA)
│   └── select_unit.v   ← 16-way MUX: maps 4-bit coeff segment → precomputed value
└── tb_fir_cshm.v        ← Testbench with golden model (MATCH/MISMATCH verification)
```

---

## RTL Files

| File | Description |
|---|---|
| `precompute.v` | Precompute unit — generates odd multiples of input |
| `select_unit.v` | 16-way combinational MUX driven by 4-bit coefficient segment |
| `cshm_mult.v` | CSHM multiplier — CSA-based 2-stage pipeline |
| `fir_11tap_cshm.v` | Top-level 11-tap FIR filter with transposed accumulation |
| `tb_fir_cshm.v` | Self-checking testbench with golden model comparison |

---

## Simulation

### Run in Cadence SimVision / any Verilog simulator

```bash
# Compile all files
vlog precompute.v select_unit.v cshm_mult.v fir_11tap_cshm.v tb_fir_cshm.v

# Run simulation
vsim tb_fir_cshm
```

### Testbench Output Format
```
Time    Input              Expected    Output    Status
20      0000000000001000   ...         ...       MATCH
```
The testbench instantiates a golden integer model and compares DUT output at every clock — accounting for pipeline latency.

---

## ASIC Flow (Cadence)

| Stage | Tool | Status |
|---|---|---|
| RTL Coding | Verilog | ✅ Done |
| Synthesis | Cadence Genus | ✅ Done |
| Floorplanning | Cadence Innovus | ✅ Done |
| Placement | Cadence Innovus | ✅ Done |
| Clock Tree Synthesis (CTS) | Cadence Innovus | ✅ Done (skew target: 50 ps) |
| Routing | Cadence Innovus | ✅ Done |
| DRC Signoff | Cadence Innovus | ✅ Clean |

**Power Planning:** M8 and M9 metal layers  
**Timing Closure:** Achieved — WNS = +0.001 ns setup, 0 hold violations post-CTS

---

## Screenshots

| Synthesis schematic |<img width="1700" height="901" alt="Screenshot 2026-05-23 180445" src="https://github.com/user-attachments/assets/78ef0067-97bc-4acb-a741-f8a5d547c0b3" />
 |
| Post-CTS layout | <img width="1709" height="966" alt="Screenshot 2026-05-23 180909" src="https://github.com/user-attachments/assets/c01eaac8-d0d9-4b07-baa0-ade6276c1738" />
 |
| Pre/Post CTS timing report | <img width="790" height="842" alt="image" src="https://github.com/user-attachments/assets/4f53d2cf-5fc5-4fdd-b348-31aaf661abd9" />
 |
| Simulation waveform | <img width="1920" height="1080" alt="Screenshot from 2026-04-09 06-32-04" src="https://github.com/user-attachments/assets/61dbd663-ce9b-40a6-8443-eb98018e437c" />  <img width="1920" height="1080" alt="Screenshot from 2026-04-09 06-32-13" src="https://github.com/user-attachments/assets/ef07f088-f655-4f76-a7c7-6fa40317fa00" />  <img width="1920" height="1080" alt="Screenshot from 2026-04-09 06-32-19" src="https://github.com/user-attachments/assets/20f02a47-1f49-474a-ae14-74760938b587" />  <img width="1920" height="1080" alt="Screenshot from 2026-04-09 06-32-24" src="https://github.com/user-attachments/assets/73af7c0b-6a0b-42f1-b7c5-4824302df7e6" />  <img width="1920" height="1080" alt="Screenshot from 2026-04-09 06-32-28" src="https://github.com/user-attachments/assets/a92be3c7-2c90-40fb-8804-bc58d021c099" />




 |

---

## Coefficient Strategies Compared

| Strategy | Area | Power | Notes |
|---|---|---|---|
| Conventional | Baseline | Baseline | User-defined, flexible |
| Hamming Window | Moderate | Moderate | Better frequency response, exploits symmetry |
| **Sparse Method** | **~35% less** | **~37% less** | Small coefficients zeroed, minor accuracy trade-off |

---

## Team

| Name | Roll No |
|---|---|
| Ujjwal Kumar | 230104028 |
| Prince Bhardwaj | 230104017 |
| Aryaman Bhardwaj | 230104033 |

**Supervisor:** Dr. Nagesh Ch  
**Course:** EC3152 — ECE & VLSI, Semester 6  
**Institute:** IIIT Manipur

---

## References

1. Park, Muhammad & Roy (2003) — *High-performance FIR filter design based on sharing multiplication*
2. Viswanathan & Parthipan (2012) — *Efficient VLSI Architecture for FIR Filter using CSHM*
3. Sivanantham et al. (2013) — *Low Power Floating Point CSHM for Signal Processing*
4. Weste & Harris — *CMOS VLSI Design: A Circuits and Systems Perspective*



##  Full project report available on request.
