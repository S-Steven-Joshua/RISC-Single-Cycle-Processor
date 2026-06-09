# APB Master–Slave Interface (SystemVerilog)

A simple implementation of an **AMBA APB (Advanced Peripheral Bus)** Master and Slave using **SystemVerilog**. This project demonstrates the APB transaction protocol, including the Setup and Access phases, using a finite state machine (FSM) in the master and a simple peripheral slave.

---

## Overview

The design consists of:

- **APB Master**
  - Generates APB transactions
  - Controls `PSEL`, `PENABLE`, `PWRITE`
  - Implements APB protocol using an FSM

- **APB Slave**
  - Receives APB transactions
  - Responds with `PREADY`
  - Captures write data

- **Top Module**
  - Connects the APB Master and APB Slave
  - Demonstrates complete APB communication

---
## APB Protocol
<img width="690" height="455" alt="Image" src="https://github.com/user-attachments/assets/06b75205-d3f4-493e-a421-541ab8027300" />

- **NOTE:HERE BACK TO BACK TRANSACTION IS AVOIDED. WE CAN CHANGE IT IF WE WANT IT**
---
## Output 
