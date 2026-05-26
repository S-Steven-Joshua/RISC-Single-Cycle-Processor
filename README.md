# RISC-V Single Cycle Processor

## Introduction
This project presents the design and implementation of a **32-bit RISC-V Single Cycle Processor** using **Verilog HDL**. The processor is based on the **RISC-V RV32I instruction set architecture (ISA)** and executes each instruction in a single clock cycle.

The goal of this project is to understand the internal working of a processor by building the complete datapath and control logic from scratch. The design includes essential processor components such as the **Program Counter (PC), Instruction Memory, Register File, ALU, Control Unit, Immediate Generator, Data Memory, and multiplexers** required for instruction execution.

The processor supports fundamental instruction categories including:

- **R-Type Instructions** – arithmetic and logical operations  
- **I-Type Instructions** – immediate arithmetic and load operations  
- **S-Type Instructions** – store operations  
- **B-Type Instructions** – branch instructions  
- **J-Type Instructions** – jump instructions  

This project demonstrates how instructions move through the datapath, how control signals are generated, and how memory and register operations are performed within a single clock cycle architecture.

The design was implemented and verified through simulation using System Verilog testbenches. Additional modules and peripherals may also be integrated to expand the processor functionality further.

---
