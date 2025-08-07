# crc16_fault_sweep


# 🔄 CRC16 Fault Sweep (Verilog + Automation)

This project automates **bit-level fault injection** for a 16-bit CRC generator by sweeping **all fault bit positions**, both stuck-at-0 and stuck-at-1. It’s ideal for **reliability testing**, **DFT coverage analysis**, and **ATE vector generation**.

---

## 📁 Files

```

├── crc16\_fault.v                    # CRC module with parametric fault injection
├── testbench\_fault\_sweep.sv        # Testbench for sweeping all fault bits
├── crc\_fault\_sweep.csv             # Output: CRC results for each swept fault case
├── csv\_to\_stil\_fault\_sweep.py      # Python script: convert CSV to STIL format
├── crc\_fault\_sweep\_fixed.stil      # ATE-ready STIL pattern file
└── README.md                       # Project overview

````

---

## 🧠 What It Does

- Sweeps **each bit** of the 16-bit input (`data_in`)
- Applies **both** stuck-at-0 and stuck-at-1 faults
- Logs each fault configuration and CRC result
- Generates **ATE-ready** STIL file from results

---

## ▶️ Run the Simulation

```bash
iverilog -g2012 crc16_fault.v testbench_fault_sweep.sv
vvp a.out
````

This produces `crc_fault_sweep.csv`, formatted like:

```
Time_ns,Data_in,FaultBit,FaultType,FaultMask,FaultValue,CRC_out
25000,A5A5,0,stuck-at-0,0001,0000,FFFE
45000,A5A5,0,stuck-at-1,0001,0001,FFFC
...
```

---

## 🔁 Convert to STIL (ATE Ready)

```bash
python csv_to_stil_fault_sweep.py
```

This generates the `crc_fault_sweep_fixed.stil` pattern file for test equipment.

---

## 🎯 Use Cases

* Automated **fault modeling** with full sweep coverage
* STIL pattern generation for ATE evaluation
* **DFT validation** with predictable fault behavior
* Advanced CRC-based **fault detection studies**

---

## 📎 Related Project

If you want a **manual, simpler version** of this fault modeling project (without sweeping), visit:

👉 [CRC16 Fault Injection Repo](https://github.com/mstarefinaktar/crc16_fault_injection)

---

## 📄 License

MIT License — Free for academic, research, and commercial use with attribution.


